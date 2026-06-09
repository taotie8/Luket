//
//  LuketDataService.m
//  Luket
//

#import "LuketDataService.h"
#import "../Network/LuketAPIClient.h"

static NSString * const LuketAuthTokenKey = @"AppToken";
static NSString * const LuketStoredUserIdKey = @"userId";
static NSString * const LuketStoredUserNameKey = @"userName";
static NSString * const LuketStoredAvatarUrlKey = @"avatarUrl";
static NSString * const LuketStoredBirthdayKey = @"birthday";
static NSString * const LuketStoredGenderKey = @"gender";
static NSString * const LuketAPIPathGlobalData = @"api/api/tenant/entity/config/2013934659768873312";
static NSString * const LuketAPIPathSaveGlobalData = @"api/api/tenant/entity/config/save";
static NSString * const LuketAPIPathUserList = @"/user/list";
static NSString * const LuketAPIPathLogin = @"api/account/mail/passwordLogin";
static NSString * const LuketAPIPathRegister = @"api/account/mail/register";
static NSString * const LuketAPIPathPostList = @"/post/list";
static NSString * const LuketAPIPathPostDetail = @"/post/detail";
static NSString * const LuketAPIPathPostComments = @"/post/comments";
static NSString * const LuketAPIPathAddPostComment = @"/post/comment/add";
static NSString * const LuketAPIPathTogglePostLike = @"/post/like/toggle";
static NSString * const LuketAPIPathAIConversations = @"/ai/conversations";
static NSString * const LuketAPIPathCreateAIConversation = @"/ai/conversation/create";
static NSString * const LuketAPIPathGroupList = @"/group/list";
static NSString * const LuketAPIPathGroupDetail = @"/group/detail";
static NSString * const LuketAPIPathCreateGroup = @"/group/create";
static NSString * const LuketAPIPathGroupMessages = @"/group/messages";
static NSString * const LuketAPIPathSendGroupMessage = @"/group/message/send";
static NSString * const LuketAPIPathToggleGroupFavorite = @"/group/favorite/toggle";
static NSString * const LuketAPIPathToggleGroupLike = @"/group/like/toggle";
static NSString * const LuketAPIPathPrivateChats = @"/private/chat/list";
static NSString * const LuketAPIPathPrivateMessages = @"/private/message/list";
static NSString * const LuketAPIPathSendPrivateMessage = @"/private/message/send";
static NSString * const LuketAPIPathBlockUser = @"/user/block";

@interface LuketDataService ()

@property (nonatomic, strong) LuketAPIClient *client;
@property (nonatomic, copy, readwrite) NSString *currentLoginUserId;
@property (nonatomic, strong, readwrite) LuketUser *currentUser;
@property (nonatomic, copy, readwrite) NSString *authToken;

@end

@implementation LuketDataService

+ (instancetype)sharedService {
    static LuketDataService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[LuketDataService alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _client = LuketAPIClient.sharedClient;
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        _authToken = [defaults stringForKey:LuketAuthTokenKey];
        _currentLoginUserId = [defaults stringForKey:LuketStoredUserIdKey];

        NSString *userName = [defaults stringForKey:LuketStoredUserNameKey];
        NSString *avatarUrl = [defaults stringForKey:LuketStoredAvatarUrlKey];
        NSString *birthday = [defaults stringForKey:LuketStoredBirthdayKey];
        NSString *gender = [defaults stringForKey:LuketStoredGenderKey];
        if (_currentLoginUserId.length > 0 || userName.length > 0 || avatarUrl.length > 0 || birthday.length > 0 || gender.length > 0) {
            _currentUser = [LuketUser modelWithDictionary:@{
                @"userId": _currentLoginUserId ?: @"",
                @"nickname": userName ?: @"",
                @"avatarUrl": avatarUrl ?: @"",
                @"birthday": birthday ?: @"",
                @"gender": gender ?: @""
            }];
        }
    }
    return self;
}

- (void)configureBaseURLString:(NSString *)baseURLString {
    self.client.baseURLString = baseURLString;
}

- (BOOL)hasAuthToken {
    return self.authToken.length > 0;
}

- (void)clearAuthToken {
    self.authToken = nil;
    self.currentUser = nil;
    self.currentLoginUserId = nil;
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketAuthTokenKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredUserIdKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredUserNameKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredAvatarUrlKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredBirthdayKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredGenderKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)fetchGlobalDataWithCompletion:(LuketGlobalDataCompletion)completion {
    if (!completion) {
        return;
    }
    
    [self.client getPath:LuketAPIPathGlobalData parameters:nil completion:^(id responseObject, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        NSLog(@"[Luket] Global data raw response:\n%@", [self debugJSONStringFromObject:responseObject]);

        NSDictionary *dictionary = [self globalDataDictionaryFromResponse:responseObject];
        NSLog(@"[Luket] Global data parsed payload:\n%@", [self debugJSONStringFromObject:dictionary]);
        completion([LuketGlobalData modelWithDictionary:dictionary ?: @{}], nil);
    }];
}

- (void)saveGlobalData:(LuketGlobalData *)globalData completion:(LuketActionCompletion)completion {
    NSDictionary *parameters = globalData ? [globalData dictionaryRepresentation] : @{};
    [self performActionAtPath:LuketAPIPathSaveGlobalData parameters:parameters completion:completion];
}

- (void)fetchUsersWithCompletion:(LuketUsersCompletion)completion {
    [self fetchModelListAtPath:LuketAPIPathUserList
                    parameter:nil
                          key:@"userList"
                   modelClass:LuketUser.class
                    completion:^(NSArray *models, NSError *error) {
        if (completion) {
            completion(models, error);
        }
    }];
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(LuketUserCompletion)completion {
    NSDictionary *parameters = @{
        @"email": email ?: @"",
        @"password": password ?: @""
    };
    [self.client postPath:LuketAPIPathLogin parameters:parameters completion:^(id responseObject, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }

        NSError *loginError = [self errorFromResponseIfNeeded:responseObject fallbackMessage:@"Login failed."];
        if (loginError) {
            if (completion) {
                completion(nil, loginError);
            }
            return;
        }

        NSLog(@"[Luket] Login success response:\n%@", [self debugJSONStringFromObject:responseObject]);

        NSDictionary *loginData = [self loginDataFromResponse:responseObject];
        [self persistLoginData:loginData];

        LuketUser *user = [self userFromLoginData:loginData fallbackResponse:responseObject];

        if (completion) {
            completion(user, nil);
        }
    }];
}

- (void)registerWithEmail:(NSString *)email
                 password:(NSString *)password
               completion:(LuketUserCompletion)completion {
    NSDictionary *parameters = @{
        @"email": email ?: @"",
        @"password": password ?: @"",
        @"code": @"123456"
    };
    [self.client postPath:LuketAPIPathRegister parameters:parameters completion:^(id responseObject, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }

        NSError *registerError = [self errorFromResponseIfNeeded:responseObject fallbackMessage:@"Sign up failed."];
        if (registerError) {
            if (completion) {
                completion(nil, registerError);
            }
            return;
        }

        NSDictionary *loginData = [self loginDataFromResponse:responseObject];
        [self persistLoginData:loginData];

        LuketUser *user = [self userFromLoginData:loginData fallbackResponse:responseObject];

        if (completion) {
            completion(user, nil);
        }
    }];
}

- (void)fetchPostsWithCategory:(NSString *)postCategory completion:(LuketPostsCompletion)completion {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (postCategory.length > 0) {
        parameters[@"postCategory"] = postCategory;
    }
    [self fetchModelListAtPath:LuketAPIPathPostList
                    parameter:parameters.copy
                          key:@"postList"
                   modelClass:LuketPost.class
                    completion:^(NSArray *models, NSError *error) {
        if (completion) {
            completion(models, error);
        }
    }];
}

- (void)fetchPostDetailWithPostId:(NSString *)postId completion:(LuketPostCompletion)completion {
    [self queryModelAtPath:LuketAPIPathPostDetail
                parameters:@{@"postId": postId ?: @""}
                       key:@"post"
                modelClass:LuketPost.class
                completion:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}

- (void)fetchPostCommentsWithPostId:(NSString *)postId completion:(LuketPostCommentsCompletion)completion {
    [self fetchModelListAtPath:LuketAPIPathPostComments
                    parameter:@{@"postId": postId ?: @""}
                          key:@"postCommentList"
                   modelClass:LuketPostComment.class
                    completion:^(NSArray *models, NSError *error) {
        if (completion) {
            completion(models, error);
        }
    }];
}

- (void)addPostCommentWithPostId:(NSString *)postId userId:(NSString *)userId content:(NSString *)content completion:(LuketActionCompletion)completion {
    NSDictionary *parameters = @{
        @"postId": postId ?: @"",
        @"userId": userId ?: @"",
        @"content": content ?: @""
    };
    [self performActionAtPath:LuketAPIPathAddPostComment parameters:parameters completion:completion];
}

- (void)togglePostLikeWithPostId:(NSString *)postId userId:(NSString *)userId completion:(LuketActionCompletion)completion {
    NSDictionary *parameters = @{
        @"postId": postId ?: @"",
        @"userId": userId ?: @""
    };
    [self performActionAtPath:LuketAPIPathTogglePostLike parameters:parameters completion:completion];
}

- (void)fetchAIConversationsWithUserId:(NSString *)userId completion:(LuketAIConversationsCompletion)completion {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userId.length > 0) {
        parameters[@"userId"] = userId;
    }
    [self fetchModelListAtPath:LuketAPIPathAIConversations
                    parameter:parameters.copy
                          key:@"aiConversations"
                   modelClass:LuketAIConversation.class
                    completion:^(NSArray *models, NSError *error) {
        if (completion) {
            completion(models, error);
        }
    }];
}

- (void)createAIConversationWithUserId:(NSString *)userId prompt:(NSString *)prompt completion:(LuketAIConversationCompletion)completion {
    NSDictionary *parameters = @{
        @"userId": userId ?: @"",
        @"prompt": prompt ?: @""
    };
    [self fetchModelAtPath:LuketAPIPathCreateAIConversation
                parameters:parameters
                       key:@"conversation"
                modelClass:LuketAIConversation.class
                completion:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}

- (void)fetchGroupChatsWithCompletion:(LuketGroupChatsCompletion)completion {
    [self fetchModelListAtPath:LuketAPIPathGroupList
                    parameter:nil
                          key:@"groupChats"
                   modelClass:LuketGroupChat.class
                    completion:^(NSArray *models, NSError *error) {
        if (completion) {
            completion(models, error);
        }
    }];
}

- (void)fetchGroupDetailWithGroupId:(NSString *)groupId completion:(LuketGroupChatCompletion)completion {
    [self queryModelAtPath:LuketAPIPathGroupDetail
                parameters:@{@"groupId": groupId ?: @""}
                       key:@"group"
                modelClass:LuketGroupChat.class
                completion:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}

- (void)createGroupChatWithTitle:(NSString *)title
                groupDescription:(NSString *)groupDescription
                        coverUrl:(NSString *)coverUrl
                   creatorUserId:(NSString *)creatorUserId
                      completion:(LuketGroupChatCompletion)completion {
    NSDictionary *parameters = @{
        @"title": title ?: @"",
        @"description": groupDescription ?: @"",
        @"coverUrl": coverUrl ?: @"",
        @"creatorUserId": creatorUserId ?: @""
    };
    [self fetchModelAtPath:LuketAPIPathCreateGroup
                parameters:parameters
                       key:@"group"
                modelClass:LuketGroupChat.class
                completion:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}

- (void)fetchGroupMessagesWithGroupId:(NSString *)groupId completion:(LuketGroupMessagesCompletion)completion {
    [self fetchModelListAtPath:LuketAPIPathGroupMessages
                    parameter:@{@"groupId": groupId ?: @""}
                          key:@"groupMessages"
                   modelClass:LuketGroupMessage.class
                    completion:^(NSArray *models, NSError *error) {
        if (completion) {
            completion(models, error);
        }
    }];
}

- (void)sendGroupMessageWithGroupId:(NSString *)groupId fromUserId:(NSString *)fromUserId content:(NSString *)content completion:(LuketGroupMessageCompletion)completion {
    NSDictionary *parameters = @{
        @"groupId": groupId ?: @"",
        @"fromUserId": fromUserId ?: @"",
        @"content": content ?: @""
    };
    [self fetchModelAtPath:LuketAPIPathSendGroupMessage
                parameters:parameters
                       key:@"message"
                modelClass:LuketGroupMessage.class
                completion:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}

- (void)toggleGroupFavoriteWithGroupId:(NSString *)groupId userId:(NSString *)userId completion:(LuketActionCompletion)completion {
    NSDictionary *parameters = @{
        @"groupId": groupId ?: @"",
        @"userId": userId ?: @""
    };
    [self performActionAtPath:LuketAPIPathToggleGroupFavorite parameters:parameters completion:completion];
}

- (void)toggleGroupLikeWithGroupId:(NSString *)groupId userId:(NSString *)userId completion:(LuketActionCompletion)completion {
    NSDictionary *parameters = @{
        @"groupId": groupId ?: @"",
        @"userId": userId ?: @""
    };
    [self performActionAtPath:LuketAPIPathToggleGroupLike parameters:parameters completion:completion];
}

- (void)fetchPrivateChatsWithUserId:(NSString *)userId completion:(LuketPrivateChatsCompletion)completion {
    [self fetchModelListAtPath:LuketAPIPathPrivateChats
                    parameter:@{@"userId": userId ?: @""}
                          key:@"privateChats"
                   modelClass:LuketPrivateChat.class
                    completion:^(NSArray *models, NSError *error) {
        if (completion) {
            completion(models, error);
        }
    }];
}

- (void)fetchPrivateMessagesWithChatId:(NSString *)chatId completion:(LuketPrivateMessagesCompletion)completion {
    [self fetchModelListAtPath:LuketAPIPathPrivateMessages
                    parameter:@{@"chatId": chatId ?: @""}
                          key:@"privateMessages"
                   modelClass:LuketPrivateMessage.class
                    completion:^(NSArray *models, NSError *error) {
        if (completion) {
            completion(models, error);
        }
    }];
}

- (void)sendPrivateMessageWithChatId:(NSString *)chatId
                           fromUserId:(NSString *)fromUserId
                             toUserId:(NSString *)toUserId
                              content:(NSString *)content
                           completion:(LuketPrivateMessageCompletion)completion {
    NSDictionary *parameters = @{
        @"chatId": chatId ?: @"",
        @"fromUserId": fromUserId ?: @"",
        @"toUserId": toUserId ?: @"",
        @"content": content ?: @""
    };
    [self fetchModelAtPath:LuketAPIPathSendPrivateMessage
                parameters:parameters
                       key:@"message"
                modelClass:LuketPrivateMessage.class
                completion:^(id model, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}

- (void)blockUserWithUserId:(NSString *)userId targetUserId:(NSString *)targetUserId completion:(LuketActionCompletion)completion {
    NSDictionary *parameters = @{
        @"userId": userId ?: @"",
        @"targetUserId": targetUserId ?: @""
    };
    [self performActionAtPath:LuketAPIPathBlockUser parameters:parameters completion:completion];
}

- (void)fetchModelListAtPath:(NSString *)path
                   parameter:(NSDictionary *)parameters
                         key:(NSString *)key
                  modelClass:(Class)modelClass
                  completion:(void (^)(NSArray *models, NSError * _Nullable error))completion {
    if (!completion) {
        return;
    }
    
    [self.client getPath:path parameters:parameters completion:^(id responseObject, NSError *error) {
        if (error) {
            completion(@[], error);
            return;
        }
        
        NSArray *items = [self arrayPayloadFromResponse:responseObject key:key];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:items.count];
        for (id item in items) {
            if ([item isKindOfClass:NSDictionary.class] && [modelClass respondsToSelector:@selector(modelWithDictionary:)]) {
                id model = [modelClass modelWithDictionary:item];
                if (model) {
                    [models addObject:model];
                }
            }
        }
        completion(models.copy, nil);
    }];
}

- (void)queryModelAtPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                     key:(NSString *)key
              modelClass:(Class)modelClass
              completion:(void (^)(id _Nullable model, NSError * _Nullable error))completion {
    if (!completion) {
        return;
    }

    [self.client getPath:path parameters:parameters completion:^(id responseObject, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }

        NSDictionary *item = [self dictionaryPayloadFromResponse:responseObject key:key];
        id model = nil;
        if ([item isKindOfClass:NSDictionary.class] && [modelClass respondsToSelector:@selector(modelWithDictionary:)]) {
            model = [modelClass modelWithDictionary:item];
        }
        completion(model, nil);
    }];
}

- (void)fetchModelAtPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                     key:(NSString *)key
              modelClass:(Class)modelClass
              completion:(void (^)(id _Nullable model, NSError * _Nullable error))completion {
    if (!completion) {
        return;
    }
    
    [self.client postPath:path parameters:parameters completion:^(id responseObject, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSDictionary *item = [self dictionaryPayloadFromResponse:responseObject key:key];
        id model = nil;
        if ([item isKindOfClass:NSDictionary.class] && [modelClass respondsToSelector:@selector(modelWithDictionary:)]) {
            model = [modelClass modelWithDictionary:item];
        }
        completion(model, nil);
    }];
}

- (void)performActionAtPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(LuketActionCompletion)completion {
    if (!completion) {
        return;
    }
    
    [self.client postPath:path parameters:parameters completion:^(id responseObject, NSError *error) {
        if (error) {
            completion(NO, error.localizedDescription ?: @"Request failed", error);
            return;
        }
        
        NSDictionary *dictionary = [self dictionaryPayloadFromResponse:responseObject key:nil];
        BOOL success = YES;
        NSString *message = @"";
        if ([dictionary[@"success"] respondsToSelector:@selector(boolValue)]) {
            success = [dictionary[@"success"] boolValue];
        }
        if ([dictionary[@"msg"] isKindOfClass:NSString.class]) {
            message = dictionary[@"msg"];
        } else if ([dictionary[@"message"] isKindOfClass:NSString.class]) {
            message = dictionary[@"message"];
        }
        completion(success, message, nil);
    }];
}

- (NSError *)errorFromResponseIfNeeded:(id)responseObject fallbackMessage:(NSString *)fallbackMessage {
    NSDictionary *dictionary = [responseObject isKindOfClass:NSDictionary.class] ? responseObject : [self dictionaryPayloadFromResponse:responseObject key:nil];
    if ([dictionary[@"code"] respondsToSelector:@selector(integerValue)] && [dictionary[@"code"] integerValue] != 200) {
        NSString *message = [self messageFromDictionary:dictionary fallbackMessage:fallbackMessage];
        return [NSError errorWithDomain:LuketAPIClientErrorDomain
                                   code:[dictionary[@"code"] integerValue]
                               userInfo:@{NSLocalizedDescriptionKey: message}];
    }

    if (![dictionary[@"success"] respondsToSelector:@selector(boolValue)] || [dictionary[@"success"] boolValue]) {
        return nil;
    }

    NSString *message = [self messageFromDictionary:dictionary fallbackMessage:fallbackMessage];
    return [NSError errorWithDomain:LuketAPIClientErrorDomain
                               code:-2000
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

- (NSString *)messageFromDictionary:(NSDictionary *)dictionary fallbackMessage:(NSString *)fallbackMessage {
    NSString *message = fallbackMessage ?: @"Request failed.";
    if ([dictionary[@"msg"] isKindOfClass:NSString.class]) {
        message = dictionary[@"msg"];
    } else if ([dictionary[@"message"] isKindOfClass:NSString.class]) {
        message = dictionary[@"message"];
    }
    return message;
}

- (NSString *)debugJSONStringFromObject:(id)object {
    if (!object) {
        return @"<null>";
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

- (NSDictionary *)loginDataFromResponse:(id)responseObject {
    if ([responseObject isKindOfClass:NSDictionary.class] && [responseObject[@"data"] isKindOfClass:NSDictionary.class]) {
        return responseObject[@"data"];
    }
    return [self dictionaryPayloadFromResponse:responseObject key:nil];
}

- (NSDictionary *)globalDataDictionaryFromResponse:(id)responseObject {
    id payload = responseObject;
    if ([responseObject isKindOfClass:NSDictionary.class] && responseObject[@"data"] && responseObject[@"data"] != NSNull.null) {
        payload = responseObject[@"data"];
    }
    return [self globalDataDictionaryFromPayload:payload] ?: @{};
}

- (NSDictionary *)globalDataDictionaryFromPayload:(id)payload {
    if ([payload isKindOfClass:NSString.class]) {
        id jsonObject = [self jsonObjectFromString:payload];
        return [self globalDataDictionaryFromPayload:jsonObject];
    }

    if (![payload isKindOfClass:NSDictionary.class]) {
        return nil;
    }

    NSDictionary *dictionary = payload;
    if ([self dictionaryContainsGlobalDataKeys:dictionary]) {
        return dictionary;
    }

    NSArray<NSString *> *nestedKeys = @[
        @"data",
        @"configInfo",
        @"config",
        @"configJson",
        @"configContent",
        @"configValue",
        @"content",
        @"value",
        @"json"
    ];
    for (NSString *key in nestedKeys) {
        id value = dictionary[key];
        if (!value || value == NSNull.null || value == payload) {
            continue;
        }

        NSDictionary *nestedDictionary = [self globalDataDictionaryFromPayload:value];
        if (nestedDictionary.count > 0) {
            return nestedDictionary;
        }
    }

    return dictionary;
}

- (BOOL)dictionaryContainsGlobalDataKeys:(NSDictionary *)dictionary {
    NSArray<NSString *> *keys = @[
        @"userList",
        @"postList",
        @"postCommentList",
        @"likeList",
        @"blackList",
        @"aiConversations",
        @"groupChats",
        @"groupMessages",
        @"groupFavorites",
        @"privateChats",
        @"privateMessages"
    ];

    for (NSString *key in keys) {
        if (dictionary[key]) {
            return YES;
        }
    }
    return NO;
}

- (id)jsonObjectFromString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (data.length == 0) {
        return nil;
    }

    NSError *error;
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
}

- (void)persistLoginData:(NSDictionary *)loginData {
    if (![loginData isKindOfClass:NSDictionary.class]) {
        return;
    }

    NSString *token = [self normalizedStringValue:loginData[@"token"]];
    if (token.length == 0) {
        token = [self authTokenFromResponseObject:loginData];
    }
    self.authToken = token;
    [self storeLoginStringValue:token forKey:LuketAuthTokenKey];

    NSString *userId = [self normalizedStringValue:loginData[@"userId"]];
    self.currentLoginUserId = userId;
    [self storeLoginStringValue:userId forKey:LuketStoredUserIdKey];

    NSString *userName = [self normalizedStringValue:loginData[@"userName"]];
    [self storeLoginStringValue:userName forKey:LuketStoredUserNameKey];

    NSString *avatarUrl = [self normalizedStringValue:loginData[@"avatarUrl"]];
    [self storeLoginStringValue:avatarUrl forKey:LuketStoredAvatarUrlKey];

    NSString *birthday = [self normalizedStringValue:loginData[@"birthday"]];
    [self storeLoginStringValue:birthday forKey:LuketStoredBirthdayKey];

    NSString *gender = [self normalizedStringValue:loginData[@"gender"]];
    [self storeLoginStringValue:gender forKey:LuketStoredGenderKey];

    [NSUserDefaults.standardUserDefaults synchronize];
}

- (LuketUser *)userFromLoginData:(NSDictionary *)loginData fallbackResponse:(id)responseObject {
    NSDictionary *userDictionary = loginData;
    if (![userDictionary isKindOfClass:NSDictionary.class] || userDictionary.count == 0) {
        userDictionary = [self dictionaryPayloadFromResponse:responseObject key:@"user"];
    }
    if (![userDictionary isKindOfClass:NSDictionary.class]) {
        return nil;
    }

    BOOL hasUserFields = userDictionary[@"userId"] || userDictionary[@"nickname"] || userDictionary[@"userName"] || userDictionary[@"email"];
    if (!hasUserFields) {
        return nil;
    }

    NSMutableDictionary *normalizedDictionary = userDictionary.mutableCopy;
    if (![normalizedDictionary[@"nickname"] isKindOfClass:NSString.class] && [normalizedDictionary[@"userName"] isKindOfClass:NSString.class]) {
        normalizedDictionary[@"nickname"] = normalizedDictionary[@"userName"];
    }

    LuketUser *user = [LuketUser modelWithDictionary:normalizedDictionary.copy];
    self.currentUser = user;
    self.currentLoginUserId = user.userId;
    return user;
}

- (void)persistAuthTokenFromResponse:(id)responseObject {
    NSString *token = [self authTokenFromResponseObject:responseObject];
    if (token.length == 0) {
        return;
    }

    self.authToken = token;
    [NSUserDefaults.standardUserDefaults setObject:token forKey:LuketAuthTokenKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)authTokenFromResponseObject:(id)object {
    if ([object isKindOfClass:NSDictionary.class]) {
        NSDictionary *dictionary = object;
        NSSet<NSString *> *tokenKeys = [NSSet setWithArray:@[
            @"token",
            @"accessToken",
            @"access_token",
            @"AppToken",
            @"appToken",
            @"idToken",
            @"authorization",
            @"Authorization"
        ]];

        for (NSString *key in tokenKeys) {
            id value = dictionary[key];
            if ([value isKindOfClass:NSString.class]) {
                NSString *token = [self normalizedAuthToken:value];
                if (token.length > 0) {
                    return token;
                }
            }
        }

        for (id value in dictionary.allValues) {
            NSString *token = [self authTokenFromResponseObject:value];
            if (token.length > 0) {
                return token;
            }
        }
    } else if ([object isKindOfClass:NSArray.class]) {
        for (id value in (NSArray *)object) {
            NSString *token = [self authTokenFromResponseObject:value];
            if (token.length > 0) {
                return token;
            }
        }
    }

    return nil;
}

- (NSString *)normalizedAuthToken:(NSString *)token {
    NSString *trimmedToken = [token stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if ([trimmedToken hasPrefix:@"Bearer "]) {
        return [[trimmedToken substringFromIndex:@"Bearer ".length] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    }
    return trimmedToken;
}

- (NSString *)normalizedStringValue:(id)value {
    if ([value isKindOfClass:NSString.class]) {
        return [value stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    }
    if ([value respondsToSelector:@selector(stringValue)]) {
        return [[value stringValue] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    }
    return nil;
}

- (void)storeLoginStringValue:(NSString *)value forKey:(NSString *)key {
    if (value.length > 0) {
        [NSUserDefaults.standardUserDefaults setObject:value forKey:key];
    } else {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
    }
}

- (NSArray *)arrayPayloadFromResponse:(id)responseObject key:(NSString *)key {
    if ([responseObject isKindOfClass:NSArray.class]) {
        return responseObject;
    }
    
    if (![responseObject isKindOfClass:NSDictionary.class]) {
        return @[];
    }
    
    NSDictionary *dictionary = responseObject;
    id directValue = key.length > 0 ? dictionary[key] : nil;
    if ([directValue isKindOfClass:NSArray.class]) {
        return directValue;
    }
    
    id dataValue = dictionary[@"data"];
    if ([dataValue isKindOfClass:NSArray.class]) {
        return dataValue;
    }
    if ([dataValue isKindOfClass:NSDictionary.class] && key.length > 0 && [dataValue[key] isKindOfClass:NSArray.class]) {
        return dataValue[key];
    }
    
    return @[];
}

- (NSDictionary *)dictionaryPayloadFromResponse:(id)responseObject key:(NSString *)key {
    if (![responseObject isKindOfClass:NSDictionary.class]) {
        return @{};
    }
    
    NSDictionary *dictionary = responseObject;
    id directValue = key.length > 0 ? dictionary[key] : nil;
    if ([directValue isKindOfClass:NSDictionary.class]) {
        return directValue;
    }
    
    id dataValue = dictionary[@"data"];
    if ([dataValue isKindOfClass:NSDictionary.class]) {
        if (key.length > 0 && [dataValue[key] isKindOfClass:NSDictionary.class]) {
            return dataValue[key];
        }
        return dataValue;
    }
    
    return dictionary;
}

@end
