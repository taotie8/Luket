//
//  AISwimmingHistoryViewController.m
//  Luket
//

#import "AISwimmingHistoryViewController.h"

static NSString * const AISwimmingHistoryStorageKey = @"AISwimmingHistoryItems";

@interface AISwimmingHistoryCell : UICollectionViewCell

- (void)configureWithDate:(NSString *)date text:(NSString *)text;

@end

@interface AISwimmingHistoryCell ()

@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation AISwimmingHistoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;

        self.cardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AISwimmingHistoryCard"]];
        self.cardImageView.frame = self.contentView.bounds;
        self.cardImageView.contentMode = UIViewContentModeScaleToFill;
        self.cardImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.cardImageView];

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [self titleColor];
        self.dateLabel.font = [self titleFontWithSize:21.0];
        [self.contentView addSubview:self.dateLabel];

        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.contentLabel.textColor = [self titleColor];
        self.contentLabel.font = [UIFont systemFontOfSize:16.0];
        self.contentLabel.numberOfLines = 3;
        [self.contentView addSubview:self.contentLabel];

        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[[UIImage imageNamed:@"AISwimmingHistoryDeleteIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat scale = CGRectGetWidth(self.contentView.bounds) / 340.0;
    self.dateLabel.frame = CGRectMake(76.0 * scale, 43.0 * scale, 188.0 * scale, 28.0 * scale);
    self.deleteButton.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 38.0 * scale, 43.0 * scale, 24.0 * scale, 24.0 * scale);
    self.contentLabel.frame = CGRectMake(25.0 * scale, 82.0 * scale, CGRectGetWidth(self.contentView.bounds) - 50.0 * scale, 62.0 * scale);
}

- (void)configureWithDate:(NSString *)date text:(NSString *)text {
    self.dateLabel.text = date;
    self.contentLabel.text = text;
    self.deleteButton.hidden = date.length == 0 && text.length == 0;
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end

@interface AISwimmingHistoryViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *topCardView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *historyItems;

@end

@implementation AISwimmingHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [self pageBackgroundColor];
    self.historyItems = [self storedHistoryItems];
    [self setupTopCard];
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.historyItems = [self storedHistoryItems];
    [self.collectionView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat topY = self.view.safeAreaInsets.top + 5.0;
    self.topCardView.frame = CGRectMake(20.0, topY, width - 40.0, 56.0);
    self.topCardView.layer.cornerRadius = 11.0;
    self.collectionView.frame = CGRectMake(0.0, CGRectGetMaxY(self.topCardView.frame), width, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.topCardView.frame));
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)setupTopCard {
    self.topCardView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topCardView.backgroundColor = UIColor.whiteColor;
    self.topCardView.layer.masksToBounds = YES;
    [self.view addSubview:self.topCardView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16.0, 0.0, 32.0, 56.0);
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topCardView addSubview:backButton];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.0, 0.0, 230.0, 56.0)];
    titleLabel.text = @"AI Swimming";
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [self.topCardView addSubview:titleLabel];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.collectionView registerClass:AISwimmingHistoryCell.class forCellWithReuseIdentifier:@"AISwimmingHistoryCell"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.historyItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AISwimmingHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AISwimmingHistoryCell" forIndexPath:indexPath];
    NSDictionary<NSString *, NSString *> *item = self.historyItems[indexPath.item];
    [cell configureWithDate:item[@"date"] text:item[@"text"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    CGFloat cardWidth = width - 40.0;
    return CGSizeMake(cardWidth, cardWidth * 183.0 / 340.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 20.0, self.view.safeAreaInsets.bottom + 20.0, 20.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16.0;
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray<NSDictionary<NSString *, NSString *> *> *)storedHistoryItems {
    NSArray *items = [NSUserDefaults.standardUserDefaults arrayForKey:AISwimmingHistoryStorageKey];
    NSMutableArray<NSDictionary<NSString *, NSString *> *> *historyItems = [NSMutableArray array];
    for (id item in items) {
        if (![item isKindOfClass:NSDictionary.class]) {
            continue;
        }
        NSDictionary *dictionary = item;
        NSString *date = [dictionary[@"date"] isKindOfClass:NSString.class] ? dictionary[@"date"] : @"";
        NSString *text = [dictionary[@"text"] isKindOfClass:NSString.class] ? dictionary[@"text"] : @"";
        if (date.length == 0 && text.length == 0) {
            continue;
        }
        [historyItems addObject:@{@"date": date ?: @"", @"text": text ?: @""}];
    }
    return historyItems.copy;
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
