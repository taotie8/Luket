//
//  LuketDataService.m
//  Luket
//

#import "LuketDataService.h"
#import "../Network/LuketAPIClient.h"

static NSString * const LuketAPIPathGlobalData = @"api/api/tenant/entity/config/id";
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
    }
    return self;
}

- (void)configureBaseURLString:(NSString *)baseURLString {
    self.client.baseURLString = baseURLString;
}

- (void)fetchGlobalDataWithCompletion:(LuketGlobalDataCompletion)completion {
    if (!completion) {
        return;
    }
    
    [self.client postPath:LuketAPIPathGlobalData parameters:nil completion:^(id responseObject, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        NSDictionary *dictionary = [self dictionaryPayloadFromResponse:responseObject key:nil];
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
        @"mail": email ?: @"",
        @"password": password ?: @""
    };
    [self fetchModelAtPath:LuketAPIPathLogin
                parameters:parameters
                       key:@"user"
                modelClass:LuketUser.class
                completion:^(id model, NSError *error) {
        if (!error && [model isKindOfClass:LuketUser.class]) {
            self.currentUser = model;
            self.currentLoginUserId = self.currentUser.userId;
        }
        if (completion) {
            completion(model, error);
        }
    }];
}

- (void)registerWithNickname:(NSString *)nickname
                   avatarUrl:(NSString *)avatarUrl
                         age:(NSInteger)age
                      gender:(NSString *)gender
                       email:(NSString *)email
                    password:(NSString *)password
                  completion:(LuketUserCompletion)completion {
    NSDictionary *parameters = @{
        @"nickname": nickname ?: @"",
        @"avatarUrl": avatarUrl ?: @"",
        @"age": @(age),
        @"gender": gender ?: @"",
        @"mail": email ?: @"",
        @"password": password ?: @""
    };
    [self fetchModelAtPath:LuketAPIPathRegister
                parameters:parameters
                       key:@"user"
                modelClass:LuketUser.class
                completion:^(id model, NSError *error) {
        if (!error && [model isKindOfClass:LuketUser.class]) {
            self.currentUser = model;
            self.currentLoginUserId = self.currentUser.userId;
        }
        if (completion) {
            completion(model, error);
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
    [self fetchModelAtPath:LuketAPIPathPostDetail
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
    [self fetchModelAtPath:LuketAPIPathGroupDetail
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
    
    [self.client postPath:path parameters:parameters completion:^(id responseObject, NSError *error) {
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
