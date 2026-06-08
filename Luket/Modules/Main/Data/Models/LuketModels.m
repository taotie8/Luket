//
//  LuketModels.m
//  Luket
//

#import "LuketModels.h"

LuketPostMediaType const LuketPostMediaTypeVideo = @"video";
LuketPostMediaType const LuketPostMediaTypeImage = @"image";

static NSString *LuketStringValue(id value) {
    if ([value isKindOfClass:NSString.class]) {
        return value;
    }
    if ([value isKindOfClass:NSNumber.class]) {
        return [value stringValue];
    }
    return @"";
}

static NSString * _Nullable LuketNullableStringValue(id value) {
    if ([value isKindOfClass:NSString.class]) {
        return value;
    }
    if ([value isKindOfClass:NSNumber.class]) {
        return [value stringValue];
    }
    return nil;
}

static NSInteger LuketIntegerValue(id value) {
    if ([value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    }
    return 0;
}

static BOOL LuketBoolValue(id value) {
    if ([value respondsToSelector:@selector(boolValue)]) {
        return [value boolValue];
    }
    return NO;
}

static NSArray<NSString *> *LuketStringArrayValue(id value) {
    if (![value isKindOfClass:NSArray.class]) {
        return @[];
    }
    
    NSMutableArray<NSString *> *strings = [NSMutableArray array];
    for (id item in (NSArray *)value) {
        NSString *string = LuketNullableStringValue(item);
        if (string.length > 0) {
            [strings addObject:string];
        }
    }
    return strings.copy;
}

static NSArray *LuketModelArrayValue(id value, Class modelClass) {
    if (![value isKindOfClass:NSArray.class]) {
        return @[];
    }
    
    NSMutableArray *models = [NSMutableArray array];
    for (id item in (NSArray *)value) {
        if ([item isKindOfClass:NSDictionary.class] && [modelClass respondsToSelector:@selector(modelWithDictionary:)]) {
            id model = [modelClass modelWithDictionary:item];
            if (model) {
                [models addObject:model];
            }
        }
    }
    return models.copy;
}

static NSArray *LuketDictionaryArrayValue(NSArray *models) {
    NSMutableArray *items = [NSMutableArray array];
    for (id model in models) {
        if ([model respondsToSelector:@selector(dictionaryRepresentation)]) {
            [items addObject:[model dictionaryRepresentation]];
        }
    }
    return items.copy;
}

@implementation LuketUser

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _userId = LuketStringValue(dictionary[@"userId"]);
        _nickname = LuketStringValue(dictionary[@"nickname"]);
        _avatarUrl = LuketStringValue(dictionary[@"avatarUrl"]);
        _age = LuketIntegerValue(dictionary[@"age"]);
        _gender = LuketStringValue(dictionary[@"gender"]);
        _email = LuketStringValue(dictionary[@"email"]);
        _password = LuketStringValue(dictionary[@"password"]);
        _createTime = LuketStringValue(dictionary[@"createTime"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"userId": self.userId,
        @"nickname": self.nickname,
        @"avatarUrl": self.avatarUrl,
        @"age": @(self.age),
        @"gender": self.gender,
        @"email": self.email,
        @"password": self.password,
        @"createTime": self.createTime
    };
}

@end

@implementation LuketPost

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _postId = LuketStringValue(dictionary[@"postId"]);
        _publishUserId = LuketStringValue(dictionary[@"publishUserId"]);
        _content = LuketStringValue(dictionary[@"content"]);
        _mediaType = LuketStringValue(dictionary[@"mediaType"]);
        _mediaUrls = LuketStringArrayValue(dictionary[@"mediaUrls"]);
        _coverUrl = LuketNullableStringValue(dictionary[@"coverUrl"]);
        _postCategory = LuketStringValue(dictionary[@"postCategory"]);
        _publishTime = LuketStringValue(dictionary[@"publishTime"]);
        _likeCount = LuketIntegerValue(dictionary[@"likeCount"]);
        _commentCount = LuketIntegerValue(dictionary[@"commentCount"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"postId": self.postId,
        @"publishUserId": self.publishUserId,
        @"content": self.content,
        @"mediaType": self.mediaType,
        @"mediaUrls": self.mediaUrls,
        @"coverUrl": self.coverUrl ?: NSNull.null,
        @"postCategory": self.postCategory,
        @"publishTime": self.publishTime,
        @"likeCount": @(self.likeCount),
        @"commentCount": @(self.commentCount)
    };
}

@end

@implementation LuketPostComment

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _commentId = LuketStringValue(dictionary[@"commentId"]);
        _postId = LuketStringValue(dictionary[@"postId"]);
        _fromUserId = LuketStringValue(dictionary[@"fromUserId"]);
        _content = LuketStringValue(dictionary[@"content"]);
        _commentTime = LuketStringValue(dictionary[@"commentTime"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"commentId": self.commentId,
        @"postId": self.postId,
        @"fromUserId": self.fromUserId,
        @"content": self.content,
        @"commentTime": self.commentTime
    };
}

@end

@implementation LuketLikeRelation

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _userId = LuketStringValue(dictionary[@"userId"]);
        _postId = LuketStringValue(dictionary[@"postId"]);
        _likeTime = LuketStringValue(dictionary[@"likeTime"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"userId": self.userId,
        @"postId": self.postId,
        @"likeTime": self.likeTime
    };
}

@end

@implementation LuketBlackRelation

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _blockUserId = LuketStringValue(dictionary[@"blockUserId"]);
        _targetUserId = LuketStringValue(dictionary[@"targetUserId"]);
        _blockTime = LuketStringValue(dictionary[@"blockTime"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"blockUserId": self.blockUserId,
        @"targetUserId": self.targetUserId,
        @"blockTime": self.blockTime
    };
}

@end

@implementation LuketAIConversation

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _conversationId = LuketStringValue(dictionary[@"conversationId"]);
        _userId = LuketStringValue(dictionary[@"userId"]);
        _prompt = LuketStringValue(dictionary[@"prompt"]);
        _response = LuketStringValue(dictionary[@"response"]);
        _createTime = LuketStringValue(dictionary[@"createTime"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"conversationId": self.conversationId,
        @"userId": self.userId,
        @"prompt": self.prompt,
        @"response": self.response,
        @"createTime": self.createTime
    };
}

@end

@implementation LuketGroupChat

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _groupId = LuketStringValue(dictionary[@"groupId"]);
        _title = LuketStringValue(dictionary[@"title"]);
        _groupDescription = LuketStringValue(dictionary[@"description"]);
        _coverUrl = LuketStringValue(dictionary[@"coverUrl"]);
        _creatorUserId = LuketStringValue(dictionary[@"creatorUserId"]);
        _createTime = LuketStringValue(dictionary[@"createTime"]);
        _memberIds = LuketStringArrayValue(dictionary[@"memberIds"]);
        _likeCount = LuketIntegerValue(dictionary[@"likeCount"]);
        _favorited = LuketBoolValue(dictionary[@"isFavorited"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"groupId": self.groupId,
        @"title": self.title,
        @"description": self.groupDescription,
        @"coverUrl": self.coverUrl,
        @"creatorUserId": self.creatorUserId,
        @"createTime": self.createTime,
        @"memberIds": self.memberIds,
        @"likeCount": @(self.likeCount),
        @"isFavorited": @(self.favorited)
    };
}

@end

@implementation LuketGroupMessage

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _messageId = LuketStringValue(dictionary[@"messageId"]);
        _groupId = LuketStringValue(dictionary[@"groupId"]);
        _fromUserId = LuketStringValue(dictionary[@"fromUserId"]);
        _content = LuketStringValue(dictionary[@"content"]);
        _sendTime = LuketStringValue(dictionary[@"sendTime"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"messageId": self.messageId,
        @"groupId": self.groupId,
        @"fromUserId": self.fromUserId,
        @"content": self.content,
        @"sendTime": self.sendTime
    };
}

@end

@implementation LuketGroupFavoriteRelation

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _userId = LuketStringValue(dictionary[@"userId"]);
        _groupId = LuketStringValue(dictionary[@"groupId"]);
        _favoriteTime = LuketStringValue(dictionary[@"favoriteTime"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"userId": self.userId,
        @"groupId": self.groupId,
        @"favoriteTime": self.favoriteTime
    };
}

@end

@implementation LuketPrivateChat

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _chatId = LuketStringValue(dictionary[@"chatId"]);
        _user1Id = LuketStringValue(dictionary[@"user1Id"]);
        _user2Id = LuketStringValue(dictionary[@"user2Id"]);
        _createTime = LuketStringValue(dictionary[@"createTime"]);
        _lastMessageTime = LuketStringValue(dictionary[@"lastMessageTime"]);
        _lastMessageContent = LuketStringValue(dictionary[@"lastMessageContent"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"chatId": self.chatId,
        @"user1Id": self.user1Id,
        @"user2Id": self.user2Id,
        @"createTime": self.createTime,
        @"lastMessageTime": self.lastMessageTime,
        @"lastMessageContent": self.lastMessageContent
    };
}

@end

@implementation LuketPrivateMessage

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _messageId = LuketStringValue(dictionary[@"messageId"]);
        _chatId = LuketStringValue(dictionary[@"chatId"]);
        _fromUserId = LuketStringValue(dictionary[@"fromUserId"]);
        _toUserId = LuketStringValue(dictionary[@"toUserId"]);
        _content = LuketStringValue(dictionary[@"content"]);
        _sendTime = LuketStringValue(dictionary[@"sendTime"]);
        _read = LuketBoolValue(dictionary[@"isRead"]);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"messageId": self.messageId,
        @"chatId": self.chatId,
        @"fromUserId": self.fromUserId,
        @"toUserId": self.toUserId,
        @"content": self.content,
        @"sendTime": self.sendTime,
        @"isRead": @(self.read)
    };
}

@end

@implementation LuketGlobalData

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)init {
    return [self initWithDictionary:@{}];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _userList = LuketModelArrayValue(dictionary[@"userList"], LuketUser.class);
        _postList = LuketModelArrayValue(dictionary[@"postList"], LuketPost.class);
        _postCommentList = LuketModelArrayValue(dictionary[@"postCommentList"], LuketPostComment.class);
        _likeList = LuketModelArrayValue(dictionary[@"likeList"], LuketLikeRelation.class);
        _blackList = LuketModelArrayValue(dictionary[@"blackList"], LuketBlackRelation.class);
        _aiConversations = LuketModelArrayValue(dictionary[@"aiConversations"], LuketAIConversation.class);
        _groupChats = LuketModelArrayValue(dictionary[@"groupChats"], LuketGroupChat.class);
        _groupMessages = LuketModelArrayValue(dictionary[@"groupMessages"], LuketGroupMessage.class);
        _groupFavorites = LuketModelArrayValue(dictionary[@"groupFavorites"], LuketGroupFavoriteRelation.class);
        _privateChats = LuketModelArrayValue(dictionary[@"privateChats"], LuketPrivateChat.class);
        _privateMessages = LuketModelArrayValue(dictionary[@"privateMessages"], LuketPrivateMessage.class);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
        @"userList": LuketDictionaryArrayValue(self.userList),
        @"postList": LuketDictionaryArrayValue(self.postList),
        @"postCommentList": LuketDictionaryArrayValue(self.postCommentList),
        @"likeList": LuketDictionaryArrayValue(self.likeList),
        @"blackList": LuketDictionaryArrayValue(self.blackList),
        @"aiConversations": LuketDictionaryArrayValue(self.aiConversations),
        @"groupChats": LuketDictionaryArrayValue(self.groupChats),
        @"groupMessages": LuketDictionaryArrayValue(self.groupMessages),
        @"groupFavorites": LuketDictionaryArrayValue(self.groupFavorites),
        @"privateChats": LuketDictionaryArrayValue(self.privateChats),
        @"privateMessages": LuketDictionaryArrayValue(self.privateMessages)
    };
}

@end
