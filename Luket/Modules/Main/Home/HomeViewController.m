//
//  HomeViewController.m
//  Luket
//
//  Created by Codex on 2026/6/3.
//

#import "HomeViewController.h"
#import "../Detail/DetailViewController.h"
#import "../AISwimming/AISwimmingViewController.h"
#import "../Profile/UserProfileViewController.h"
#import "../Data/Service/LuketDataService.h"
#import "../Common/LuketMediaResource.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef NS_ENUM(NSUInteger, HomeFeedMode) {
    HomeFeedModeTrending,
    HomeFeedModeDiscover
};

@interface HomeFeedCell : UICollectionViewCell

@property (nonatomic, copy) void (^avatarTapHandler)(void);

- (void)configureWithPost:(LuketPost *)post index:(NSUInteger)index;
- (void)configureWithPost:(LuketPost *)post author:(LuketUser *)author index:(NSUInteger)index;

@end

@interface HomeFeedCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIImageView *playIconImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation HomeFeedCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;

        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 162.0, 187.0)];
        self.containerView.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.containerView];

        UIImageView *frameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeFeedCardFrame"]];
        frameImageView.frame = self.containerView.bounds;
        frameImageView.contentMode = UIViewContentModeScaleToFill;
        [self.containerView addSubview:frameImageView];

        self.photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.photoImageView.frame = CGRectMake(12.0, 10.0, 138.0, 116.0);
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.clipsToBounds = YES;
        self.photoImageView.layer.cornerRadius = 23.0;
        [self.containerView addSubview:self.photoImageView];

        self.playIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeVideoPlayIcon"]];
        self.playIconImageView.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
        self.playIconImageView.center = CGPointMake(CGRectGetMidX(self.photoImageView.frame), CGRectGetMidY(self.photoImageView.frame));
        self.playIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.playIconImageView.hidden = YES;
        [self.containerView addSubview:self.playIconImageView];

        self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.avatarImageView.frame = CGRectMake(15.0, 138.0, 24.0, 24.0);
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = 12.0;
        [self.containerView addSubview:self.avatarImageView];

        UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        avatarButton.frame = self.avatarImageView.frame;
        [avatarButton addTarget:self action:@selector(avatarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:avatarButton];

        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(51.0, 136.0, 92.0, 38.0)];
        self.textLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        self.textLabel.textColor = [UIColor colorWithRed:0.27 green:0.39 blue:0.55 alpha:1.0];
        self.textLabel.numberOfLines = 2;
        [self.containerView addSubview:self.textLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.avatarTapHandler = nil;
    [self.photoImageView sd_cancelCurrentImageLoad];
    [self.avatarImageView sd_cancelCurrentImageLoad];
    self.photoImageView.image = [UIImage imageNamed:@"HomeHeroImage"];
    self.avatarImageView.image = [UIImage imageNamed:@"HomeHeroImage"];
    self.photoImageView.transform = CGAffineTransformIdentity;
    self.playIconImageView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat scale = CGRectGetWidth(self.contentView.bounds) / 162.0;
    self.containerView.bounds = CGRectMake(0.0, 0.0, 162.0, 187.0);
    self.containerView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));
    self.containerView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)configureWithPost:(LuketPost *)post index:(NSUInteger)index {
    [self configureWithPost:post author:nil index:index];
}

- (void)configureWithPost:(LuketPost *)post author:(LuketUser *)author index:(NSUInteger)index {
    (void)index;
    self.textLabel.text = post.content.length > 0 ? post.content : @"";
    self.photoImageView.transform = CGAffineTransformIdentity;

    BOOL isVideo = [[post.mediaType lowercaseString] isEqualToString:LuketPostMediaTypeVideo];
    self.playIconImageView.hidden = !isVideo;

    NSString *firstMediaIdentifier = post.mediaUrls.firstObject;
    NSString *coverIdentifier = nil;
    if (isVideo) {
        coverIdentifier = post.coverUrl.length > 0 ? post.coverUrl : firstMediaIdentifier;
    } else {
        coverIdentifier = firstMediaIdentifier.length > 0 ? firstMediaIdentifier : post.coverUrl;
    }
    [self setCoverImageWithIdentifier:coverIdentifier];
    [self setAvatarImageWithIdentifier:author.avatarUrl];
}

- (void)setCoverImageWithIdentifier:(NSString *)identifier {
    NSString *trimmedIdentifier = [identifier stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    UIImage *placeholderImage = [UIImage imageNamed:@"HomeHeroImage"];

    UIImage *localImage = [LuketMediaResource localImageWithIdentifier:trimmedIdentifier];
    if (localImage) {
        [self.photoImageView sd_cancelCurrentImageLoad];
        self.photoImageView.image = localImage;
        return;
    }

    NSURL *imageURL = [LuketMediaResource imageURLWithIdentifier:trimmedIdentifier];
    if (!imageURL) {
        [self.photoImageView sd_cancelCurrentImageLoad];
        self.photoImageView.image = placeholderImage;
        return;
    }

    [self.photoImageView sd_setImageWithURL:imageURL
                           placeholderImage:placeholderImage
                                    options:SDWebImageRetryFailed | SDWebImageScaleDownLargeImages];
}

- (void)setAvatarImageWithIdentifier:(NSString *)identifier {
    NSString *trimmedIdentifier = [identifier stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    UIImage *placeholderImage = [UIImage imageNamed:@"HomeHeroImage"];

    UIImage *localImage = [LuketMediaResource localImageWithIdentifier:trimmedIdentifier];
    if (localImage) {
        [self.avatarImageView sd_cancelCurrentImageLoad];
        self.avatarImageView.image = localImage;
        return;
    }

    NSURL *imageURL = [LuketMediaResource imageURLWithIdentifier:trimmedIdentifier];
    if (!imageURL) {
        [self.avatarImageView sd_cancelCurrentImageLoad];
        self.avatarImageView.image = placeholderImage;
        return;
    }

    [self.avatarImageView sd_setImageWithURL:imageURL
                            placeholderImage:placeholderImage
                                     options:SDWebImageRetryFailed | SDWebImageScaleDownLargeImages];
}

- (void)avatarButtonTapped {
    if (self.avatarTapHandler) {
        self.avatarTapHandler();
    }
}

@end

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *heroImageView;
@property (nonatomic, strong) UIButton *aiButton;
@property (nonatomic, strong) UIButton *trendingButton;
@property (nonatomic, strong) UIButton *discoverButton;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;
@property (nonatomic, copy) NSArray<LuketPost *> *posts;
@property (nonatomic, copy) NSArray<LuketPost *> *visiblePosts;
@property (nonatomic, strong) LuketGlobalData *globalData;
@property (nonatomic, assign) HomeFeedMode feedMode;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.feedMode = HomeFeedModeTrending;
    self.view.backgroundColor = [self mainBackgroundColor];
    [self configureCollectionView];
    [self configureHomeContent];
    [self configureLoadingView];
    [self updateTitleState];
    [self loadPosts];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(blockedUsersDidChange)
                                                 name:@"LuketBlockedUsersDidChangeNotification"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self syncCachedGlobalDataAndRefresh];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat scale = width / 375.0;
    CGFloat heroHeight = width * 254.0 / 375.0;
    CGFloat cardStartY = 326.0 * scale;

    self.heroImageView.frame = CGRectMake(0.0, 0.0, width, heroHeight);
    self.aiButton.frame = CGRectMake(58.0 * scale, 209.0 * scale, 260.0 * scale, 55.0 * scale);
    self.trendingButton.frame = CGRectMake(20.0 * scale, 282.0 * scale, 106.0 * scale, 24.0 * scale);
    self.discoverButton.frame = CGRectMake(141.0 * scale, 283.0 * scale, 108.0 * scale, 24.0 * scale);

    self.collectionView.frame = CGRectMake(0.0, cardStartY, width, height - cardStartY);
    self.collectionView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.view.safeAreaInsets.bottom + 100.0, 0.0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView.collectionViewLayout invalidateLayout];

    self.loadingView.frame = self.view.bounds;
    self.loadingIndicatorView.center = self.loadingView.center;
}

- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [self mainBackgroundColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:HomeFeedCell.class forCellWithReuseIdentifier:@"HomeFeedCell"];
    [self.view addSubview:self.collectionView];
}

- (void)configureHomeContent {
    self.heroImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    self.heroImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.heroImageView.clipsToBounds = YES;
    [self.view addSubview:self.heroImageView];

    self.aiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.aiButton setImage:[[UIImage imageNamed:@"HomeAISwimmingButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.aiButton addTarget:self action:@selector(aiButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.aiButton];

    self.trendingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.trendingButton.tag = HomeFeedModeTrending;
    [self.trendingButton addTarget:self action:@selector(titleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.trendingButton];

    self.discoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.discoverButton.tag = HomeFeedModeDiscover;
    [self.discoverButton addTarget:self action:@selector(titleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.discoverButton];
}

- (void)configureLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:CGRectZero];
    self.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.18];
    self.loadingView.hidden = YES;
    self.loadingView.userInteractionEnabled = YES;
    [self.view addSubview:self.loadingView];

    if (@available(iOS 13.0, *)) {
        self.loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    } else {
        self.loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    self.loadingIndicatorView.color = UIColor.whiteColor;
    self.loadingIndicatorView.hidesWhenStopped = YES;
    [self.loadingView addSubview:self.loadingIndicatorView];
}

- (void)titleButtonTapped:(UIButton *)sender {
    self.feedMode = sender.tag == HomeFeedModeDiscover ? HomeFeedModeDiscover : HomeFeedModeTrending;
    [self updateTitleState];
    [self updateVisiblePosts];
}

- (void)aiButtonTapped {
    AISwimmingViewController *viewController = [[AISwimmingViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)updateTitleState {
    NSString *trendingImageName = self.feedMode == HomeFeedModeTrending ? @"HomeTitleTrendingSelected" : @"HomeTitleTrendingNormal";
    NSString *discoverImageName = self.feedMode == HomeFeedModeDiscover ? @"HomeTitleDiscoverSelected" : @"HomeTitleDiscoverNormal";

    [self.trendingButton setImage:[[UIImage imageNamed:trendingImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.discoverButton setImage:[[UIImage imageNamed:discoverImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)loadPosts {
    self.posts = @[];
    self.visiblePosts = @[];
    [self.collectionView reloadData];
    [self showLoadingView];

    __weak typeof(self) weakSelf = self;
    [[LuketDataService sharedService] loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        [strongSelf hideLoadingView];
        if (error) {
            NSLog(@"[Luket] Home postList load failed: %@", error.localizedDescription);
            return;
        }

        strongSelf.globalData = data;
        strongSelf.posts = data.postList ?: @[];
        [strongSelf updateVisiblePosts];
    }];
}

- (void)showLoadingView {
    self.loadingView.hidden = NO;
    [self.view bringSubviewToFront:self.loadingView];
    [self.loadingIndicatorView startAnimating];
}

- (void)hideLoadingView {
    [self.loadingIndicatorView stopAnimating];
    self.loadingView.hidden = YES;
}

- (void)updateVisiblePosts {
    NSMutableArray<LuketPost *> *visiblePosts = [NSMutableArray array];
    for (LuketPost *post in self.posts ?: @[]) {
        if (![self currentUserBlockedUserId:post.publishUserId]) {
            [visiblePosts addObject:post];
        }
    }

    if (self.feedMode == HomeFeedModeDiscover) {
        self.visiblePosts = [self randomPostsFromPosts:visiblePosts limit:3];
    } else {
        self.visiblePosts = visiblePosts.copy;
    }
    [self.collectionView reloadData];
}

- (NSArray<LuketPost *> *)randomPostsFromPosts:(NSArray<LuketPost *> *)posts limit:(NSUInteger)limit {
    if (posts.count <= limit) {
        return posts.copy;
    }

    NSMutableArray<LuketPost *> *remainingPosts = posts.mutableCopy;
    NSMutableArray<LuketPost *> *randomPosts = [NSMutableArray arrayWithCapacity:limit];
    while (randomPosts.count < limit && remainingPosts.count > 0) {
        NSUInteger index = arc4random_uniform((uint32_t)remainingPosts.count);
        [randomPosts addObject:remainingPosts[index]];
        [remainingPosts removeObjectAtIndex:index];
    }
    return randomPosts.copy;
}

- (void)blockedUsersDidChange {
    [self syncCachedGlobalDataAndRefresh];
}

- (void)syncCachedGlobalDataAndRefresh {
    LuketGlobalData *cachedGlobalData = LuketDataService.sharedService.cachedGlobalData;
    if (cachedGlobalData) {
        self.globalData = cachedGlobalData;
        self.posts = cachedGlobalData.postList ?: @[];
    }
    [self updateVisiblePosts];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.visiblePosts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeFeedCell" forIndexPath:indexPath];
    LuketPost *post = self.visiblePosts[indexPath.item];
    [cell configureWithPost:post author:[self userWithId:post.publishUserId] index:indexPath.item];

    __weak typeof(self) weakSelf = self;
    cell.avatarTapHandler = ^{
        [weakSelf presentUserProfileViewControllerForUserId:post.publishUserId];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= self.visiblePosts.count) {
        return;
    }

    LuketPost *post = self.visiblePosts[indexPath.item];
    if (![self isDetailMediaPost:post]) {
        return;
    }

    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.post = post;
    detailViewController.globalData = self.globalData;
    detailViewController.author = [self userWithId:post.publishUserId];
    detailViewController.users = self.globalData.userList ?: @[];
    detailViewController.postComments = [self commentsForPostId:post.postId];
    detailViewController.postLikedByCurrentUser = [self currentUserLikedPostId:post.postId];
    detailViewController.authorFollowedByCurrentUser = [self currentUserFollowedUserId:post.publishUserId];
    detailViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:detailViewController animated:YES completion:nil];
}

- (BOOL)isDetailMediaPost:(LuketPost *)post {
    NSString *mediaType = [post.mediaType lowercaseString];
    return [mediaType isEqualToString:LuketPostMediaTypeImage] || [mediaType isEqualToString:LuketPostMediaTypeVideo];
}

- (LuketUser *)userWithId:(NSString *)userId {
    if (userId.length == 0) {
        return nil;
    }

    for (LuketUser *user in self.globalData.userList) {
        if ([user.userId isEqualToString:userId]) {
            return user;
        }
    }
    return nil;
}

- (NSArray<LuketPostComment *> *)commentsForPostId:(NSString *)postId {
    if (postId.length == 0) {
        return @[];
    }

    NSMutableArray<LuketPostComment *> *comments = [NSMutableArray array];
    for (LuketPostComment *comment in self.globalData.postCommentList) {
        if ([comment.postId isEqualToString:postId]) {
            [comments addObject:comment];
        }
    }
    return comments.copy;
}

- (BOOL)currentUserLikedPostId:(NSString *)postId {
    NSString *currentUserId = LuketDataService.sharedService.currentLoginUserId;
    if (postId.length == 0 || currentUserId.length == 0) {
        return NO;
    }

    for (LuketLikeRelation *relation in self.globalData.likeList) {
        if ([relation.postId isEqualToString:postId] && [relation.userId isEqualToString:currentUserId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)currentUserFollowedUserId:(NSString *)targetUserId {
    NSString *currentUserId = LuketDataService.sharedService.currentLoginUserId;
    if (currentUserId.length == 0 || targetUserId.length == 0 || [currentUserId isEqualToString:targetUserId]) {
        return NO;
    }

    for (LuketFollowRelation *relation in self.globalData.followList) {
        if ([relation.userId isEqualToString:currentUserId] && [relation.targetUserId isEqualToString:targetUserId]) {
            return YES;
        }
    }
    return NO;
}

- (void)presentUserProfileViewControllerForUserId:(NSString *)userId {
    if ([self currentUserBlockedUserId:userId]) {
        return;
    }

    UserProfileViewController *viewController = [[UserProfileViewController alloc] init];
    LuketUser *user = [self userWithId:userId];
    viewController.profileUser = user;
    viewController.globalData = self.globalData;
    viewController.profilePosts = [self postsForUserId:userId];
    viewController.followedByCurrentUser = [self currentUserFollowedUserId:userId];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (BOOL)currentUserBlockedUserId:(NSString *)targetUserId {
    NSString *currentUserId = LuketDataService.sharedService.currentLoginUserId;
    if (currentUserId.length == 0 || targetUserId.length == 0) {
        return NO;
    }

    for (LuketBlackRelation *relation in self.globalData.blackList) {
        if ([relation.blockUserId isEqualToString:currentUserId] && [relation.targetUserId isEqualToString:targetUserId]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray<LuketPost *> *)postsForUserId:(NSString *)userId {
    if (userId.length == 0) {
        return @[];
    }

    NSMutableArray<LuketPost *> *posts = [NSMutableArray array];
    for (LuketPost *post in self.globalData.postList) {
        if ([post.publishUserId isEqualToString:userId]) {
            [posts addObject:post];
        }
    }
    return posts.copy;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat scale = CGRectGetWidth(collectionView.bounds) / 375.0;
    return CGSizeMake(162.0 * scale, 187.0 * scale);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat scale = CGRectGetWidth(collectionView.bounds) / 375.0;
    return UIEdgeInsetsMake(0.0, 20.0 * scale, 0.0, 20.0 * scale);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat scale = CGRectGetWidth(collectionView.bounds) / 375.0;
    return 13.0 * scale;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat scale = CGRectGetWidth(collectionView.bounds) / 375.0;
    return 11.0 * scale;
}

- (UIColor *)mainBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
