//
//  DiamondRechargeViewController.m
//  Luket
//

#import "DiamondRechargeViewController.h"
#import "Cell/DiamondRechargeCell.h"
#import "../../Common/LuketDiamondStore.h"
#import <StoreKit/StoreKit.h>

@interface DiamondRechargeViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<NSString *> *diamondAmounts;
@property (nonatomic, copy) NSArray<NSString *> *prices;
@property (nonatomic, copy) NSArray<NSString *> *productIds;
@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> *diamondAmountsByProductId;
@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, copy) NSString *pendingProductId;
@property (nonatomic, assign) NSInteger pendingDiamondAmount;
@property (nonatomic, assign) BOOL purchasing;
@property (nonatomic, strong) UIView *loadingOverlayView;
@property (nonatomic, strong) UIView *loadingContainerView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;

@end

@implementation DiamondRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.diamondAmounts = @[@"63700", @"29400", @"17800", @"10800", @"5150", @"2450", @"800", @"400"];
    self.prices = @[@"99.99$", @"49.99$", @"29.99$", @"19.99$", @"9.99$", @"4.99$", @"1.99$", @"0.99$"];
    self.productIds = @[@"kztuqslzaxonwokk",
                        @"vmklsygyngqotnof",
                        @"ioncgjewijrmngfg",
                        @"zzvbopwqpvcfntih",
                        @"uvlzbbyunoaisogv",
                        @"uumgjkxqiwgrzfwz",
                        @"lkbdzuxbhbjlavuq",
                        @"glintxqpisksdpfe"];
    [self buildProductLookup];
    [SKPaymentQueue.defaultQueue addTransactionObserver:self];
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self setupCollectionView];
}

- (void)dealloc {
    [self.productsRequest cancel];
    [SKPaymentQueue.defaultQueue removeTransactionObserver:self];
}

- (void)buildProductLookup {
    NSMutableDictionary<NSString *, NSNumber *> *lookup = [NSMutableDictionary dictionary];
    NSUInteger count = MIN(self.productIds.count, self.diamondAmounts.count);
    for (NSUInteger index = 0; index < count; index++) {
        NSString *productId = self.productIds[index];
        NSInteger amount = self.diamondAmounts[index].integerValue;
        if (productId.length > 0 && amount > 0) {
            lookup[productId] = @(amount);
        }
    }
    self.diamondAmountsByProductId = lookup.copy;
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
    diamondCountLabel.text = [NSString stringWithFormat:@"%ld", (long)LuketDiamondStore.currentDiamonds];
    diamondCountLabel.textColor = [self darkTextColor];
    diamondCountLabel.font = [self titleFontWithSize:24.0];
    [self.view addSubview:diamondCountLabel];

    [self setupLoadingView];
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
    self.collectionView.allowsSelection = YES;
    [self.collectionView registerClass:DiamondRechargeCell.class forCellWithReuseIdentifier:@"DiamondRechargeCell"];
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.loadingOverlayView];
}

- (void)setupLoadingView {
    self.loadingOverlayView = [[UIView alloc] init];
    self.loadingOverlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.18];
    self.loadingOverlayView.hidden = YES;
    self.loadingOverlayView.userInteractionEnabled = YES;
    [self.view addSubview:self.loadingOverlayView];

    self.loadingContainerView = [[UIView alloc] init];
    self.loadingContainerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.58];
    self.loadingContainerView.layer.cornerRadius = 18.0;
    self.loadingContainerView.layer.masksToBounds = YES;
    [self.loadingOverlayView addSubview:self.loadingContainerView];

    self.loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.loadingIndicatorView.color = UIColor.whiteColor;
    self.loadingIndicatorView.hidesWhenStopped = YES;
    [self.loadingContainerView addSubview:self.loadingIndicatorView];
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

    self.loadingOverlayView.frame = self.view.bounds;
    CGFloat loadingSize = 78.0;
    self.loadingContainerView.frame = CGRectMake((width - loadingSize) / 2.0,
                                                 (height - loadingSize) / 2.0,
                                                 loadingSize,
                                                 loadingSize);
    self.loadingIndicatorView.frame = self.loadingContainerView.bounds;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.diamondAmounts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DiamondRechargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiamondRechargeCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.clearColor;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= self.diamondAmounts.count || indexPath.item >= self.prices.count || indexPath.item >= self.productIds.count) {
        return;
    }

    NSString *message = [NSString stringWithFormat:@"Recharge %@ diamonds for %@?", self.diamondAmounts[indexPath.item], self.prices[indexPath.item]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Recharge"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self startPurchaseAtIndex:indexPath.item];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)startPurchaseAtIndex:(NSUInteger)index {
    if (self.purchasing) {
        return;
    }
    if (![SKPaymentQueue canMakePayments]) {
        [self showAlertWithMessage:@"In-app purchases are disabled on this device."];
        return;
    }
    if (index >= self.productIds.count || index >= self.diamondAmounts.count) {
        return;
    }

    NSString *productId = self.productIds[index];
    if (productId.length == 0) {
        return;
    }

    [self.productsRequest cancel];
    self.pendingProductId = productId;
    self.pendingDiamondAmount = self.diamondAmounts[index].integerValue;
    [self setPurchasing:YES];

    NSSet<NSString *> *productIdentifiers = [NSSet setWithObject:productId];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

- (void)setPurchasing:(BOOL)purchasing {
    _purchasing = purchasing;
    self.collectionView.userInteractionEnabled = !purchasing;
    self.collectionView.alpha = purchasing ? 0.72 : 1.0;
    [self updateLoadingVisible:purchasing];
}

- (void)updateLoadingVisible:(BOOL)visible {
    self.loadingOverlayView.hidden = !visible;
    if (visible) {
        [self.view bringSubviewToFront:self.loadingOverlayView];
        [self.loadingIndicatorView startAnimating];
    } else {
        [self.loadingIndicatorView stopAnimating];
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    SKProduct *matchedProduct = nil;
    for (SKProduct *product in response.products) {
        if ([product.productIdentifier isEqualToString:self.pendingProductId]) {
            matchedProduct = product;
            break;
        }
    }

    if (!matchedProduct) {
        NSString *message = [NSString stringWithFormat:@"Purchase product is not available.\nProduct ID: %@", self.pendingProductId ?: @""];
        [self setPurchasing:NO];
        [self showAlertWithMessage:message];
        return;
    }

    SKPayment *payment = [SKPayment paymentWithProduct:matchedProduct];
    [SKPaymentQueue.defaultQueue addPayment:payment];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self setPurchasing:NO];
    [self showAlertWithMessage:error.localizedDescription ?: @"Unable to load purchase product."];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completePurchaseWithTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failPurchaseWithTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [SKPaymentQueue.defaultQueue finishTransaction:transaction];
                [self setPurchasing:NO];
                break;
            case SKPaymentTransactionStateDeferred:
                [self setPurchasing:NO];
                [self showAlertWithMessage:@"Purchase is pending approval."];
                break;
            case SKPaymentTransactionStatePurchasing:
                break;
        }
    }
}

- (void)completePurchaseWithTransaction:(SKPaymentTransaction *)transaction {
    NSString *productId = transaction.payment.productIdentifier;
    NSInteger diamondAmount = [self diamondAmountForProductId:productId];
    if (diamondAmount <= 0 && [productId isEqualToString:self.pendingProductId]) {
        diamondAmount = self.pendingDiamondAmount;
    }

    if (diamondAmount > 0) {
        NSInteger updatedDiamonds = LuketDiamondStore.currentDiamonds + diamondAmount;
        [LuketDiamondStore setCurrentDiamonds:updatedDiamonds];
        [self refreshDiamondCount];
        NSString *message = [NSString stringWithFormat:@"Recharge successful. %@ diamonds added.", @(diamondAmount)];
        [self showAlertWithMessage:message];
    }

    [SKPaymentQueue.defaultQueue finishTransaction:transaction];
    [self clearPendingPurchaseState];
}

- (void)failPurchaseWithTransaction:(SKPaymentTransaction *)transaction {
    NSError *error = transaction.error;
    if (error.code != SKErrorPaymentCancelled) {
        [self showAlertWithMessage:error.localizedDescription ?: @"Purchase failed."];
    }
    [SKPaymentQueue.defaultQueue finishTransaction:transaction];
    [self clearPendingPurchaseState];
}

- (NSInteger)diamondAmountForProductId:(NSString *)productId {
    return self.diamondAmountsByProductId[productId].integerValue;
}

- (void)clearPendingPurchaseState {
    self.pendingProductId = nil;
    self.pendingDiamondAmount = 0;
    [self setPurchasing:NO];
}

- (void)refreshDiamondCount {
    UILabel *diamondCountLabel = [self.view viewWithTag:1006];
    diamondCountLabel.text = [NSString stringWithFormat:@"%ld", (long)LuketDiamondStore.currentDiamonds];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
