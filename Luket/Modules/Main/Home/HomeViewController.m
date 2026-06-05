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

typedef NS_ENUM(NSUInteger, HomeFeedMode) {
    HomeFeedModeTrending,
    HomeFeedModeDiscover
};

@interface HomeFeedCell : UICollectionViewCell

@property (nonatomic, copy) void (^avatarTapHandler)(void);

- (void)configureWithText:(NSString *)text index:(NSUInteger)index;

@end

@interface HomeFeedCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *photoImageView;
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
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat scale = CGRectGetWidth(self.contentView.bounds) / 162.0;
    self.containerView.bounds = CGRectMake(0.0, 0.0, 162.0, 187.0);
    self.containerView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));
    self.containerView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)configureWithText:(NSString *)text index:(NSUInteger)index {
    self.textLabel.text = text;
    self.photoImageView.transform = CGAffineTransformMakeScale(index % 2 == 0 ? 1.0 : -1.0, 1.0);
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
@property (nonatomic, copy) NSArray<NSString *> *feedTexts;
@property (nonatomic, assign) HomeFeedMode feedMode;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.feedMode = HomeFeedModeTrending;
    self.view.backgroundColor = [self mainBackgroundColor];
    [self configureCollectionView];
    [self configureHomeContent];
    [self updateTitleState];
    [self updateFeedTexts];
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

- (void)titleButtonTapped:(UIButton *)sender {
    self.feedMode = sender.tag == HomeFeedModeDiscover ? HomeFeedModeDiscover : HomeFeedModeTrending;
    [self updateTitleState];
    [self updateFeedTexts];
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

- (void)updateFeedTexts {
    NSArray<NSString *> *trendingTexts = @[
        @"Every time I\nswim, I feel ...",
        @"Every time I\nswim, I feel ...",
        @"Incredibly\nhappy! The...",
        @"Every time I\nswim, I feel ...",
        @"Every time I\nswim, I feel ...",
        @"Every time I\nswim, I feel ..."
    ];
    NSArray<NSString *> *discoverTexts = @[
        @"Fresh water\nmoments ...",
        @"New lane,\nnew rhythm ...",
        @"Pool light\nfeels calm ...",
        @"Blue summer\nstories ...",
        @"Today I found\nmy pace ...",
        @"One more lap\nwith joy ..."
    ];

    self.feedTexts = self.feedMode == HomeFeedModeTrending ? trendingTexts : discoverTexts;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.feedTexts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeFeedCell" forIndexPath:indexPath];
    [cell configureWithText:self.feedTexts[indexPath.item] index:indexPath.item];
    
    __weak typeof(self) weakSelf = self;
    cell.avatarTapHandler = ^{
        [weakSelf presentUserProfileViewController];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:detailViewController animated:YES completion:nil];
}

- (void)presentUserProfileViewController {
    UserProfileViewController *viewController = [[UserProfileViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
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

@end
