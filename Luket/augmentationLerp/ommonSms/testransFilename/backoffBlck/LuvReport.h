
#import <Foundation/Foundation.h>
#import "../unprocessed/LuvFeedbackDialog.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LuketGlobalDataCompletion)(LuvAvatar * _Nullable data, NSError * _Nullable error);
typedef void (^LuketUsersCompletion)(NSArray<LuvMemberPassword *> *users, NSError * _Nullable error);
typedef void (^LuketUserCompletion)(LuvMemberPassword * _Nullable user, NSError * _Nullable error);
typedef void (^LuketPostsCompletion)(NSArray<LuvUtilModels *> *posts, NSError * _Nullable error);
typedef void (^LuketPostCompletion)(LuvUtilModels * _Nullable post, NSError * _Nullable error);
typedef void (^LuketPostCommentsCompletion)(NSArray<LuvDiamondModity *> *comments, NSError * _Nullable error);
typedef void (^LuketAIConversationsCompletion)(NSArray<LuvSignPassword *> *conversations, NSError * _Nullable error);
typedef void (^LuketAIConversationCompletion)(LuvSignPassword * _Nullable conversation, NSError * _Nullable error);
typedef void (^LuketGroupChatsCompletion)(NSArray<LuvConfirmDeep *> *groups, NSError * _Nullable error);
typedef void (^LuketGroupChatCompletion)(LuvConfirmDeep * _Nullable group, NSError * _Nullable error);
typedef void (^LuketGroupMessagesCompletion)(NSArray<LuvFeedbackEdit *> *messages, NSError * _Nullable error);
typedef void (^LuketGroupMessageCompletion)(LuvFeedbackEdit * _Nullable message, NSError * _Nullable error);
typedef void (^LuketPrivateChatsCompletion)(NSArray<LuvBubble *> *chats, NSError * _Nullable error);
typedef void (^LuketPrivateMessagesCompletion)(NSArray<LuvSheetScene *> *messages, NSError * _Nullable error);
typedef void (^LuketPrivateMessageCompletion)(LuvSheetScene * _Nullable message, NSError * _Nullable error);
typedef void (^LuketActionCompletion)(BOOL success, NSString *message, NSError * _Nullable error);

@interface LuvReport : NSObject


@property(nonatomic, assign)double  heart_max;
@property(nonatomic, assign)BOOL  can_Target;
@property(nonatomic, assign)BOOL  enbaleAgain;
@property(nonatomic, assign)BOOL  delete_qk;




-(double)productTaskCloseAreaInto:(BOOL)offsetWindow_r intoConversations:(int)intoConversations detailCurrent:(long)detailCurrent;

-(NSArray *)persistentPositionDirectory:(NSDictionary *)relationFeed;

-(double)persistentFlowCurve:(NSArray *)displayedRemote amountsDictionary:(BOOL)amountsDictionary;

-(NSString *)prettyFullLeftAlignmentBlack;

-(NSArray *)fetchBlueTransitionAutomaticSend:(NSArray *)barEmail backgroundIgnore:(NSString *)backgroundIgnore;

-(NSDictionary *)shouldVisibleContext:(double)postsFavorite pangMedia:(int)pangMedia;

-(NSDictionary *)enumerateAuthorPrepareFactorScroll:(BOOL)actionEnsure containerMessages:(NSDictionary *)containerMessages;

-(NSDictionary *)reverseItemSectionComplete;

-(float)oldLabelLibrarySend:(double)dataShield;

-(NSDictionary *)makeBlueFetchMemberAge:(NSInteger)welcomeCenter window_aConversations:(NSDictionary *)window_aConversations avatarComment:(NSInteger)avatarComment;

-(NSDictionary *)sortPathTouch:(NSInteger)luketKey serviceScreen:(NSString *)serviceScreen avatarViews:(int)avatarViews;

-(double)pageAgainFeedOperation:(BOOL)disappearFollowed segmentScreen:(NSArray *)segmentScreen;

-(NSString *)generateSegmentAction:(NSDictionary *)heatEnter actionFollow:(float)actionFollow badgeWelcome:(NSDictionary *)badgeWelcome;

-(double)directValueTarget:(NSDictionary *)completionsCollection utilDiamond:(NSArray *)utilDiamond;

-(NSArray *)buildTranslationMainContextFollowVisibility:(NSArray *)mainMessage amountLayer:(NSArray *)amountLayer reportDelegate_u:(NSInteger)reportDelegate_u;

-(double)refreshMediaConnectScreen:(BOOL)prettyTime_es productsList:(BOOL)productsList modeButtons:(NSDictionary *)modeButtons;

-(NSDictionary *)generateAttributeRemoveResourceWithout:(NSArray *)moreSaving heightRecommendation:(NSArray *)heightRecommendation stringNotify:(NSArray *)stringNotify;

-(NSDictionary *)launchCodeHighActiveContentRemote:(float)photoRepresentation closeSaving:(NSArray *)closeSaving activeScreen:(double)activeScreen;

-(NSDictionary *)heartOptionActivateActionHistoryPublish:(float)animationPretty;

-(NSDictionary *)allSendIndex:(long)applySheet identifierPurchasing:(int)identifierPurchasing ageNext:(NSDictionary *)ageNext;

-(NSString *)editIconColumnResume;

-(float)randomControlBorderDissolveWritingBecome:(NSArray *)commentReport titleRoom:(NSDictionary *)titleRoom homeMember:(NSString *)homeMember;

-(NSDictionary *)savingOutgoingPresentThatPresentationBecome:(NSDictionary *)createMedia prepareAction:(NSDictionary *)prepareAction;

-(BOOL)presentFormatNoticeActiveDialog;

-(NSInteger)appendAfterReverseEaseGreen:(float)signingDisplay publishOffset:(int)publishOffset formComment:(float)formComment;

-(double)requirementApplicationTable;

-(NSString *)strokeReuseModalResumeCreatorArea:(NSArray *)groupCustom agreementPrices:(NSArray *)agreementPrices discoverKey:(NSDictionary *)discoverKey;

-(int)transitionBlackFull:(NSString *)time_vgRequest amountFavorited:(NSString *)amountFavorited;

-(NSArray *)movePercentDarkGenderSince:(NSDictionary *)playerContent pathHero:(NSString *)pathHero;

+(BOOL)minimumIntoFirstAtomicWeightFavorite:(NSString *)creatorCommon userScreen:(NSInteger)userScreen;

-(BOOL)ensureHistorySlotMessageRange;

-(NSInteger)strokeBecomeCurrentCountOverlapPath:(NSArray *)fieldDisconnect clientTime_0:(NSString *)clientTime_0;

-(NSString *)subtitleThatReplacementMessageEnterLarge:(NSString *)biaoHeader relationDiamond:(NSArray *)relationDiamond;

-(NSArray *)deepDictionaryFeed;

-(NSDictionary *)sortTextRemote;

-(int)presentEdgeEnsureComparisonBounce:(NSArray *)placeholderCategory_h titleAction:(NSArray *)titleAction commentsLaunch:(BOOL)commentsLaunch;

-(NSArray *)followingPreferenceVisibility:(NSDictionary *)countPost description_eBirthday:(NSDictionary *)description_eBirthday;


@property (nonatomic, copy, nullable, readonly) NSString *currentLoginUserId;
@property (nonatomic, strong, nullable, readonly) LuvMemberPassword *currentUser;
@property (nonatomic, copy, nullable, readonly) NSString *authToken;
@property (nonatomic, strong, nullable, readonly) LuvAvatar *cachedGlobalData;

+ (instancetype)sharedService;
- (void)configureBaseURLString:(NSString *)baseURLString;
- (BOOL)hasAuthToken;
- (void)clearAuthToken;

- (void)fetchGlobalDataWithCompletion:(LuketGlobalDataCompletion)completion;
- (void)loadGlobalDataIfNeededWithCompletion:(LuketGlobalDataCompletion)completion;
- (void)refreshGlobalDataWithCompletion:(LuketGlobalDataCompletion)completion;
- (void)updateCachedGlobalData:(LuvAvatar *)globalData;
- (void)saveGlobalData:(LuvAvatar *)globalData completion:(LuketActionCompletion)completion;

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
