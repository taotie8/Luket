//
//  DetailViewController.m
//  Luket
//
//  Created by Codex on 2026/6/3.
//

#import "DetailViewController.h"
#import "../Profile/UserProfileViewController.h"
#import "../Common/MoreActionSheetView.h"
#import "../Common/LuketMediaResource.h"
#import "../Data/Service/LuketDataService.h"
#import "../Report/ReportViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIScrollView *mediaScrollView;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *mediaImageViews;
@property (nonatomic, copy) NSArray<NSString *> *mediaImageIdentifiers;
@property (nonatomic, assign) NSInteger currentMediaIndex;
@property (nonatomic, strong) UIView *videoContainerView;
@property (nonatomic, strong) UIImageView *videoCoverImageView;
@property (nonatomic, strong) UIImageView *videoPlayIconView;
@property (nonatomic, strong) AVPlayer *videoPlayer;
@property (nonatomic, strong) AVPlayerLayer *videoPlayerLayer;
@property (nonatomic, strong) UIView *imageFrameView;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIImageView *likeIconView;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *commentsTitleLabel;
@property (nonatomic, strong) UIView *commentInputView;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIImageView *sendButtonImageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) BOOL following;
@property (nonatomic, assign) BOOL updatingFollow;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL updatingLike;
@property (nonatomic, assign) BOOL updatingComment;
@property (nonatomic, assign) BOOL updatingBlock;
@property (nonatomic, assign) NSInteger likeCount;

@end

@implementation DetailViewController

- (void)setPost:(LuketPost *)post {
    _post = post;
    [self applyPostData];
}

- (void)setAuthor:(LuketUser *)author {
    _author = author;
    [self applyPostData];
}

- (void)setUsers:(NSArray<LuketUser *> *)users {
    _users = users.copy ?: @[];
    [self.tableView reloadData];
}

- (void)setPostComments:(NSArray<LuketPostComment *> *)postComments {
    _postComments = postComments.copy ?: @[];
    [self.tableView reloadData];
}

- (void)setPostLikedByCurrentUser:(BOOL)postLikedByCurrentUser {
    _postLikedByCurrentUser = postLikedByCurrentUser;
    self.liked = postLikedByCurrentUser;
    if (self.isViewLoaded) {
        [self updateLikeState];
    }
}

- (void)setAuthorFollowedByCurrentUser:(BOOL)authorFollowedByCurrentUser {
    _authorFollowedByCurrentUser = authorFollowedByCurrentUser;
    self.following = authorFollowedByCurrentUser;
    if (self.isViewLoaded) {
        [self updateFollowButton];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.following = self.authorFollowedByCurrentUser;
    if (!self.users) {
        self.users = @[];
    }
    if (!self.postComments) {
        self.postComments = @[];
    }
    self.liked = self.postLikedByCurrentUser;
    self.likeCount = self.post ? self.post.likeCount : 333;
    self.view.backgroundColor = [UIColor colorWithRed:0.19 green:0.31 blue:0.34 alpha:1.0];
    [self configureBackground];
    [self configureTableView];
    [self configureTopBar];
    [self configureImageArea];
    [self configureTextArea];
    [self configureCommentInput];
    [self configureKeyboardHandling];
    [self updateFollowButton];
    [self applyPostData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutDetailViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self isVideoPost:self.post] && !self.videoPlayer) {
        [self configureVideoWithPost:self.post];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopVideoPlayback];
}

- (void)layoutDetailViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat scale = width / 375.0;
    CGFloat safeTop = self.view.safeAreaInsets.top;

    CGFloat inputHeight = 56.0;
    self.tableView.frame = self.view.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, inputHeight + 41.0, 0.0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    self.topBarView.frame = CGRectMake(20.0, safeTop + 5, width - 40.0, 56.0);
    self.topBarView.layer.cornerRadius = 12.0 * scale;
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(112.0, 15.0, CGRectGetWidth(self.nameLabel.bounds), 26.0);
    self.followButton.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10.0, 16.0, 36.0, 24.0);
    self.moreButton.frame = CGRectMake(CGRectGetWidth(self.topBarView.bounds) - 12.0 - 32.0, 13.0, 32.0, 32.0);
    
    self.avatarImageView.frame = CGRectMake(60.0, 8.0, 40.0, 40.0);
    self.avatarImageView.layer.cornerRadius = 20.0;
    UIButton *avatarButton = [self.topBarView viewWithTag:1010];
    avatarButton.frame = self.avatarImageView.frame;

    self.headerContentView.frame = CGRectMake(0.0, 0.0, width, 700.0 * scale);

    CGFloat imageY = safeTop + 85;
    self.imageFrameView.frame = CGRectMake(20.0 * scale, imageY, width - 40, 470.0 * scale);
    self.imageFrameView.layer.cornerRadius = 32.0 * scale;
    self.mediaScrollView.frame = CGRectInset(self.imageFrameView.bounds, 7.0 * scale, 7.0 * scale);
    self.mediaScrollView.layer.cornerRadius = 25.0 * scale;
    self.videoContainerView.frame = self.mediaScrollView.frame;
    self.videoContainerView.layer.cornerRadius = 25.0 * scale;
    self.videoCoverImageView.frame = self.videoContainerView.bounds;
    self.videoPlayIconView.center = CGPointMake(CGRectGetMidX(self.videoContainerView.bounds), CGRectGetMidY(self.videoContainerView.bounds));
    self.videoPlayerLayer.frame = self.videoContainerView.bounds;
    [self layoutMediaImageViews];

    CGFloat likeWidth = 144.0 * scale;
    CGFloat likeHeight = 59.0 * scale;
    self.likeButton.bounds = CGRectMake(0.0, 0.0, likeWidth, likeHeight);
    self.likeButton.center = CGPointMake(CGRectGetMidX(self.imageFrameView.frame), CGRectGetMaxY(self.imageFrameView.frame) - 4.0 * scale);
    CGFloat pageWidth = 73.0 * scale;
    CGFloat pageHeight = 24.0 * scale;
    self.pageLabel.frame = CGRectMake(CGRectGetMidX(self.likeButton.frame) - pageWidth / 2.0, CGRectGetMinY(self.likeButton.frame) - 10.0 - pageHeight, pageWidth, pageHeight);
    self.pageLabel.layer.cornerRadius = 12.0 * scale;
    self.likeCountLabel.frame = CGRectMake(CGRectGetWidth(self.likeButton.bounds) - 15.0 * scale - 50.0 * scale, 17.0 * scale, 50.0 * scale, 24.0 * scale);

    self.contentLabel.frame = CGRectMake(20.0 * scale, 636.0 * scale, 300.0 * scale, 22.0 * scale);
    self.commentsTitleLabel.frame = CGRectMake(20.0 * scale, 670.0 * scale, 170.0 * scale, 24.0 * scale);
    self.tableView.tableHeaderView = self.headerContentView;

    CGFloat inputBottom = self.keyboardHeight > 0.0 ? self.keyboardHeight + 10.0 : 29.0;
    self.commentInputView.frame = CGRectMake(20.0, CGRectGetHeight(self.view.bounds) - inputHeight - inputBottom, width - 40.0, inputHeight);
    self.commentInputView.layer.cornerRadius = inputHeight / 2.0;
    self.sendButtonImageView.frame = CGRectMake(CGRectGetWidth(self.commentInputView.bounds) - 86.0, 0.0, 86.0, inputHeight);
    self.commentTextField.frame = CGRectMake(20.0, 0.0, CGRectGetMinX(self.sendButtonImageView.frame) - 30.0, inputHeight);
    self.backgroundImageView.frame = self.view.bounds;
}

- (void)configureBackground {
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailBackground"]];
    self.backgroundImageView.frame = self.view.bounds;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    [self.view addSubview:self.backgroundImageView];
}

- (void)configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"CommentCell"];
    [self.view addSubview:self.tableView];

    self.headerContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.headerContentView.backgroundColor = UIColor.clearColor;
    self.tableView.tableHeaderView = self.headerContentView;
}

- (void)configureTopBar {
    self.topBarView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topBarView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.topBarView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16.0, 0.0, 32, 56);
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:backButton];

    self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    self.avatarImageView.frame = CGRectMake(60.0, 8.0, 40.0, 40.0);
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 20;
    [self.topBarView addSubview:self.avatarImageView];
    
    UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarButton.tag = 1010;
    avatarButton.frame = self.avatarImageView.frame;
    [avatarButton addTarget:self action:@selector(userAvatarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:avatarButton];

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.text = @"Freya";
    self.nameLabel.textColor = [self darkTextColor];
    self.nameLabel.font = [self titleFontWithSize:20.0];
    [self.topBarView addSubview:self.nameLabel];

    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.followButton addTarget:self action:@selector(followButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:self.followButton];

    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton setImage:[[UIImage imageNamed:@"DetailMoreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:self.moreButton];
}

- (void)configureImageArea {
    self.imageFrameView = [[UIView alloc] initWithFrame:CGRectZero];
    self.imageFrameView.backgroundColor = UIColor.whiteColor;
    self.imageFrameView.clipsToBounds = YES;
    [self.headerContentView addSubview:self.imageFrameView];

    self.mediaScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.mediaScrollView.backgroundColor = UIColor.clearColor;
    self.mediaScrollView.pagingEnabled = YES;
    self.mediaScrollView.showsHorizontalScrollIndicator = NO;
    self.mediaScrollView.showsVerticalScrollIndicator = NO;
    self.mediaScrollView.bounces = YES;
    self.mediaScrollView.delegate = self;
    self.mediaScrollView.clipsToBounds = YES;
    self.mediaScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.imageFrameView addSubview:self.mediaScrollView];
    self.mediaImageViews = [NSMutableArray array];

    self.videoContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.videoContainerView.backgroundColor = UIColor.blackColor;
    self.videoContainerView.clipsToBounds = YES;
    self.videoContainerView.hidden = YES;
    [self.imageFrameView addSubview:self.videoContainerView];

    self.videoCoverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    self.videoCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoCoverImageView.clipsToBounds = YES;
    [self.videoContainerView addSubview:self.videoCoverImageView];

    self.videoPlayIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeVideoPlayIcon"]];
    self.videoPlayIconView.frame = CGRectMake(0.0, 0.0, 54.0, 54.0);
    self.videoPlayIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.videoContainerView addSubview:self.videoPlayIconView];

    UITapGestureRecognizer *videoTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTapped)];
    [self.videoContainerView addGestureRecognizer:videoTapGesture];

    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pageLabel.backgroundColor = UIColor.whiteColor;
    self.pageLabel.text = @"1/4";
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.textColor = [UIColor colorWithRed:0.0 green:0.63 blue:0.93 alpha:1.0];
    self.pageLabel.font = [self titleFontWithSize:21.0];
    self.pageLabel.clipsToBounds = YES;
    [self.headerContentView addSubview:self.pageLabel];

    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton.backgroundColor = UIColor.clearColor;
    [self.likeButton addTarget:self action:@selector(likeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerContentView addSubview:self.likeButton];

    UIImageView *likeBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailLikeBarBackground"]];
    likeBackgroundView.frame = CGRectMake(0.0, 0.0, 144.0, 59.0);
    likeBackgroundView.contentMode = UIViewContentModeScaleToFill;
    [self.likeButton addSubview:likeBackgroundView];

    self.likeIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailLikeIcon"]];
    self.likeIconView.frame = CGRectMake(24.0, 10.0, 40.0, 40.0);
    self.likeIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.likeButton addSubview:self.likeIconView];

    self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.likeCountLabel.textColor = UIColor.whiteColor;
    self.likeCountLabel.font = [self titleFontWithSize:22.0];
    [self.likeButton addSubview:self.likeCountLabel];
    [self updateLikeState];
    [self configureMediaImagesWithIdentifiers:@[@""]];
}

- (void)configureTextArea {
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.text = @"Every time I swim, I feel passionate";
    self.contentLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.78];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    [self.headerContentView addSubview:self.contentLabel];

    self.commentsTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.commentsTitleLabel.text = @"comments";
    self.commentsTitleLabel.textColor = UIColor.whiteColor;
    self.commentsTitleLabel.font = [self titleFontWithSize:19.0];
    [self.headerContentView addSubview:self.commentsTitleLabel];
}

- (void)configureCommentInput {
    self.commentInputView = [[UIView alloc] initWithFrame:CGRectZero];
    self.commentInputView.backgroundColor = UIColor.whiteColor;
    self.commentInputView.layer.borderColor = [UIColor colorWithRed:0.86 green:0.9 blue:0.94 alpha:1.0].CGColor;
    self.commentInputView.layer.borderWidth = 1.0;
    [self.view addSubview:self.commentInputView];

    self.commentTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.commentTextField.borderStyle = UITextBorderStyleNone;
    self.commentTextField.backgroundColor = UIColor.clearColor;
    self.commentTextField.textColor = [self darkTextColor];
    self.commentTextField.font = [UIFont systemFontOfSize:13.0];
    self.commentTextField.delegate = self;
    self.commentTextField.returnKeyType = UIReturnKeyDone;
    self.commentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Every time I swim, I feel ..."
                                                                                  attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.69 green:0.75 blue:0.83 alpha:1.0]}];
    [self.commentInputView addSubview:self.commentTextField];

    self.sendButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailSendButtonBackground"]];
    self.sendButtonImageView.contentMode = UIViewContentModeScaleToFill;
    self.sendButtonImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *sendTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendCommentButtonTapped)];
    [self.sendButtonImageView addGestureRecognizer:sendTapGesture];
    [self.commentInputView addSubview:self.sendButtonImageView];
}

- (void)configureKeyboardHandling {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)applyPostData {
    if (!self.isViewLoaded) {
        return;
    }

    LuketPost *post = self.post;
    LuketUser *author = self.author ?: [self userWithId:post.publishUserId];

    if (post) {
        self.nameLabel.text = [self displayNameForAuthor:author post:post];
        self.contentLabel.text = post.content.length > 0 ? post.content : @"";
        self.likeCount = post.likeCount;
        self.liked = self.postLikedByCurrentUser;
        if ([self isVideoPost:post]) {
            [self configureVideoWithPost:post];
        } else {
            [self configureMediaImagesWithIdentifiers:[self mediaImageIdentifiersForPost:post]];
        }
    }

    [self setImageView:self.avatarImageView identifier:author.avatarUrl placeholderImageName:@"HomeHeroImage"];
    [self updateLikeState];
    [self.tableView reloadData];
    [self.view setNeedsLayout];
}

- (NSString *)displayNameForAuthor:(LuketUser *)author post:(LuketPost *)post {
    if (author.nickname.length > 0) {
        return author.nickname;
    }
    if (author.email.length > 0) {
        return author.email;
    }
    if (post.publishUserId.length > 0) {
        return post.publishUserId;
    }
    return @"Freya";
}

- (NSArray<NSString *> *)mediaImageIdentifiersForPost:(LuketPost *)post {
    NSMutableArray<NSString *> *identifiers = [NSMutableArray array];
    for (NSString *identifier in post.mediaUrls) {
        NSString *trimmedIdentifier = [identifier stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        if (trimmedIdentifier.length > 0) {
            [identifiers addObject:trimmedIdentifier];
        }
    }

    if (identifiers.count == 0 && post.coverUrl.length > 0) {
        [identifiers addObject:post.coverUrl];
    }

    if (identifiers.count == 0) {
        [identifiers addObject:@""];
    }
    return identifiers.copy;
}

- (BOOL)isVideoPost:(LuketPost *)post {
    return [[post.mediaType lowercaseString] isEqualToString:LuketPostMediaTypeVideo];
}

- (void)configureVideoWithPost:(LuketPost *)post {
    self.mediaScrollView.hidden = YES;
    self.videoContainerView.hidden = NO;
    self.pageLabel.hidden = YES;
    self.videoCoverImageView.hidden = NO;
    self.videoPlayIconView.hidden = NO;

    for (UIImageView *imageView in self.mediaImageViews) {
        [imageView sd_cancelCurrentImageLoad];
        [imageView removeFromSuperview];
    }
    [self.mediaImageViews removeAllObjects];

    [self setImageView:self.videoCoverImageView identifier:[self videoCoverIdentifierForPost:post] placeholderImageName:@"HomeHeroImage"];

    NSURL *videoURL = [LuketMediaResource resourceURLWithIdentifier:[self videoIdentifierForPost:post]];
    [self stopVideoPlayback];
    if (!videoURL) {
        return;
    }

    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
    self.videoPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    self.videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    self.videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.videoPlayerLayer.frame = self.videoContainerView.bounds;
    [self.videoContainerView.layer insertSublayer:self.videoPlayerLayer atIndex:0];
    self.videoCoverImageView.hidden = YES;
    self.videoPlayIconView.hidden = YES;
    [self.videoPlayer play];
}

- (NSString *)videoIdentifierForPost:(LuketPost *)post {
    for (NSString *identifier in post.mediaUrls) {
        NSString *trimmedIdentifier = [identifier stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        if (trimmedIdentifier.length > 0) {
            return trimmedIdentifier;
        }
    }
    return post.coverUrl ?: @"";
}

- (NSString *)videoCoverIdentifierForPost:(LuketPost *)post {
    if (post.coverUrl.length > 0) {
        return post.coverUrl;
    }
    return [self videoIdentifierForPost:post];
}

- (void)configureMediaImagesWithIdentifiers:(NSArray<NSString *> *)identifiers {
    [self stopVideoPlayback];
    self.mediaScrollView.hidden = NO;
    self.videoContainerView.hidden = YES;
    self.pageLabel.hidden = NO;
    self.mediaImageIdentifiers = identifiers.count > 0 ? identifiers.copy : @[@""];
    self.currentMediaIndex = 0;

    for (UIImageView *imageView in self.mediaImageViews) {
        [imageView sd_cancelCurrentImageLoad];
        [imageView removeFromSuperview];
    }
    [self.mediaImageViews removeAllObjects];

    for (NSString *identifier in self.mediaImageIdentifiers) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.mediaScrollView addSubview:imageView];
        [self.mediaImageViews addObject:imageView];
        [self setImageView:imageView identifier:identifier placeholderImageName:@"HomeHeroImage"];
    }

    self.mediaScrollView.scrollEnabled = self.mediaImageIdentifiers.count > 1;
    self.mediaScrollView.contentOffset = CGPointZero;
    [self layoutMediaImageViews];
    [self updatePageLabel];
}

- (void)layoutMediaImageViews {
    CGSize pageSize = self.mediaScrollView.bounds.size;
    if (pageSize.width <= 0.0 || pageSize.height <= 0.0) {
        return;
    }

    for (NSUInteger index = 0; index < self.mediaImageViews.count; index++) {
        UIImageView *imageView = self.mediaImageViews[index];
        imageView.frame = CGRectMake(pageSize.width * index, 0.0, pageSize.width, pageSize.height);
    }

    NSInteger totalCount = MAX((NSInteger)self.mediaImageViews.count, 1);
    self.mediaScrollView.contentSize = CGSizeMake(pageSize.width * totalCount, pageSize.height);
    NSInteger visibleIndex = MIN(MAX(self.currentMediaIndex, 0), totalCount - 1);
    self.mediaScrollView.contentOffset = CGPointMake(pageSize.width * visibleIndex, 0.0);
}

- (void)updateCurrentMediaIndexFromScrollView {
    CGFloat pageWidth = CGRectGetWidth(self.mediaScrollView.bounds);
    if (pageWidth <= 0.0) {
        return;
    }

    NSInteger totalCount = MAX((NSInteger)self.mediaImageViews.count, 1);
    NSInteger pageIndex = (NSInteger)lround(self.mediaScrollView.contentOffset.x / pageWidth);
    self.currentMediaIndex = MIN(MAX(pageIndex, 0), totalCount - 1);
    [self updatePageLabel];
}

- (void)updatePageLabel {
    NSInteger totalCount = MAX((NSInteger)self.mediaImageIdentifiers.count, 1);
    NSInteger visibleIndex = MIN(MAX(self.currentMediaIndex, 0), totalCount - 1);
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)visibleIndex + 1, (long)totalCount];
}

- (LuketUser *)userWithId:(NSString *)userId {
    if (userId.length == 0) {
        return nil;
    }

    for (LuketUser *user in self.users) {
        if ([user.userId isEqualToString:userId]) {
            return user;
        }
    }
    return nil;
}

- (void)setImageView:(UIImageView *)imageView identifier:(NSString *)identifier placeholderImageName:(NSString *)placeholderImageName {
    UIImage *placeholderImage = [UIImage imageNamed:placeholderImageName];
    UIImage *localImage = [LuketMediaResource localImageWithIdentifier:identifier];
    if (localImage) {
        [imageView sd_cancelCurrentImageLoad];
        imageView.image = localImage;
        return;
    }

    NSURL *imageURL = [LuketMediaResource imageURLWithIdentifier:identifier];
    if (!imageURL) {
        [imageView sd_cancelCurrentImageLoad];
        imageView.image = placeholderImage;
        return;
    }

    [imageView sd_setImageWithURL:imageURL
                 placeholderImage:placeholderImage
                          options:SDWebImageRetryFailed | SDWebImageScaleDownLargeImages];
}

- (void)videoViewTapped {
    if (!self.videoPlayer) {
        return;
    }

    if (self.videoPlayer.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self.videoPlayer pause];
        self.videoPlayIconView.hidden = NO;
        return;
    }

    self.videoCoverImageView.hidden = YES;
    self.videoPlayIconView.hidden = YES;
    [self.videoPlayer play];
}

- (void)videoDidFinishPlaying:(NSNotification *)notification {
    if (notification.object != self.videoPlayer.currentItem) {
        return;
    }

    [self.videoPlayer seekToTime:kCMTimeZero];
    self.videoCoverImageView.hidden = YES;
    self.videoPlayIconView.hidden = YES;
    [self.videoPlayer play];
}

- (void)stopVideoPlayback {
    if (self.videoPlayer.currentItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.videoPlayer.currentItem];
    }
    [self.videoPlayer pause];
    self.videoPlayer = nil;
    [self.videoPlayerLayer removeFromSuperlayer];
    self.videoPlayerLayer = nil;
    self.videoCoverImageView.hidden = NO;
    self.videoPlayIconView.hidden = NO;
}

- (void)sendCommentButtonTapped {
    if (self.updatingComment || !self.globalData || self.post.postId.length == 0) {
        return;
    }

    NSString *content = [self.commentTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSString *currentUserId = LuketDataService.sharedService.currentLoginUserId;
    if (content.length == 0 || currentUserId.length == 0) {
        return;
    }

    NSArray<LuketPostComment *> *previousPostComments = self.postComments.copy ?: @[];
    NSArray<LuketPostComment *> *previousGlobalComments = self.globalData.postCommentList.copy ?: @[];
    NSInteger previousCommentCount = self.post.commentCount;
    NSString *previousInputText = self.commentTextField.text ?: @"";

    LuketPostComment *comment = [LuketPostComment modelWithDictionary:@{
        @"commentId": [self newCommentId],
        @"postId": self.post.postId,
        @"fromUserId": currentUserId,
        @"content": content,
        @"commentTime": [self currentRelationTimeString]
    }];

    NSInteger targetCommentCount = MAX(previousCommentCount, (NSInteger)previousPostComments.count) + 1;
    [self appendComment:comment commentCount:targetCommentCount];
    self.commentTextField.text = @"";
    [self.commentTextField resignFirstResponder];
    [self setCommentSubmitting:YES];

    __weak typeof(self) weakSelf = self;
    [[LuketDataService sharedService] saveGlobalData:self.globalData completion:^(BOOL success, NSString *message, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        [strongSelf setCommentSubmitting:NO];

        if (!success || error) {
            strongSelf.globalData.postCommentList = previousGlobalComments;
            strongSelf.postComments = previousPostComments;
            [strongSelf updateGlobalDataPostCommentCount:previousCommentCount];
            strongSelf.commentTextField.text = previousInputText;
            NSLog(@"[Luket] Save post comment failed: %@", error.localizedDescription ?: message);
        }
    }];
}

- (void)setCommentSubmitting:(BOOL)submitting {
    self.updatingComment = submitting;
    self.sendButtonImageView.userInteractionEnabled = !submitting;
    self.commentTextField.enabled = !submitting;
}

- (void)appendComment:(LuketPostComment *)comment commentCount:(NSInteger)commentCount {
    if (!comment) {
        return;
    }

    NSMutableArray<LuketPostComment *> *postComments = self.postComments.mutableCopy ?: [NSMutableArray array];
    [postComments addObject:comment];
    self.postComments = postComments.copy;

    NSMutableArray<LuketPostComment *> *globalComments = self.globalData.postCommentList.mutableCopy ?: [NSMutableArray array];
    [globalComments addObject:comment];
    self.globalData.postCommentList = globalComments.copy;

    [self updateGlobalDataPostCommentCount:commentCount];
}

- (void)updateGlobalDataPostCommentCount:(NSInteger)commentCount {
    NSInteger normalizedCount = MAX(commentCount, 0);
    self.post.commentCount = normalizedCount;
    for (LuketPost *post in self.globalData.postList) {
        if ([post.postId isEqualToString:self.post.postId]) {
            post.commentCount = normalizedCount;
            break;
        }
    }
}

- (NSString *)newCommentId {
    return [[NSUUID UUID] UUIDString];
}

- (void)followButtonTapped {
    if (self.updatingFollow || !self.globalData) {
        return;
    }

    NSString *currentUserId = LuketDataService.sharedService.currentLoginUserId;
    NSString *targetUserId = [self targetUserIdForFollow];
    if (currentUserId.length == 0 || targetUserId.length == 0 || [currentUserId isEqualToString:targetUserId]) {
        return;
    }

    BOOL previousFollowing = [self currentUserId:currentUserId followedUserId:targetUserId];
    NSArray<LuketFollowRelation *> *previousFollowList = self.globalData.followList.copy ?: @[];
    BOOL targetFollowing = !previousFollowing;

    [self applyFollowing:targetFollowing];
    [self updateGlobalDataFollowListForUserId:currentUserId targetUserId:targetUserId followed:targetFollowing];

    self.updatingFollow = YES;
    self.followButton.enabled = NO;

    __weak typeof(self) weakSelf = self;
    [[LuketDataService sharedService] saveGlobalData:self.globalData completion:^(BOOL success, NSString *message, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        strongSelf.updatingFollow = NO;
        strongSelf.followButton.enabled = YES;

        if (!success || error) {
            strongSelf.globalData.followList = previousFollowList;
            [strongSelf applyFollowing:previousFollowing];
            NSLog(@"[Luket] Save follow failed: %@", error.localizedDescription ?: message);
        }
    }];
}

- (void)likeButtonTapped {
    if (self.updatingLike || self.post.postId.length == 0 || !self.globalData) {
        return;
    }

    NSString *currentUserId = LuketDataService.sharedService.currentLoginUserId;
    if (currentUserId.length == 0) {
        return;
    }

    BOOL previousLiked = [self currentUserIdLikedPost:currentUserId];
    NSInteger previousLikeCount = self.likeCount;
    NSArray<LuketLikeRelation *> *previousLikeList = self.globalData.likeList.copy ?: @[];
    BOOL targetLiked = !previousLiked;

    [self applyLiked:targetLiked likeCount:targetLiked ? previousLikeCount + 1 : MAX(previousLikeCount - 1, 0)];
    [self updateGlobalDataLikeListForUserId:currentUserId liked:targetLiked];
    [self updateGlobalDataPostLikeCount:self.likeCount];

    self.updatingLike = YES;
    self.likeButton.enabled = NO;

    __weak typeof(self) weakSelf = self;
    [[LuketDataService sharedService] saveGlobalData:self.globalData completion:^(BOOL success, NSString *message, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        strongSelf.updatingLike = NO;
        strongSelf.likeButton.enabled = YES;

        if (!success || error) {
            strongSelf.globalData.likeList = previousLikeList;
            [strongSelf applyLiked:previousLiked likeCount:previousLikeCount];
            [strongSelf updateGlobalDataPostLikeCount:previousLikeCount];
            NSLog(@"[Luket] Save post like failed: %@", error.localizedDescription ?: message);
        }
    }];
}

- (void)updateLikeState {
    NSString *imageName = self.liked ? @"DetailLikeIcon" : @"DetailSendIcon";
    self.likeIconView.image = [UIImage imageNamed:imageName];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.likeCount];
    self.likeCountLabel.alpha = self.liked ? 1.0 : 0.75;
}

- (void)applyLiked:(BOOL)liked likeCount:(NSInteger)likeCount {
    self.liked = liked;
    self.postLikedByCurrentUser = liked;
    self.likeCount = MAX(likeCount, 0);
    self.post.likeCount = self.likeCount;
    [self updateLikeState];
}

- (BOOL)currentUserIdLikedPost:(NSString *)userId {
    if (userId.length == 0 || self.post.postId.length == 0) {
        return NO;
    }

    for (LuketLikeRelation *relation in self.globalData.likeList) {
        if ([relation.userId isEqualToString:userId] && [relation.postId isEqualToString:self.post.postId]) {
            return YES;
        }
    }
    return NO;
}

- (void)updateGlobalDataLikeListForUserId:(NSString *)userId liked:(BOOL)liked {
    NSMutableArray<LuketLikeRelation *> *likeList = self.globalData.likeList.mutableCopy ?: [NSMutableArray array];
    NSIndexSet *matchingIndexes = [likeList indexesOfObjectsPassingTest:^BOOL(LuketLikeRelation *relation, NSUInteger index, BOOL *stop) {
        return [relation.userId isEqualToString:userId] && [relation.postId isEqualToString:self.post.postId];
    }];

    if (liked) {
        if (matchingIndexes.count == 0) {
            LuketLikeRelation *relation = [LuketLikeRelation modelWithDictionary:@{
                @"userId": userId,
                @"postId": self.post.postId,
                @"likeTime": [self currentLikeTimeString]
            }];
            [likeList addObject:relation];
        }
    } else if (matchingIndexes.count > 0) {
        [likeList removeObjectsAtIndexes:matchingIndexes];
    }

    self.globalData.likeList = likeList.copy;
}

- (void)updateGlobalDataPostLikeCount:(NSInteger)likeCount {
    for (LuketPost *post in self.globalData.postList) {
        if ([post.postId isEqualToString:self.post.postId]) {
            post.likeCount = MAX(likeCount, 0);
            break;
        }
    }
}

- (NSString *)currentLikeTimeString {
    return [self currentRelationTimeString];
}

- (NSString *)currentRelationTimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)targetUserIdForFollow {
    if (self.author.userId.length > 0) {
        return self.author.userId;
    }
    if (self.post.publishUserId.length > 0) {
        return self.post.publishUserId;
    }
    return @"";
}

- (BOOL)currentUserId:(NSString *)userId followedUserId:(NSString *)targetUserId {
    if (userId.length == 0 || targetUserId.length == 0) {
        return NO;
    }

    for (LuketFollowRelation *relation in self.globalData.followList) {
        if ([relation.userId isEqualToString:userId] && [relation.targetUserId isEqualToString:targetUserId]) {
            return YES;
        }
    }
    return NO;
}

- (void)applyFollowing:(BOOL)following {
    self.following = following;
    _authorFollowedByCurrentUser = following;
    [self updateFollowButton];
}

- (void)updateGlobalDataFollowListForUserId:(NSString *)userId targetUserId:(NSString *)targetUserId followed:(BOOL)followed {
    NSMutableArray<LuketFollowRelation *> *followList = self.globalData.followList.mutableCopy ?: [NSMutableArray array];
    NSIndexSet *matchingIndexes = [followList indexesOfObjectsPassingTest:^BOOL(LuketFollowRelation *relation, NSUInteger index, BOOL *stop) {
        return [relation.userId isEqualToString:userId] && [relation.targetUserId isEqualToString:targetUserId];
    }];

    if (followed) {
        if (matchingIndexes.count == 0) {
            LuketFollowRelation *relation = [LuketFollowRelation modelWithDictionary:@{
                @"userId": userId,
                @"targetUserId": targetUserId,
                @"followTime": [self currentRelationTimeString]
            }];
            [followList addObject:relation];
        }
    } else if (matchingIndexes.count > 0) {
        [followList removeObjectsAtIndexes:matchingIndexes];
    }

    self.globalData.followList = followList.copy;
}

- (void)updateFollowButton {
    NSString *imageName = self.following ? @"DetailFollowRemoveButton" : @"DetailFollowAddButton";
    [self.followButton setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moreButtonTapped {
    MoreActionSheetView *actionSheetView = [[MoreActionSheetView alloc] initWithFrame:self.view.bounds];

    __weak typeof(self) weakSelf = self;
    actionSheetView.reportHandler = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf presentReportViewController];
        });
    };

    actionSheetView.shieldHandler = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        [strongSelf blockAuthorFromActionSheet];
    };

    [actionSheetView showInView:self.view];
}

- (void)presentReportViewController {
    if (self.presentedViewController) {
        return;
    }

    ReportViewController *viewController = [[ReportViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)blockAuthorFromActionSheet {
    if (self.updatingBlock || !self.globalData) {
        return;
    }

    NSString *currentUserId = LuketDataService.sharedService.currentLoginUserId;
    NSString *targetUserId = [self targetUserIdForFollow];
    if (currentUserId.length == 0 || targetUserId.length == 0 || [currentUserId isEqualToString:targetUserId]) {
        return;
    }

    NSArray<LuketBlackRelation *> *previousBlackList = self.globalData.blackList.copy ?: @[];
    [self updateGlobalDataBlackListForUserId:currentUserId targetUserId:targetUserId];

    self.updatingBlock = YES;
    __weak typeof(self) weakSelf = self;
    [[LuketDataService sharedService] saveGlobalData:self.globalData completion:^(BOOL success, NSString *message, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        strongSelf.updatingBlock = NO;
        if (!success || error) {
            strongSelf.globalData.blackList = previousBlackList;
            NSLog(@"[Luket] Save block user failed: %@", error.localizedDescription ?: message);
            return;
        }

        [strongSelf notifyBlockedUsersDidChange];
        [strongSelf dismissToFirstLevelPage];
    }];
}

- (void)notifyBlockedUsersDidChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LuketBlockedUsersDidChangeNotification" object:nil];
}

- (void)dismissToFirstLevelPage {
    UIViewController *presenter = self.presentingViewController;
    while (presenter.presentingViewController) {
        presenter = presenter.presentingViewController;
    }

    [presenter dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateGlobalDataBlackListForUserId:(NSString *)userId targetUserId:(NSString *)targetUserId {
    NSMutableArray<LuketBlackRelation *> *blackList = self.globalData.blackList.mutableCopy ?: [NSMutableArray array];
    NSIndexSet *matchingIndexes = [blackList indexesOfObjectsPassingTest:^BOOL(LuketBlackRelation *relation, NSUInteger index, BOOL *stop) {
        return [relation.blockUserId isEqualToString:userId] && [relation.targetUserId isEqualToString:targetUserId];
    }];

    if (matchingIndexes.count == 0) {
        LuketBlackRelation *relation = [LuketBlackRelation modelWithDictionary:@{
            @"blockUserId": userId,
            @"targetUserId": targetUserId,
            @"blockTime": [self currentRelationTimeString]
        }];
        [blackList addObject:relation];
    }

    self.globalData.blackList = blackList.copy;
}

- (void)userAvatarButtonTapped {
    UserProfileViewController *viewController = [[UserProfileViewController alloc] init];
    viewController.profileUser = self.author ?: [self userWithId:self.post.publishUserId];
    viewController.globalData = self.globalData;
    viewController.profilePosts = [self postsForUserId:viewController.profileUser.userId];
    viewController.followedByCurrentUser = self.authorFollowedByCurrentUser;
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.mediaScrollView) {
        [self updateCurrentMediaIndexFromScrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.mediaScrollView && !decelerate) {
        [self updateCurrentMediaIndexFromScrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.mediaScrollView) {
        [self updateCurrentMediaIndexFromScrollView];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [self.view convertRect:[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    self.keyboardHeight = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(keyboardFrame);
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutDetailViews];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardHeight = 0.0;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutDetailViews];
    } completion:nil];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postComments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.clearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *avatarView = [cell.contentView viewWithTag:1001];
    if (!avatarView) {
        avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        avatarView.tag = 1001;
        avatarView.contentMode = UIViewContentModeScaleAspectFill;
        avatarView.clipsToBounds = YES;
        [cell.contentView addSubview:avatarView];
    }
    
    UILabel *commentLabel = [cell.contentView viewWithTag:1002];
    if (!commentLabel) {
        commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        commentLabel.tag = 1002;
        commentLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        commentLabel.font = [UIFont systemFontOfSize:13.0];
        [cell.contentView addSubview:commentLabel];
    }
    
    CGFloat width = CGRectGetWidth(tableView.bounds);
    CGFloat scale = width / 375.0;
    LuketPostComment *comment = self.postComments[indexPath.row];
    LuketUser *commentUser = [self userWithId:comment.fromUserId];

    avatarView.frame = CGRectMake(20.0 * scale, 4.0, 24.0 * scale, 24.0 * scale);
    avatarView.layer.cornerRadius = 12.0 * scale;
    commentLabel.frame = CGRectMake(57.0 * scale, 6.0, width - 77.0 * scale, 20.0);
    commentLabel.text = comment.content;
    [self setImageView:avatarView identifier:commentUser.avatarUrl placeholderImageName:@"HomeHeroImage"];
    
    return cell;
}

- (UIColor *)darkTextColor {
    return [UIColor colorWithRed:0.08 green:0.2 blue:0.35 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

- (void)dealloc {
    [self stopVideoPlayback];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
