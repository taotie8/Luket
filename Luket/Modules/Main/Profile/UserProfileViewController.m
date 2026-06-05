//
//  UserProfileViewController.m
//  Luket
//

#import "UserProfileViewController.h"
#import "Cell/UserProfilePostCell.h"
#import "../Common/MoreActionSheetView.h"
#import "../Report/ReportViewController.h"

typedef NS_ENUM(NSInteger, UserProfileViewTag) {
    UserProfileViewTagBackground = 1001,
    UserProfileViewTagTopBar = 1002,
    UserProfileViewTagBackButton = 1003,
    UserProfileViewTagTopAvatar = 1004,
    UserProfileViewTagName = 1005,
    UserProfileViewTagAddButton = 1006,
    UserProfileViewTagMoreButton = 1008,
    UserProfileViewTagMainAvatar = 1009,
    UserProfileViewTagFollowTitle = 1010,
    UserProfileViewTagFollowCount = 1011,
    UserProfileViewTagFansTitle = 1012,
    UserProfileViewTagFansCount = 1013,
    UserProfileViewTagDisplayName = 1014,
    UserProfileViewTagBio = 1015,
    UserProfileViewTagPostTitle = 1016,
    UserProfileViewTagPostIcon = 1017
};

@interface UserProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, copy) NSArray<NSString *> *postTexts;
@property (nonatomic, assign) BOOL followed;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postTexts = @[
        @"Every time I\nswim, I feel ...",
        @"Every time I\nswim, I feel ...",
        @"Incredibly\nhappy! The...",
        @"Every time I\nswim, I feel ...",
        @"Every time I\nswim, I feel ...",
        @"Every time I\nswim, I feel ..."
    ];
    self.followed = NO;
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupBackground];
    [self setupProfileViews];
    [self setupCollectionView];
    [self setupCreateButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutProfileViews];
}

- (void)setupBackground {
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    backgroundView.tag = UserProfileViewTagBackground;
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundView.clipsToBounds = YES;
    backgroundView.alpha = 0.55;
    [self.view addSubview:backgroundView];
}

- (void)setupProfileViews {
    UIView *topBarView = [[UIView alloc] init];
    topBarView.tag = UserProfileViewTagTopBar;
    topBarView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topBarView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = UserProfileViewTagBackButton;
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:backButton];
    
    UIImageView *topAvatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    topAvatarView.tag = UserProfileViewTagTopAvatar;
    topAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    topAvatarView.clipsToBounds = YES;
    [topBarView addSubview:topAvatarView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.tag = UserProfileViewTagName;
    nameLabel.text = @"Freya";
    nameLabel.textColor = [self darkTextColor];
    nameLabel.font = [self titleFontWithSize:20.0];
    [topBarView addSubview:nameLabel];
    
    UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followButton.tag = UserProfileViewTagAddButton;
    [followButton addTarget:self action:@selector(followButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:followButton];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.tag = UserProfileViewTagMoreButton;
    [moreButton setImage:[[UIImage imageNamed:@"DetailMoreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:moreButton];
    
    UIImageView *mainAvatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    mainAvatarView.tag = UserProfileViewTagMainAvatar;
    mainAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    mainAvatarView.clipsToBounds = YES;
    [self.view addSubview:mainAvatarView];
    
    UILabel *followTitleLabel = [self statsTitleLabelWithText:@"Follow"];
    followTitleLabel.tag = UserProfileViewTagFollowTitle;
    [self.view addSubview:followTitleLabel];
    
    UILabel *followCountLabel = [self statsCountLabelWithText:@"333"];
    followCountLabel.tag = UserProfileViewTagFollowCount;
    [self.view addSubview:followCountLabel];
    
    UILabel *fansTitleLabel = [self statsTitleLabelWithText:@"Fans"];
    fansTitleLabel.tag = UserProfileViewTagFansTitle;
    [self.view addSubview:fansTitleLabel];
    
    UILabel *fansCountLabel = [self statsCountLabelWithText:@"333"];
    fansCountLabel.tag = UserProfileViewTagFansCount;
    [self.view addSubview:fansCountLabel];
    
    UILabel *displayNameLabel = [[UILabel alloc] init];
    displayNameLabel.tag = UserProfileViewTagDisplayName;
    displayNameLabel.text = @"Sienna";
    displayNameLabel.textColor = [self darkTextColor];
    displayNameLabel.font = [self titleFontWithSize:20.0];
    [self.view addSubview:displayNameLabel];
    
    UILabel *bioLabel = [[UILabel alloc] init];
    bioLabel.tag = UserProfileViewTagBio;
    bioLabel.text = @"My motorcycle, my adventure partner.";
    bioLabel.textColor = [UIColor colorWithRed:128.0 / 255.0 green:154.0 / 255.0 blue:183.0 / 255.0 alpha:1.0];
    bioLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:bioLabel];
    
    UILabel *postTitleLabel = [[UILabel alloc] init];
    postTitleLabel.tag = UserProfileViewTagPostTitle;
    postTitleLabel.text = @"Post";
    postTitleLabel.textColor = [self darkTextColor];
    postTitleLabel.font = [self titleFontWithSize:20.0];
    [self.view addSubview:postTitleLabel];
    
    UIImageView *postIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProfilePostIcon"]];
    postIconView.tag = UserProfileViewTagPostIcon;
    postIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:postIconView];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:UserProfilePostCell.class forCellWithReuseIdentifier:@"UserProfilePostCell"];
    [self.view addSubview:self.collectionView];
}

- (void)setupCreateButton {
    self.createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.createButton setImage:[[UIImage imageNamed:@"ProfileCreateButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.createButton addTarget:self action:@selector(createButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createButton];
}

- (void)layoutProfileViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat scale = width / 375.0;
    CGFloat safeTop = self.view.safeAreaInsets.top;
    
    UIImageView *backgroundView = [self.view viewWithTag:UserProfileViewTagBackground];
    backgroundView.frame = CGRectMake(0.0, 0.0, width, 260.0 * scale);
    
    UIView *topBarView = [self.view viewWithTag:UserProfileViewTagTopBar];
    topBarView.frame = CGRectMake(20.0, safeTop + 5.0, width - 40.0, 56.0);
    topBarView.layer.cornerRadius = 12.0;
    
    UIButton *backButton = [topBarView viewWithTag:UserProfileViewTagBackButton];
    backButton.frame = CGRectMake(16.0, 0.0, 32.0, 56.0);
    
    UIImageView *topAvatarView = [topBarView viewWithTag:UserProfileViewTagTopAvatar];
    topAvatarView.frame = CGRectMake(60.0, 8.0, 40.0, 40.0);
    topAvatarView.layer.cornerRadius = 20.0;
    
    UILabel *nameLabel = [topBarView viewWithTag:UserProfileViewTagName];
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(112.0, 15.0, CGRectGetWidth(nameLabel.bounds), 26.0);
    
    UIButton *followButton = [topBarView viewWithTag:UserProfileViewTagAddButton];
    followButton.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + 10.0, 16.0, 36.0, 24.0);
    
    UIButton *moreButton = [topBarView viewWithTag:UserProfileViewTagMoreButton];
    moreButton.frame = CGRectMake(CGRectGetWidth(topBarView.bounds) - 44.0, 10.0, 36.0, 36.0);
    
    [self updateFollowButtons];
    
    CGFloat avatarY = CGRectGetMaxY(topBarView.frame) + 37.0;
    UIImageView *mainAvatarView = [self.view viewWithTag:UserProfileViewTagMainAvatar];
    mainAvatarView.frame = CGRectMake(20.0, avatarY, 82.0, 82.0);
    mainAvatarView.layer.cornerRadius = 41.0;
    
    UILabel *followTitleLabel = [self.view viewWithTag:UserProfileViewTagFollowTitle];
    followTitleLabel.frame = CGRectMake(width - 167.0, avatarY + 36.0, 72.0, 24.0);
    
    UILabel *followCountLabel = [self.view viewWithTag:UserProfileViewTagFollowCount];
    followCountLabel.frame = CGRectMake(width - 167.0, avatarY + 66.0, 72.0, 22.0);
    
    UILabel *fansTitleLabel = [self.view viewWithTag:UserProfileViewTagFansTitle];
    fansTitleLabel.frame = CGRectMake(width - 78.0, avatarY + 36.0, 72.0, 24.0);
    
    UILabel *fansCountLabel = [self.view viewWithTag:UserProfileViewTagFansCount];
    fansCountLabel.frame = CGRectMake(width - 78.0, avatarY + 66.0, 72.0, 22.0);
    
    UILabel *displayNameLabel = [self.view viewWithTag:UserProfileViewTagDisplayName];
    displayNameLabel.frame = CGRectMake(20.0, avatarY + 100.0, 180.0, 28.0);
    
    UILabel *bioLabel = [self.view viewWithTag:UserProfileViewTagBio];
    bioLabel.frame = CGRectMake(20.0, avatarY + 135.0, width - 40.0, 22.0);
    
    UILabel *postTitleLabel = [self.view viewWithTag:UserProfileViewTagPostTitle];
    postTitleLabel.frame = CGRectMake(20.0, avatarY + 177.0, 70.0, 28.0);
    
    UIImageView *postIconView = [self.view viewWithTag:UserProfileViewTagPostIcon];
    postIconView.frame = CGRectMake(68.0, avatarY + 180.0, 24.0, 24.0);
    
    CGFloat collectionTop = avatarY + 215.0;
    self.collectionView.frame = CGRectMake(0.0, collectionTop, width, height - collectionTop);
    self.collectionView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.view.safeAreaInsets.bottom + 90.0, 0.0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    self.createButton.frame = CGRectMake((width - 150.0) / 2.0, height - self.view.safeAreaInsets.bottom - 57.0, 150.0, 55.0);
}

- (UILabel *)statsTitleLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [self darkTextColor];
    label.font = [self titleFontWithSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)statsCountLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor colorWithRed:91.0 / 255.0 green:118.0 / 255.0 blue:147.0 / 255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:17.0];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postTexts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserProfilePostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserProfilePostCell" forIndexPath:indexPath];
    [cell configureWithText:self.postTexts[indexPath.item] index:indexPath.item];
    return cell;
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

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createButtonTapped {
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

- (void)followButtonTapped {
    self.followed = !self.followed;
    [self updateFollowButtons];
}

- (void)updateFollowButtons {
    UIView *topBarView = [self.view viewWithTag:UserProfileViewTagTopBar];
    UIButton *followButton = [topBarView viewWithTag:UserProfileViewTagAddButton];
    NSString *imageName = self.followed ? @"DetailFollowRemoveButton" : @"DetailFollowAddButton";
    
    [followButton setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)darkTextColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
