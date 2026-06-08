//
//  LuketAPIClient.m
//  Luket
//

#import "LuketAPIClient.h"

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
        _baseURLString = @"https://dev.chavytogo.com/";
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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = bodyData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self complete:completion responseObject:nil error:error];
            return;
        }
        
        NSHTTPURLResponse *httpResponse = [response isKindOfClass:NSHTTPURLResponse.class] ? (NSHTTPURLResponse *)response : nil;
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
        
        NSError *parseError;
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!responseObject || parseError) {
            [self complete:completion responseObject:nil error:parseError ?: [self errorWithCode:LuketAPIClientErrorCodeInvalidResponse message:@"JSON parse failed"]];
            return;
        }
        
        [self complete:completion responseObject:responseObject error:nil];
    }];
    [task resume];
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

- (void)complete:(LuketAPIClientCompletion)completion responseObject:(id)responseObject error:(NSError *)error {
    if (!completion) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(responseObject, error);
    });
}

@end
