//
//  LuketDataService.h
//  Luket
//

#import <Foundation/Foundation.h>
#import "../Models/LuketModels.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LuketGlobalDataCompletion)(LuketGlobalData * _Nullable data, NSError * _Nullable error);
typedef void (^LuketUsersCompletion)(NSArray<LuketUser *> *users, NSError * _Nullable error);
typedef void (^LuketUserCompletion)(LuketUser * _Nullable user, NSError * _Nullable error);
typedef void (^LuketPostsCompletion)(NSArray<LuketPost *> *posts, NSError * _Nullable error);
typedef void (^LuketPostCompletion)(LuketPost * _Nullable post, NSError * _Nullable error);
typedef void (^LuketPostCommentsCompletion)(NSArray<LuketPostComment *> *comments, NSError * _Nullable error);
typedef void (^LuketAIConversationsCompletion)(NSArray<LuketAIConversation *> *conversations, NSError * _Nullable error);
typedef void (^LuketAIConversationCompletion)(LuketAIConversation * _Nullable conversation, NSError * _Nullable error);
typedef void (^LuketGroupChatsCompletion)(NSArray<LuketGroupChat *> *groups, NSError * _Nullable error);
typedef void (^LuketGroupChatCompletion)(LuketGroupChat * _Nullable group, NSError * _Nullable error);
typedef void (^LuketGroupMessagesCompletion)(NSArray<LuketGroupMessage *> *messages, NSError * _Nullable error);
typedef void (^LuketGroupMessageCompletion)(LuketGroupMessage * _Nullable message, NSError * _Nullable error);
typedef void (^LuketPrivateChatsCompletion)(NSArray<LuketPrivateChat *> *chats, NSError * _Nullable error);
typedef void (^LuketPrivateMessagesCompletion)(NSArray<LuketPrivateMessage *> *messages, NSError * _Nullable error);
typedef void (^LuketPrivateMessageCompletion)(LuketPrivateMessage * _Nullable message, NSError * _Nullable error);
typedef void (^LuketActionCompletion)(BOOL success, NSString *message, NSError * _Nullable error);

@interface LuketDataService : NSObject

@property (nonatomic, copy, nullable, readonly) NSString *currentLoginUserId;
@property (nonatomic, strong, nullable, readonly) LuketUser *currentUser;
@property (nonatomic, copy, nullable, readonly) NSString *authToken;
@property (nonatomic, strong, nullable, readonly) LuketGlobalData *cachedGlobalData;

+ (instancetype)sharedService;
- (void)configureBaseURLString:(NSString *)baseURLString;
- (BOOL)hasAuthToken;
- (void)clearAuthToken;

- (void)fetchGlobalDataWithCompletion:(LuketGlobalDataCompletion)completion;
- (void)loadGlobalDataIfNeededWithCompletion:(LuketGlobalDataCompletion)completion;
- (void)refreshGlobalDataWithCompletion:(LuketGlobalDataCompletion)completion;
- (void)updateCachedGlobalData:(LuketGlobalData *)globalData;
- (void)saveGlobalData:(LuketGlobalData *)globalData completion:(LuketActionCompletion)completion;

- (void)fetchUsersWithCompletion:(LuketUsersCompletion)completion;
- (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(LuketUserCompletion)completion;
- (void)registerWithEmail:(NSString *)email
                 password:(NSString *)password
               completion:(LuketUserCompletion)completion;
- (void)updateCurrentUserProfileWithNickname:(nullable NSString *)nickname
                                    avatarUrl:(nullable NSString *)avatarUrl
                                          age:(NSInteger)age
                                   completion:(LuketActionCompletion)completion;

- (void)fetchPostsWithCategory:(nullable NSString *)postCategory completion:(LuketPostsCompletion)completion;
- (void)fetchPostDetailWithPostId:(NSString *)postId completion:(LuketPostCompletion)completion;
- (void)fetchPostCommentsWithPostId:(NSString *)postId completion:(LuketPostCommentsCompletion)completion;
- (void)addPostCommentWithPostId:(NSString *)postId userId:(NSString *)userId content:(NSString *)content completion:(LuketActionCompletion)completion;
- (void)togglePostLikeWithPostId:(NSString *)postId userId:(NSString *)userId completion:(LuketActionCompletion)completion;

- (void)fetchAIConversationsWithUserId:(nullable NSString *)userId completion:(LuketAIConversationsCompletion)completion;
- (void)createAIConversationWithUserId:(NSString *)userId prompt:(NSString *)prompt completion:(LuketAIConversationCompletion)completion;

- (void)fetchGroupChatsWithCompletion:(LuketGroupChatsCompletion)completion;
- (void)fetchGroupDetailWithGroupId:(NSString *)groupId completion:(LuketGroupChatCompletion)completion;
- (void)createGroupChatWithTitle:(NSString *)title
                groupDescription:(NSString *)groupDescription
                        coverUrl:(NSString *)coverUrl
                   creatorUserId:(NSString *)creatorUserId
                      completion:(LuketGroupChatCompletion)completion;
- (void)fetchGroupMessagesWithGroupId:(NSString *)groupId completion:(LuketGroupMessagesCompletion)completion;
- (void)sendGroupMessageWithGroupId:(NSString *)groupId fromUserId:(NSString *)fromUserId content:(NSString *)content completion:(LuketGroupMessageCompletion)completion;
- (void)toggleGroupFavoriteWithGroupId:(NSString *)groupId userId:(NSString *)userId completion:(LuketActionCompletion)completion;
- (void)toggleGroupLikeWithGroupId:(NSString *)groupId userId:(NSString *)userId completion:(LuketActionCompletion)completion;

- (void)fetchPrivateChatsWithUserId:(NSString *)userId completion:(LuketPrivateChatsCompletion)completion;
- (void)fetchPrivateMessagesWithChatId:(NSString *)chatId completion:(LuketPrivateMessagesCompletion)completion;
- (void)sendPrivateMessageWithChatId:(NSString *)chatId
                           fromUserId:(NSString *)fromUserId
                             toUserId:(NSString *)toUserId
                              content:(NSString *)content
                           completion:(LuketPrivateMessageCompletion)completion;

- (void)blockUserWithUserId:(NSString *)userId targetUserId:(NSString *)targetUserId completion:(LuketActionCompletion)completion;

@end

NS_ASSUME_NONNULL_END
