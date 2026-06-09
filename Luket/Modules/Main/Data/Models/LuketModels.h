//
//  LuketModels.h
//  Luket
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * LuketPostMediaType NS_STRING_ENUM;
FOUNDATION_EXPORT LuketPostMediaType const LuketPostMediaTypeVideo;
FOUNDATION_EXPORT LuketPostMediaType const LuketPostMediaTypeImage;

@protocol LuketJSONModel <NSObject>

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;

@end

@interface LuketUser : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *createTime;

@end

@interface LuketPost : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *publishUserId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) LuketPostMediaType mediaType;
@property (nonatomic, copy) NSArray<NSString *> *mediaUrls;
@property (nonatomic, copy, nullable) NSString *coverUrl;
@property (nonatomic, copy) NSString *postCategory;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger commentCount;

@end

@interface LuketPostComment : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *fromUserId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *commentTime;

@end

@interface LuketLikeRelation : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *likeTime;

@end

@interface LuketBlackRelation : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *blockUserId;
@property (nonatomic, copy) NSString *targetUserId;
@property (nonatomic, copy) NSString *blockTime;

@end

@interface LuketAIConversation : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *conversationId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *prompt;
@property (nonatomic, copy) NSString *response;
@property (nonatomic, copy) NSString *createTime;

@end

@interface LuketGroupChat : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *groupDescription;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *creatorUserId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSArray<NSString *> *memberIds;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign, getter=isFavorited) BOOL favorited;

@end

@interface LuketGroupMessage : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *fromUserId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *sendTime;

@end

@interface LuketGroupFavoriteRelation : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *favoriteTime;

@end

@interface LuketPrivateChat : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *chatId;
@property (nonatomic, copy) NSString *user1Id;
@property (nonatomic, copy) NSString *user2Id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *lastMessageTime;
@property (nonatomic, copy) NSString *lastMessageContent;

@end

@interface LuketPrivateMessage : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *chatId;
@property (nonatomic, copy) NSString *fromUserId;
@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, assign, getter=isRead) BOOL read;

@end

@interface LuketGlobalData : NSObject <LuketJSONModel>

@property (nonatomic, copy) NSArray<LuketUser *> *userList;
@property (nonatomic, copy) NSArray<LuketPost *> *postList;
@property (nonatomic, copy) NSArray<LuketPostComment *> *postCommentList;
@property (nonatomic, copy) NSArray<LuketLikeRelation *> *likeList;
@property (nonatomic, copy) NSArray<LuketBlackRelation *> *blackList;
@property (nonatomic, copy) NSArray<LuketAIConversation *> *aiConversations;
@property (nonatomic, copy) NSArray<LuketGroupChat *> *groupChats;
@property (nonatomic, copy) NSArray<LuketGroupMessage *> *groupMessages;
@property (nonatomic, copy) NSArray<LuketGroupFavoriteRelation *> *groupFavorites;
@property (nonatomic, copy) NSArray<LuketPrivateChat *> *privateChats;
@property (nonatomic, copy) NSArray<LuketPrivateMessage *> *privateMessages;

@end

NS_ASSUME_NONNULL_END
