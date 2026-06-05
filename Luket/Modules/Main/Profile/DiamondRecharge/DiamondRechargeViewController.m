//
//  DiamondRechargeViewController.m
//  Luket
//

#import "DiamondRechargeViewController.h"
#import "Cell/DiamondRechargeCell.h"

@interface DiamondRechargeViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<NSString *> *diamondAmounts;
@property (nonatomic, copy) NSArray<NSString *> *prices;

@end

@implementation DiamondRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.diamondAmounts = @[@"400", @"800", @"2190", @"2450", @"3950", @"4900", @"5700", @"9800", @"24500", @"49000"];
    self.prices = @[@"0.99$", @"1.99$", @"3.99$", @"4.99$", @"8.99$", @"9.99$", @"13.99$", @"19.99$", @"49.99$", @"99.99$"];
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self setupCollectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutRechargeViews];
}

- (void)setupViews {
    UIImageView *headerWaveView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiamondRechargeHeaderWave"]];
    headerWaveView.tag = 1001;
    headerWaveView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:headerWaveView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = 1002;
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 1003;
    titleLabel.text = @"My diamonds";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [self darkTextColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [self.view addSubview:titleLabel];
    
    UIImageView *largeDiamondView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiamondRechargeLargeIcon"]];
    largeDiamondView.tag = 1004;
    largeDiamondView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:largeDiamondView];
    
    UILabel *diamondTitleLabel = [[UILabel alloc] init];
    diamondTitleLabel.tag = 1005;
    diamondTitleLabel.text = @"My diamonds";
    diamondTitleLabel.textColor = [self darkTextColor];
    diamondTitleLabel.font = [self titleFontWithSize:17.0];
    [self.view addSubview:diamondTitleLabel];
    
    UILabel *diamondCountLabel = [[UILabel alloc] init];
    diamondCountLabel.tag = 1006;
    diamondCountLabel.text = @"300";
    diamondCountLabel.textColor = [self darkTextColor];
    diamondCountLabel.font = [self titleFontWithSize:24.0];
    [self.view addSubview:diamondCountLabel];
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
    [self.collectionView registerClass:DiamondRechargeCell.class forCellWithReuseIdentifier:@"DiamondRechargeCell"];
    [self.view addSubview:self.collectionView];
}

- (void)layoutRechargeViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    UIImageView *headerWaveView = [self.view viewWithTag:1001];
    headerWaveView.frame = CGRectMake(0.0, 0.0, width, 244.0);
    
    UIButton *backButton = [self.view viewWithTag:1002];
    backButton.frame = CGRectMake(28.0, 70.0, 44.0, 44.0);
    
    UILabel *titleLabel = [self.view viewWithTag:1003];
    titleLabel.frame = CGRectMake(80.0, 74.0, width - 160.0, 30.0);
    
    UIImageView *largeDiamondView = [self.view viewWithTag:1004];
    largeDiamondView.frame = CGRectMake(70.0, 126.0, 104.0, 99.0);
    
    UILabel *diamondTitleLabel = [self.view viewWithTag:1005];
    diamondTitleLabel.frame = CGRectMake(188.0, 146.0, 150.0, 24.0);
    
    UILabel *diamondCountLabel = [self.view viewWithTag:1006];
    diamondCountLabel.frame = CGRectMake(188.0, CGRectGetMaxY(diamondTitleLabel.frame) + 10.0, 90.0, 32.0);
    
    CGFloat collectionTop = 244.0;
    self.collectionView.frame = CGRectMake(0.0, collectionTop, width, height - collectionTop);
    self.collectionView.contentInset = UIEdgeInsetsMake(9.0, 0.0, self.view.safeAreaInsets.bottom + 16.0, 0.0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.diamondAmounts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DiamondRechargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiamondRechargeCell" forIndexPath:indexPath];
    [cell configureWithAmount:self.diamondAmounts[indexPath.item] price:self.prices[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(147.0, 98.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    CGFloat left = (width - 147.0 * 2.0 - 29.0) / 2.0;
    return UIEdgeInsetsMake(0.0, MAX(left, 20.0), 0.0, MAX(left, 20.0));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 29.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0;
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
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
