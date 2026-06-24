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
static NSString * const LuketStoredEmailKey = @"email";
static NSString * const LuketStoredPasswordKey = @"password";
static NSString * const LuketStoredAgeKey = @"age";
static NSString * const LuketStoredCreateTimeKey = @"createTime";
static NSString * const LuketGlobalConfigId = @"2013934659768873312";
static NSString * const LuketAPIPathGlobalData = @"397264";
static NSString * const LuketAPIPathSaveGlobalData = @"034216";
static NSString * const LuketAPIPathUserList = @"/user/list";

static NSString * const LuketAPIPathLogin = @"946101";
static NSString * const LuketAPIPathRegister = @"809881";
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
@property (nonatomic, strong, readwrite) LuketGlobalData *cachedGlobalData;
@property (nonatomic, assign) BOOL loadingGlobalData;
@property (nonatomic, strong) NSMutableArray<LuketGlobalDataCompletion> *pendingGlobalDataCompletions;

- (void)saveGlobalData:(LuketGlobalData *)globalData refreshAfterSave:(BOOL)refreshAfterSave completion:(LuketActionCompletion)completion;

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
        _pendingGlobalDataCompletions = [NSMutableArray array];
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        _authToken = [defaults stringForKey:LuketAuthTokenKey];
        _currentLoginUserId = [defaults stringForKey:LuketStoredUserIdKey];

        NSString *userName = [defaults stringForKey:LuketStoredUserNameKey];
        NSString *avatarUrl = [defaults stringForKey:LuketStoredAvatarUrlKey];
        NSString *birthday = [defaults stringForKey:LuketStoredBirthdayKey];
        NSString *gender = [defaults stringForKey:LuketStoredGenderKey];
        NSString *email = [defaults stringForKey:LuketStoredEmailKey];
        NSString *password = [defaults stringForKey:LuketStoredPasswordKey];
        NSString *createTime = [defaults stringForKey:LuketStoredCreateTimeKey];
        NSInteger age = [defaults integerForKey:LuketStoredAgeKey];
        if (_currentLoginUserId.length > 0 || userName.length > 0 || avatarUrl.length > 0 || birthday.length > 0 || gender.length > 0 || email.length > 0) {
            _currentUser = [LuketUser modelWithDictionary:@{
                @"userId": _currentLoginUserId ?: @"",
                @"nickname": userName ?: @"",
                @"avatarUrl": avatarUrl ?: @"",
                @"age": @(age),
                @"birthday": birthday ?: @"",
                @"gender": gender ?: @"",
                @"email": email ?: @"",
                @"password": password ?: @"",
                @"createTime": createTime ?: @""
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
    self.cachedGlobalData = nil;
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketAuthTokenKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredUserIdKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredUserNameKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredAvatarUrlKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredBirthdayKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredGenderKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredEmailKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredPasswordKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredAgeKey];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:LuketStoredCreateTimeKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)fetchGlobalDataWithCompletion:(LuketGlobalDataCompletion)completion {
    [self loadGlobalDataIfNeededWithCompletion:completion];
}

- (void)loadGlobalDataIfNeededWithCompletion:(LuketGlobalDataCompletion)completion {
    if (!completion) {
        return;
    }

    if (self.cachedGlobalData) {
        completion(self.cachedGlobalData, nil);
        return;
    }

    [self refreshGlobalDataWithCompletion:completion];
}

- (void)refreshGlobalDataWithCompletion:(LuketGlobalDataCompletion)completion {
    if (!completion) {
        return;
    }

    if (self.loadingGlobalData) {
        [self.pendingGlobalDataCompletions addObject:[completion copy]];
        return;
    }

    self.loadingGlobalData = YES;
    [self.pendingGlobalDataCompletions addObject:[completion copy]];

    [self.client getPath:LuketAPIPathGlobalData parameters:nil completion:^(id responseObject, NSError *error) {
        self.loadingGlobalData = NO;
        NSArray<LuketGlobalDataCompletion> *completions = self.pendingGlobalDataCompletions.copy;
        [self.pendingGlobalDataCompletions removeAllObjects];

        if (error) {
            for (LuketGlobalDataCompletion pendingCompletion in completions) {
                pendingCompletion(nil, error);
            }
            return;
        }

        NSDictionary *dictionary = [self globalDataDictionaryFromResponse:responseObject];
        LuketGlobalData *globalData = [LuketGlobalData modelWithDictionary:dictionary ?: @{}];
        [self ensureCurrentUserExistsInGlobalData:globalData completion:^(LuketGlobalData *updatedGlobalData) {
            self.cachedGlobalData = updatedGlobalData;
            for (LuketGlobalDataCompletion pendingCompletion in completions) {
                pendingCompletion(updatedGlobalData, nil);
            }
        }];
    }];
}

- (void)updateCachedGlobalData:(LuketGlobalData *)globalData {
    self.cachedGlobalData = globalData;
}

- (void)saveGlobalData:(LuketGlobalData *)globalData completion:(LuketActionCompletion)completion {
    [self saveGlobalData:globalData refreshAfterSave:YES completion:completion];
}

- (void)saveGlobalData:(LuketGlobalData *)globalData refreshAfterSave:(BOOL)refreshAfterSave completion:(LuketActionCompletion)completion {
    NSDictionary *configInfo = globalData ? [globalData dictionaryRepresentation] : @{};
    NSDictionary *parameters = @{
        @"id": LuketGlobalConfigId,
        @"configInfo": configInfo ?: @{}
    };
    [self performActionAtPath:LuketAPIPathSaveGlobalData parameters:parameters completion:^(BOOL success, NSString *message, NSError * _Nullable error) {
        if (!success || error) {
            if (completion) {
                completion(success, message, error);
            }
            return;
        }

        self.cachedGlobalData = globalData;
        if (!refreshAfterSave) {
            if (completion) {
                completion(success, message, error);
            }
            return;
        }

        [self refreshGlobalDataWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable refreshError) {
            if (refreshError) {
                NSLog(@"[Luket] Refresh global data after save failed: %@", refreshError.localizedDescription);
            }
            if (completion) {
                completion(success, message, nil);
            }
        }];
    }];
}

- (void)ensureCurrentUserExistsInGlobalData:(LuketGlobalData *)globalData completion:(void (^)(LuketGlobalData *updatedGlobalData))completion {
    if (!completion) {
        return;
    }

    LuketUser *currentUser = [self currentUserForGlobalData];
    if (!globalData || currentUser.userId.length == 0 || [self userList:globalData.userList containsUserId:currentUser.userId]) {
        completion(globalData ?: [[LuketGlobalData alloc] init]);
        return;
    }

    NSMutableArray<LuketUser *> *users = globalData.userList.mutableCopy ?: [NSMutableArray array];
    [users addObject:currentUser];
    globalData.userList = users.copy;

    [self saveGlobalData:globalData refreshAfterSave:NO completion:^(BOOL success, NSString *message, NSError * _Nullable error) {
        if (!success || error) {
            NSLog(@"[Luket] Save current user to global data failed: %@", error.localizedDescription ?: message);
        }
        completion(globalData);
    }];
}

- (BOOL)userList:(NSArray<LuketUser *> *)userList containsUserId:(NSString *)userId {
    if (userId.length == 0) {
        return NO;
    }

    for (LuketUser *user in userList) {
        if ([user.userId isEqualToString:userId]) {
            return YES;
        }
    }
    return NO;
}

- (LuketUser *)currentUserForGlobalData {
    NSDictionary *userDictionary = [self currentUserDictionaryForGlobalData];
    if (userDictionary.count == 0) {
        return nil;
    }

    LuketUser *user = [LuketUser modelWithDictionary:userDictionary];
    self.currentUser = user;
    self.currentLoginUserId = user.userId;
    return user;
}

- (NSDictionary *)currentUserDictionaryForGlobalData {
    NSString *userId = self.currentUser.userId.length > 0 ? self.currentUser.userId : self.currentLoginUserId;
    if (userId.length == 0) {
        return @{};
    }

    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSString *nickname = self.currentUser.nickname.length > 0 ? self.currentUser.nickname : [defaults stringForKey:LuketStoredUserNameKey];
    NSString *avatarUrl = self.currentUser.avatarUrl.length > 0 ? self.currentUser.avatarUrl : [defaults stringForKey:LuketStoredAvatarUrlKey];
    NSString *birthday = self.currentUser.birthday.length > 0 ? self.currentUser.birthday : [defaults stringForKey:LuketStoredBirthdayKey];
    NSString *gender = self.currentUser.gender.length > 0 ? self.currentUser.gender : [defaults stringForKey:LuketStoredGenderKey];
    NSString *email = self.currentUser.email.length > 0 ? self.currentUser.email : [defaults stringForKey:LuketStoredEmailKey];
    NSString *password = self.currentUser.password.length > 0 ? self.currentUser.password : [defaults stringForKey:LuketStoredPasswordKey];
    NSString *createTime = self.currentUser.createTime.length > 0 ? self.currentUser.createTime : [defaults stringForKey:LuketStoredCreateTimeKey];
    NSInteger age = self.currentUser.age > 0 ? self.currentUser.age : [defaults integerForKey:LuketStoredAgeKey];

    return @{
        @"userId": userId,
        @"nickname": nickname.length > 0 ? nickname : @"User",
        @"avatarUrl": avatarUrl ?: @"",
        @"age": @(age > 0 ? age : 18),
        @"birthday": birthday ?: @"",
        @"gender": gender ?: @"",
        @"email": email ?: @"",
        @"password": password ?: @"",
        @"createTime": createTime ?: @""
    };
}

- (void)fetchUsersWithCompletion:(LuketUsersCompletion)completion {
    [self loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        if (completion) {
            completion(data.userList ?: @[], error);
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

        NSDictionary *loginData = [self loginDataFromResponse:responseObject];
        [self persistLoginData:loginData fallbackEmail:email password:password];

        LuketUser *user = [self userFromLoginData:loginData fallbackResponse:responseObject fallbackEmail:email password:password];

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
        [self persistLoginData:loginData fallbackEmail:email password:password];

        LuketUser *user = [self userFromLoginData:loginData fallbackResponse:responseObject fallbackEmail:email password:password];

        if (completion) {
            completion(user, nil);
        }
    }];
}

- (void)updateCurrentUserProfileWithNickname:(NSString *)nickname
                                    avatarUrl:(NSString *)avatarUrl
                                          age:(NSInteger)age
                                   completion:(LuketActionCompletion)completion {
    LuketUser *currentUser = self.currentUser ?: [self currentUserForGlobalData];
    if (currentUser.userId.length == 0 && self.currentLoginUserId.length > 0) {
        currentUser = [LuketUser modelWithDictionary:[self currentUserDictionaryForGlobalData]];
    }
    if (currentUser.userId.length == 0) {
        if (completion) {
            completion(NO, @"Missing current user.", nil);
        }
        return;
    }

    NSString *trimmedNickname = [nickname stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSString *trimmedAvatarUrl = [avatarUrl stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (trimmedNickname.length > 0) {
        currentUser.nickname = trimmedNickname;
    }
    if (trimmedAvatarUrl.length > 0) {
        currentUser.avatarUrl = trimmedAvatarUrl;
    }
    if (age > 0) {
        currentUser.age = age;
    }

    self.currentUser = currentUser;
    self.currentLoginUserId = currentUser.userId;
    [self storeLoginStringValue:currentUser.userId forKey:LuketStoredUserIdKey];
    [self storeLoginStringValue:currentUser.nickname forKey:LuketStoredUserNameKey];
    [self storeLoginStringValue:currentUser.avatarUrl forKey:LuketStoredAvatarUrlKey];
    [self storeLoginStringValue:[NSString stringWithFormat:@"%ld", (long)currentUser.age] forKey:LuketStoredAgeKey];
    [NSUserDefaults.standardUserDefaults synchronize];

    [self loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            if (completion) {
                completion(NO, error.localizedDescription ?: @"Save failed.", error);
            }
            return;
        }

        LuketGlobalData *globalData = data ?: [[LuketGlobalData alloc] init];
        NSMutableArray<LuketUser *> *users = globalData.userList.mutableCopy ?: [NSMutableArray array];
        BOOL updated = NO;
        for (LuketUser *user in users) {
            if ([user.userId isEqualToString:currentUser.userId]) {
                user.nickname = currentUser.nickname;
                user.avatarUrl = currentUser.avatarUrl;
                user.age = currentUser.age;
                updated = YES;
                break;
            }
        }
        if (!updated) {
            [users addObject:currentUser];
        }
        globalData.userList = users.copy;
        [self saveGlobalData:globalData completion:completion];
    }];
}

- (void)fetchPostsWithCategory:(NSString *)postCategory completion:(LuketPostsCompletion)completion {
    [self loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        NSArray<LuketPost *> *posts = data.postList ?: @[];
        if (postCategory.length > 0) {
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(LuketPost *post, NSDictionary<NSString *,id> *bindings) {
                return [post.postCategory isEqualToString:postCategory];
            }];
            posts = [posts filteredArrayUsingPredicate:predicate];
        }
        if (completion) {
            completion(posts, error);
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
    [self loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        if (completion) {
            completion(data.groupChats ?: @[], error);
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
        if ([dictionary[@"code"] respondsToSelector:@selector(integerValue)]) {
            success = [dictionary[@"code"] integerValue] == 200;
        }
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

- (void)persistLoginData:(NSDictionary *)loginData fallbackEmail:(NSString *)fallbackEmail password:(NSString *)fallbackPassword {
    if (![loginData isKindOfClass:NSDictionary.class]) {
        return;
    }

    NSDictionary *userInfo = [self userInfoFromLoginData:loginData];
    NSString *token = [self normalizedStringValue:loginData[@"token"]];
    if (token.length == 0) {
        token = [self authTokenFromResponseObject:loginData];
    }
    self.authToken = token;
    [self storeLoginStringValue:token forKey:LuketAuthTokenKey];

    NSString *userId = [self normalizedStringValue:userInfo[@"userId"]];
    if (userId.length == 0) {
        userId = [self normalizedStringValue:userInfo[@"id"]];
    }
    self.currentLoginUserId = userId;
    [self storeLoginStringValue:userId forKey:LuketStoredUserIdKey];

    NSString *userName = [self normalizedStringValue:userInfo[@"userName"]];
    if (userName.length == 0) {
        userName = [self normalizedStringValue:userInfo[@"nickname"]];
    }
    [self storeLoginStringValue:userName forKey:LuketStoredUserNameKey];

    NSString *avatarUrl = [self normalizedStringValue:userInfo[@"avatarUrl"]];
    if (avatarUrl.length == 0) {
        avatarUrl = [self normalizedStringValue:userInfo[@"avatar"]];
    }
    [self storeLoginStringValue:avatarUrl forKey:LuketStoredAvatarUrlKey];

    NSString *birthday = [self normalizedStringValue:userInfo[@"birthday"]];
    [self storeLoginStringValue:birthday forKey:LuketStoredBirthdayKey];

    NSString *gender = [self normalizedStringValue:userInfo[@"gender"]];
    [self storeLoginStringValue:gender forKey:LuketStoredGenderKey];

    NSString *email = [self normalizedStringValue:userInfo[@"email"]];
    if (email.length == 0) {
        email = [self normalizedStringValue:userInfo[@"mail"]];
    }
    if (email.length == 0) {
        email = [self normalizedStringValue:fallbackEmail];
    }
    [self storeLoginStringValue:email forKey:LuketStoredEmailKey];

    NSString *password = [self normalizedStringValue:userInfo[@"password"]];
    if (password.length == 0) {
        password = [self normalizedStringValue:fallbackPassword];
    }
    [self storeLoginStringValue:password forKey:LuketStoredPasswordKey];

    NSString *age = [self normalizedStringValue:userInfo[@"age"]];
    [self storeLoginStringValue:age forKey:LuketStoredAgeKey];

    NSString *createTime = [self normalizedStringValue:userInfo[@"createTime"]];
    [self storeLoginStringValue:createTime forKey:LuketStoredCreateTimeKey];

    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSDictionary *)userInfoFromLoginData:(NSDictionary *)loginData {
    if (![loginData isKindOfClass:NSDictionary.class]) {
        return @{};
    }

    NSArray<NSString *> *userKeys = @[@"user", @"account", @"profile", @"member", @"userInfo"];
    for (NSString *key in userKeys) {
        id value = loginData[key];
        if ([value isKindOfClass:NSDictionary.class]) {
            return value;
        }
    }
    return loginData;
}

- (LuketUser *)userFromLoginData:(NSDictionary *)loginData fallbackResponse:(id)responseObject fallbackEmail:(NSString *)fallbackEmail password:(NSString *)fallbackPassword {
    NSDictionary *userDictionary = [self userInfoFromLoginData:loginData];
    if (![userDictionary isKindOfClass:NSDictionary.class] || userDictionary.count == 0) {
        userDictionary = [self dictionaryPayloadFromResponse:responseObject key:@"user"];
    }
    if (![userDictionary isKindOfClass:NSDictionary.class]) {
        return nil;
    }

    BOOL hasUserFields = userDictionary[@"userId"] || userDictionary[@"id"] || userDictionary[@"nickname"] || userDictionary[@"userName"] || userDictionary[@"email"];
    if (!hasUserFields) {
        return nil;
    }

    NSMutableDictionary *normalizedDictionary = userDictionary.mutableCopy;
    if (![normalizedDictionary[@"nickname"] isKindOfClass:NSString.class] && [normalizedDictionary[@"userName"] isKindOfClass:NSString.class]) {
        normalizedDictionary[@"nickname"] = normalizedDictionary[@"userName"];
    }
    if (![normalizedDictionary[@"userId"] isKindOfClass:NSString.class] || [normalizedDictionary[@"userId"] length] == 0) {
        NSString *userId = [self normalizedStringValue:normalizedDictionary[@"id"]];
        if (userId.length == 0) {
            userId = self.currentLoginUserId;
        }
        if (userId.length > 0) {
            normalizedDictionary[@"userId"] = userId;
        }
    }
    if (![normalizedDictionary[@"email"] isKindOfClass:NSString.class] || [normalizedDictionary[@"email"] length] == 0) {
        NSString *email = [self normalizedStringValue:fallbackEmail];
        if (email.length > 0) {
            normalizedDictionary[@"email"] = email;
        }
    }
    if (![normalizedDictionary[@"password"] isKindOfClass:NSString.class] || [normalizedDictionary[@"password"] length] == 0) {
        NSString *password = [self normalizedStringValue:fallbackPassword];
        if (password.length > 0) {
            normalizedDictionary[@"password"] = password;
        }
    }

    LuketUser *user = [LuketUser modelWithDictionary:normalizedDictionary.copy];
    self.currentUser = user;
    if (user.userId.length > 0) {
        self.currentLoginUserId = user.userId;
    }
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
