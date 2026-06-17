//
//  DeepSeekService.m
//  Luket
//

#import "DeepSeekService.h"

static NSString * const DeepSeekDefaultAPIKey = @"sk-87f899e798644717bbd503a88b126305";
static NSString * const DeepSeekStoredAPIKey = @"DeepSeekAPIKey";
static NSString * const DeepSeekAPIURLString = @"https://api.deepseek.com/chat/completions";
static NSString * const DeepSeekModelName = @"deepseek-chat";
static NSString * const DeepSeekErrorDomain = @"Luket.DeepSeek";

@interface DeepSeekService ()

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation DeepSeekService

+ (instancetype)sharedService {
    static DeepSeekService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[DeepSeekService alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *storedKey = [NSUserDefaults.standardUserDefaults stringForKey:DeepSeekStoredAPIKey];
        _apiKey = storedKey.length > 0 ? storedKey : DeepSeekDefaultAPIKey;

        NSURLSessionConfiguration *configuration = NSURLSessionConfiguration.defaultSessionConfiguration;
        configuration.timeoutIntervalForRequest = 30.0;
        configuration.timeoutIntervalForResource = 60.0;
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (BOOL)hasAPIKey {
    return [self.apiKey stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet].length > 0;
}

- (void)configureAPIKey:(NSString *)apiKey {
    NSString *trimmedKey = [apiKey stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    self.apiKey = trimmedKey ?: @"";
    if (trimmedKey.length > 0) {
        [NSUserDefaults.standardUserDefaults setObject:trimmedKey forKey:DeepSeekStoredAPIKey];
    } else {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:DeepSeekStoredAPIKey];
    }
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)generateSwimmingRecommendationWithPrompt:(NSString *)prompt
                                      priceRange:(NSString *)priceRange
                                 stylePreference:(NSString *)stylePreference
                                      completion:(DeepSeekChatCompletion)completion {
    NSString *trimmedPrompt = [prompt stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (trimmedPrompt.length == 0) {
        [self complete:completion responseText:nil error:[self errorWithMessage:@"Please enter your requirements."]];
        return;
    }

    if (![self hasAPIKey]) {
        [self complete:completion responseText:nil error:[self errorWithMessage:@"DeepSeek API key is not configured."]];
        return;
    }

    NSURL *url = [NSURL URLWithString:DeepSeekAPIURLString];
    if (!url) {
        [self complete:completion responseText:nil error:[self errorWithMessage:@"Invalid DeepSeek URL."]];
        return;
    }

    NSDictionary *body = @{
        @"model": DeepSeekModelName,
        @"stream": @NO,
        @"temperature": @0.7,
        @"messages": @[
            @{
                @"role": @"system",
                @"content": @"You are a concise swimming outfit recommendation assistant for the Luket app. Recommend safe, practical swimming-related outfits or gear based on the user's requirements. Avoid sexualized content, minors, illegal content, or medical claims. Reply in English."
            },
            @{
                @"role": @"user",
                @"content": [NSString stringWithFormat:@"User requirements: %@\nPrice range: %@\nStyle preference: %@\nPlease provide 2-3 recommendation options with short reasons.", trimmedPrompt, priceRange ?: @"", stylePreference ?: @""]
            }
        ]
    };

    if (![NSJSONSerialization isValidJSONObject:body]) {
        [self complete:completion responseText:nil error:[self errorWithMessage:@"Invalid DeepSeek request."]];
        return;
    }

    NSError *jsonError;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&jsonError];
    if (!bodyData || jsonError) {
        [self complete:completion responseText:nil error:jsonError ?: [self errorWithMessage:@"DeepSeek request encode failed."]];
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = bodyData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.apiKey] forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self complete:completion responseText:nil error:error];
            return;
        }

        NSHTTPURLResponse *httpResponse = [response isKindOfClass:NSHTTPURLResponse.class] ? (NSHTTPURLResponse *)response : nil;
        if (httpResponse && (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300)) {
            NSString *message = [NSString stringWithFormat:@"DeepSeek request failed. HTTP %ld", (long)httpResponse.statusCode];
            [self complete:completion responseText:nil error:[self errorWithMessage:message]];
            return;
        }

        if (data.length == 0) {
            [self complete:completion responseText:nil error:[self errorWithMessage:@"DeepSeek returned empty response."]];
            return;
        }

        NSError *parseError;
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (parseError || ![responseObject isKindOfClass:NSDictionary.class]) {
            [self complete:completion responseText:nil error:parseError ?: [self errorWithMessage:@"DeepSeek response parse failed."]];
            return;
        }

        NSString *responseText = [self responseTextFromResponseDictionary:responseObject];
        if (responseText.length == 0) {
            [self complete:completion responseText:nil error:[self errorWithMessage:@"DeepSeek returned no content."]];
            return;
        }

        [self complete:completion responseText:responseText error:nil];
    }];
    [task resume];
}

- (NSString *)responseTextFromResponseDictionary:(NSDictionary *)dictionary {
    NSArray *choices = [dictionary[@"choices"] isKindOfClass:NSArray.class] ? dictionary[@"choices"] : nil;
    NSDictionary *firstChoice = [choices.firstObject isKindOfClass:NSDictionary.class] ? choices.firstObject : nil;
    NSDictionary *message = [firstChoice[@"message"] isKindOfClass:NSDictionary.class] ? firstChoice[@"message"] : nil;
    NSString *content = [message[@"content"] isKindOfClass:NSString.class] ? message[@"content"] : @"";
    return [content stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}

- (NSError *)errorWithMessage:(NSString *)message {
    return [NSError errorWithDomain:DeepSeekErrorDomain
                               code:-1
                           userInfo:@{NSLocalizedDescriptionKey: message ?: @"DeepSeek request failed."}];
}

- (void)complete:(DeepSeekChatCompletion)completion responseText:(NSString *)responseText error:(NSError *)error {
    if (!completion) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        completion(responseText, error);
    });
}

@end
