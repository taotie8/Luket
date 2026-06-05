//
//  MyProfileViewController.m
//  Luket
//

#import "MyProfileViewController.h"
#import "Cell/UserProfilePostCell.h"
#import "DiamondRecharge/DiamondRechargeViewController.h"
#import "Edit/EditProfileViewController.h"
#import "UserList/ProfileUserListViewController.h"
#import "../Settings/SettingViewController.h"

typedef NS_ENUM(NSInteger, MyProfileViewTag) {
    MyProfileViewTagHeaderBackground = 1001,
    MyProfileViewTagSettingsButton = 1002,
    MyProfileViewTagAvatar = 1003,
    MyProfileViewTagFollowTitle = 1004,
    MyProfileViewTagFollowCount = 1005,
    MyProfileViewTagFansTitle = 1006,
    MyProfileViewTagFansCount = 1007,
    MyProfileViewTagName = 1008,
    MyProfileViewTagBio = 1009,
    MyProfileViewTagDiamondCard = 1010,
    MyProfileViewTagPostTitle = 1011,
    MyProfileViewTagEditAvatarButton = 1012,
    MyProfileViewTagDiamondTitle = 1013,
    MyProfileViewTagDiamondCount = 1014,
    MyProfileViewTagFollowButton = 1015,
    MyProfileViewTagFansButton = 1016,
    MyProfileViewTagDiamondButton = 1017
};

@interface MyProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<NSString *> *postTexts;

@end

@implementation MyProfileViewController

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
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self setupCollectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutProfileViews];
}

- (void)setupViews {
    UIImageView *headerBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyProfileHeaderBackground"]];
    headerBackgroundView.tag = MyProfileViewTagHeaderBackground;
    headerBackgroundView.contentMode = UIViewContentModeScaleToFill;
    headerBackgroundView.clipsToBounds = YES;
    [self.view insertSubview:headerBackgroundView atIndex:0];
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.tag = MyProfileViewTagSettingsButton;
    [settingsButton setImage:[[UIImage imageNamed:@"MyProfileSettingsButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(settingsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingsButton];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    avatarView.tag = MyProfileViewTagAvatar;
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    avatarView.clipsToBounds = YES;
    [self.view addSubview:avatarView];
    
    UIButton *editAvatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editAvatarButton.tag = MyProfileViewTagEditAvatarButton;
    [editAvatarButton setImage:[[UIImage imageNamed:@"MyProfileEditAvatarButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [editAvatarButton addTarget:self action:@selector(editAvatarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editAvatarButton];
    
    UILabel *followTitleLabel = [self statsTitleLabelWithText:@"Follow"];
    followTitleLabel.tag = MyProfileViewTagFollowTitle;
    [self.view addSubview:followTitleLabel];
    
    UILabel *followCountLabel = [self statsCountLabelWithText:@"333"];
    followCountLabel.tag = MyProfileViewTagFollowCount;
    [self.view addSubview:followCountLabel];
    
    UILabel *fansTitleLabel = [self statsTitleLabelWithText:@"Fans"];
    fansTitleLabel.tag = MyProfileViewTagFansTitle;
    [self.view addSubview:fansTitleLabel];
    
    UILabel *fansCountLabel = [self statsCountLabelWithText:@"333"];
    fansCountLabel.tag = MyProfileViewTagFansCount;
    [self.view addSubview:fansCountLabel];
    
    UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    followButton.tag = MyProfileViewTagFollowButton;
    [followButton addTarget:self action:@selector(followButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:followButton];
    
    UIButton *fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fansButton.tag = MyProfileViewTagFansButton;
    [fansButton addTarget:self action:@selector(fansButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fansButton];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.tag = MyProfileViewTagName;
    nameLabel.text = @"Sienna";
    nameLabel.textColor = [self darkTextColor];
    nameLabel.font = [self titleFontWithSize:20.0];
    [self.view addSubview:nameLabel];
    
    UILabel *bioLabel = [[UILabel alloc] init];
    bioLabel.tag = MyProfileViewTagBio;
    bioLabel.text = @"My motorcycle, my adventure partner.";
    bioLabel.textColor = [UIColor colorWithRed:128.0 / 255.0 green:154.0 / 255.0 blue:183.0 / 255.0 alpha:1.0];
    bioLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:bioLabel];
    
    UIImageView *diamondCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyProfileDiamondCard"]];
    diamondCardView.tag = MyProfileViewTagDiamondCard;
    diamondCardView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:diamondCardView];
    
    UILabel *diamondTitleLabel = [[UILabel alloc] init];
    diamondTitleLabel.tag = MyProfileViewTagDiamondTitle;
    diamondTitleLabel.text = @"My  diamonds";
    diamondTitleLabel.textColor = UIColor.whiteColor;
    diamondTitleLabel.font = [self titleFontWithSize:18.0];
    [self.view addSubview:diamondTitleLabel];
    
    UILabel *diamondCountLabel = [[UILabel alloc] init];
    diamondCountLabel.tag = MyProfileViewTagDiamondCount;
    diamondCountLabel.text = @"300";
    diamondCountLabel.textColor = UIColor.whiteColor;
    diamondCountLabel.font = [self titleFontWithSize:24.0];
    [self.view addSubview:diamondCountLabel];
    
    UIButton *diamondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    diamondButton.tag = MyProfileViewTagDiamondButton;
    [diamondButton addTarget:self action:@selector(diamondButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:diamondButton];
    
    UIImageView *postTitleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyProfilePostTitle"]];
    postTitleView.tag = MyProfileViewTagPostTitle;
    postTitleView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:postTitleView];
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

- (void)layoutProfileViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
//    CGFloat scale = width / 375.0;
    CGFloat safeTop = self.view.safeAreaInsets.top;
    
    UIImageView *headerBackgroundView = [self.view viewWithTag:MyProfileViewTagHeaderBackground];
    headerBackgroundView.frame = CGRectMake(0.0, 0.0, width, 238.0);
    
    UIButton *settingsButton = [self.view viewWithTag:MyProfileViewTagSettingsButton];
    settingsButton.frame = CGRectMake(width - 65.0, safeTop + 20.0, 32.0, 32.0);
    
    CGFloat avatarY = safeTop + 83.0;
    UIImageView *avatarView = [self.view viewWithTag:MyProfileViewTagAvatar];
    avatarView.frame = CGRectMake(20.0, avatarY, 82.0, 82.0);
    avatarView.layer.cornerRadius = 41.0;
    
    UIButton *editAvatarButton = [self.view viewWithTag:MyProfileViewTagEditAvatarButton];
    editAvatarButton.frame = CGRectMake(CGRectGetMaxX(avatarView.frame) - 28.0,
                                        CGRectGetMaxY(avatarView.frame) - 28.0,
                                        28.0,
                                        28.0);
    
    UILabel *followTitleLabel = [self.view viewWithTag:MyProfileViewTagFollowTitle];
    followTitleLabel.frame = CGRectMake(width - 167.0, avatarY + 36.0, 72.0, 24.0);
    
    UILabel *followCountLabel = [self.view viewWithTag:MyProfileViewTagFollowCount];
    followCountLabel.frame = CGRectMake(width - 167.0, avatarY + 66.0, 72.0, 22.0);
    
    UIButton *followButton = [self.view viewWithTag:MyProfileViewTagFollowButton];
    followButton.frame = CGRectMake(width - 167.0, avatarY + 30.0, 72.0, 62.0);
    
    UILabel *fansTitleLabel = [self.view viewWithTag:MyProfileViewTagFansTitle];
    fansTitleLabel.frame = CGRectMake(width - 78.0, avatarY + 36.0, 72.0, 24.0);
    
    UILabel *fansCountLabel = [self.view viewWithTag:MyProfileViewTagFansCount];
    fansCountLabel.frame = CGRectMake(width - 78.0, avatarY + 66.0, 72.0, 22.0);
    
    UIButton *fansButton = [self.view viewWithTag:MyProfileViewTagFansButton];
    fansButton.frame = CGRectMake(width - 78.0, avatarY + 30.0, 72.0, 62.0);
    
    UILabel *nameLabel = [self.view viewWithTag:MyProfileViewTagName];
    nameLabel.frame = CGRectMake(20.0, CGRectGetMaxY(avatarView.frame) + 16.0, 180.0, 28.0);
    
    UILabel *bioLabel = [self.view viewWithTag:MyProfileViewTagBio];
    bioLabel.frame = CGRectMake(20.0, CGRectGetMaxY(nameLabel.frame) + 8.0, width - 40.0, 22.0);
    
    UIImageView *diamondCardView = [self.view viewWithTag:MyProfileViewTagDiamondCard];
    CGFloat diamondWidth = width - 36.0;
    CGFloat diamondHeight = diamondWidth * 104.0 / 340.0;
    diamondCardView.frame = CGRectMake(18.0, CGRectGetMaxY(bioLabel.frame) + 15.0, diamondWidth, diamondHeight);
    
    CGFloat diamondScale = diamondWidth / 340.0;
    UILabel *diamondTitleLabel = [self.view viewWithTag:MyProfileViewTagDiamondTitle];
    diamondTitleLabel.frame = CGRectMake(CGRectGetMinX(diamondCardView.frame) + 173.0 * diamondScale,
                                         CGRectGetMinY(diamondCardView.frame) + 26.0 * diamondScale,
                                         135.0 * diamondScale,
                                         24.0 * diamondScale);
    
    UILabel *diamondCountLabel = [self.view viewWithTag:MyProfileViewTagDiamondCount];
    diamondCountLabel.frame = CGRectMake(CGRectGetMinX(diamondCardView.frame) + 173.0 * diamondScale,
                                         CGRectGetMaxY(diamondTitleLabel.frame) + 8.0 * diamondScale,
                                         90.0 * diamondScale,
                                         30.0 * diamondScale);
    
    UIButton *diamondButton = [self.view viewWithTag:MyProfileViewTagDiamondButton];
    diamondButton.frame = diamondCardView.frame;
    
    UIImageView *postTitleView = [self.view viewWithTag:MyProfileViewTagPostTitle];
    postTitleView.frame = CGRectMake(20.0, CGRectGetMaxY(diamondCardView.frame) + 26.0, 69.0, 24.0);
    
    CGFloat collectionTop = CGRectGetMaxY(postTitleView.frame) + 26.0;
    self.collectionView.frame = CGRectMake(0.0, collectionTop, width, height - collectionTop);
    self.collectionView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.view.safeAreaInsets.bottom + 90.0, 0.0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView.collectionViewLayout invalidateLayout];
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

- (void)settingsButtonTapped {
    SettingViewController *viewController = [[SettingViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)editAvatarButtonTapped {
    EditProfileViewController *viewController = [[EditProfileViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)followButtonTapped {
    [self presentUserListWithMode:ProfileUserListModeFollow];
}

- (void)fansButtonTapped {
    [self presentUserListWithMode:ProfileUserListModeFans];
}

- (void)diamondButtonTapped {
    DiamondRechargeViewController *viewController = [[DiamondRechargeViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)presentUserListWithMode:(ProfileUserListMode)mode {
    ProfileUserListViewController *viewController = [[ProfileUserListViewController alloc] initWithMode:mode];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
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
