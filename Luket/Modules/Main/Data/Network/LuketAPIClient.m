//
//  LuketAPIClient.m
//  Luket
//

#import "LuketAPIClient.h"
#import "LuketCryptoUtil.h"

static NSString * const LuketAuthTokenKey = @"AppToken";
NSString * const LuketAPIClientErrorDomain = @"im.seex.lobo.api";

typedef NS_ENUM(NSInteger, LuketAPIClientErrorCode) {
    LuketAPIClientErrorCodeInvalidURL = -1000,
    LuketAPIClientErrorCodeInvalidParameters = -1001,
    LuketAPIClientErrorCodeInvalidResponse = -1002,
    LuketAPIClientErrorCodeHTTPStatus = -1003
};

@interface LuketAPIClient ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation LuketAPIClient

+ (instancetype)sharedClient {
    static LuketAPIClient *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[LuketAPIClient alloc] init];
    });
    return client;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseURLString = @"https://app.yykbzdm.com";
        NSURLSessionConfiguration *configuration = NSURLSessionConfiguration.defaultSessionConfiguration;
        configuration.timeoutIntervalForRequest = 15.0;
        configuration.timeoutIntervalForResource = 30.0;
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
      completion:(LuketAPIClientCompletion)completion {
    NSURL *url = [self URLWithPath:path];
    if (!url) {
        [self complete:completion responseObject:nil error:[self errorWithCode:LuketAPIClientErrorCodeInvalidURL message:@"Invalid request URL"]];
        return;
    }
    
    NSDictionary *body = parameters ?: @{};
    if (![NSJSONSerialization isValidJSONObject:body]) {
        [self complete:completion responseObject:nil error:[self errorWithCode:LuketAPIClientErrorCodeInvalidParameters message:@"Invalid request parameters"]];
        return;
    }
    
    NSError *jsonError;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&jsonError];
    if (!bodyData || jsonError) {
        [self complete:completion responseObject:nil error:jsonError ?: [self errorWithCode:LuketAPIClientErrorCodeInvalidParameters message:@"JSON encode failed"]];
        return;
    }
    
    NSData *requestBodyData = bodyData;
    if ([LuketCryptoConfig enableRequestEncryption]) {
        NSString *jsonString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
        NSString *encryptedString = [LuketCryptoUtil encryptText:jsonString key:[LuketCryptoConfig secretKey]];
        NSData *encryptedData = [encryptedString dataUsingEncoding:NSUTF8StringEncoding];
        if (encryptedData.length > 0) {
            requestBodyData = encryptedData;
        }
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestBodyData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [self startRequest:request completion:completion];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
     completion:(LuketAPIClientCompletion)completion {
    NSURL *url = [self URLWithPath:path];
    if (!url) {
        [self complete:completion responseObject:nil error:[self errorWithCode:LuketAPIClientErrorCodeInvalidURL message:@"Invalid request URL"]];
        return;
    }

    NSURL *requestURL = [self URLByAppendingParameters:parameters toURL:url];
    if (!requestURL) {
        [self complete:completion responseObject:nil error:[self errorWithCode:LuketAPIClientErrorCodeInvalidURL message:@"Invalid request URL"]];
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [self startRequest:request completion:completion];
}

- (void)startRequest:(NSURLRequest *)request completion:(LuketAPIClientCompletion)completion {
    NSMutableURLRequest *authorizedRequest = request.mutableCopy;
    [self configureCommonHeadersForRequest:authorizedRequest];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:authorizedRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self complete:completion responseObject:nil error:error];
            return;
        }
        
        NSHTTPURLResponse *httpResponse = [response isKindOfClass:NSHTTPURLResponse.class] ? (NSHTTPURLResponse *)response : nil;
        [self persistAuthTokenFromHTTPResponse:httpResponse];
        NSInteger statusCode = httpResponse.statusCode;
        if (httpResponse && (statusCode < 200 || statusCode >= 300)) {
            NSString *message = [NSString stringWithFormat:@"HTTP status code %ld", (long)statusCode];
            [self complete:completion responseObject:nil error:[self errorWithCode:LuketAPIClientErrorCodeHTTPStatus message:message]];
            return;
        }
        
        if (data.length == 0) {
            [self complete:completion responseObject:nil error:nil];
            return;
        }
        
        NSData *responseData = [self responseDataByDecryptingIfNeeded:data];
        NSError *parseError;
        id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parseError];
        if (!responseObject || parseError) {
            [self complete:completion responseObject:nil error:parseError ?: [self errorWithCode:LuketAPIClientErrorCodeInvalidResponse message:@"JSON parse failed"]];
            return;
        }
        
        [self debugLogResponseObject:responseObject request:authorizedRequest];
        [self complete:completion responseObject:responseObject error:nil];
    }];
    [task resume];
}

- (void)configureCommonHeadersForRequest:(NSMutableURLRequest *)request {
    if (!request) {
        return;
    }

    if (![request valueForHTTPHeaderField:@"Content-Type"]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    [request setValue:@"Look_user" forHTTPHeaderField:@"userType"];

    NSString *token = [NSUserDefaults.standardUserDefaults stringForKey:LuketAuthTokenKey];
    if (token.length > 0) {
        [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    }
}

- (void)persistAuthTokenFromHTTPResponse:(NSHTTPURLResponse *)response {
    if (!response) {
        return;
    }

    id authorization = response.allHeaderFields[@"Authorization"] ?: response.allHeaderFields[@"authorization"];
    if (![authorization isKindOfClass:NSString.class]) {
        return;
    }

    NSString *token = [self normalizedAuthToken:authorization];
    if (token.length == 0) {
        return;
    }

    [NSUserDefaults.standardUserDefaults setObject:token forKey:LuketAuthTokenKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)normalizedAuthToken:(NSString *)token {
    NSString *trimmedToken = [token stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if ([trimmedToken hasPrefix:@"Bearer "]) {
        return [[trimmedToken substringFromIndex:@"Bearer ".length] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    }
    return trimmedToken;
}

- (NSData *)responseDataByDecryptingIfNeeded:(NSData *)data {
    if (![LuketCryptoConfig enableResponseDecryption]) {
        return data;
    }

    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *encryptedString = [self encryptedStringFromResponseString:responseString data:data];
    if (![LuketCryptoUtil isBase64String:encryptedString]) {
        return data;
    }

    NSString *decryptedString = [LuketCryptoUtil decryptText:encryptedString key:[LuketCryptoConfig secretKey]];
    NSData *decryptedData = [decryptedString dataUsingEncoding:NSUTF8StringEncoding];
    return decryptedData.length > 0 ? decryptedData : data;
}

- (NSString *)encryptedStringFromResponseString:(NSString *)responseString data:(NSData *)data {
    NSString *trimmedString = [responseString stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (trimmedString.length == 0) {
        return @"";
    }

    if ([trimmedString hasPrefix:@"\""] && [trimmedString hasSuffix:@"\""]) {
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error];
        if (!error && [jsonObject isKindOfClass:NSString.class]) {
            return jsonObject;
        }
    }

    return trimmedString;
}

- (NSURL *)URLByAppendingParameters:(NSDictionary *)parameters toURL:(NSURL *)url {
    if (parameters.count == 0) {
        return url;
    }

    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    if (!components) {
        return nil;
    }

    NSMutableArray<NSURLQueryItem *> *queryItems = components.queryItems ? components.queryItems.mutableCopy : [NSMutableArray array];
    NSArray *keys = [parameters.allKeys sortedArrayUsingComparator:^NSComparisonResult(id key1, id key2) {
        return [[key1 description] compare:[key2 description]];
    }];

    for (id key in keys) {
        id value = parameters[key];
        if (!value || value == NSNull.null) {
            continue;
        }

        NSString *name = [key description];
        if ([value isKindOfClass:NSArray.class]) {
            for (id item in (NSArray *)value) {
                if (item && item != NSNull.null) {
                    [queryItems addObject:[NSURLQueryItem queryItemWithName:name value:[self queryStringValue:item]]];
                }
            }
        } else {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:name value:[self queryStringValue:value]]];
        }
    }

    components.queryItems = queryItems;
    return components.URL;
}

- (NSString *)queryStringValue:(id)value {
    if ([value isKindOfClass:NSString.class]) {
        return value;
    }
    if ([value isKindOfClass:NSNumber.class]) {
        return [value stringValue];
    }
    return [value description];
}

- (NSURL *)URLWithPath:(NSString *)path {
    if (path.length == 0) {
        return nil;
    }
    
    if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
        return [NSURL URLWithString:path];
    }
    
    if (self.baseURLString.length == 0) {
        return nil;
    }
    
    NSString *base = [self.baseURLString hasSuffix:@"/"] ? self.baseURLString : [self.baseURLString stringByAppendingString:@"/"];
    NSString *relativePath = [path hasPrefix:@"/"] ? [path substringFromIndex:1] : path;
    return [NSURL URLWithString:[base stringByAppendingString:relativePath]];
}

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:LuketAPIClientErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: message ?: @"Request failed"}];
}

- (void)debugLogResponseObject:(id)responseObject request:(NSURLRequest *)request {
#if DEBUG
    NSString *jsonString = [self prettyJSONStringFromObject:responseObject];
    NSLog(@"[Luket] Response JSON %@ %@:\n%@", request.HTTPMethod ?: @"", request.URL.absoluteString ?: @"", jsonString);
#endif
}

- (NSString *)prettyJSONStringFromObject:(id)object {
    if (!object) {
        return @"null";
    }

    if (![NSJSONSerialization isValidJSONObject:object]) {
        return [object description];
    }

    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!data || error) {
        return [object description];
    }

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: [object description];
}

- (void)complete:(LuketAPIClientCompletion)completion responseObject:(id)responseObject error:(NSError *)error {
    if (!completion) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(responseObject, error);
    });
}

@end
