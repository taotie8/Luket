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
#import "../Data/Network/LuketAPIClient.h"

typedef NS_ENUM(NSUInteger, HomeFeedMode) {
    HomeFeedModeTrending,
    HomeFeedModeDiscover
};

@interface HomeFeedCell : UICollectionViewCell

@property (nonatomic, copy) void (^avatarTapHandler)(void);

- (void)configureWithPost:(LuketPost *)post index:(NSUInteger)index;

@end

@interface HomeFeedCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIImageView *playIconImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, copy) NSString *representedImageIdentifier;

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
    self.representedImageIdentifier = nil;
    self.photoImageView.image = [UIImage imageNamed:@"HomeHeroImage"];
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
}

- (void)setCoverImageWithIdentifier:(NSString *)identifier {
    NSString *trimmedIdentifier = [identifier stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    self.representedImageIdentifier = trimmedIdentifier ?: @"";

    UIImage *localImage = [self localImageWithIdentifier:trimmedIdentifier];
    if (localImage) {
        self.photoImageView.image = localImage;
        return;
    }

    self.photoImageView.image = [UIImage imageNamed:@"HomeHeroImage"];

    NSString *expectedIdentifier = self.representedImageIdentifier.copy;
    NSURL *imageURL = [self directImageURLWithIdentifier:trimmedIdentifier];
    if (!imageURL) {
        [self loadMediaFileWithIdentifier:trimmedIdentifier expectedIdentifier:expectedIdentifier];
        return;
    }

    NSLog(@"[Luket] Home media image URL: %@", imageURL.absoluteString);
    [self loadImageWithURL:imageURL expectedIdentifier:expectedIdentifier];
}

- (void)loadImageWithURL:(NSURL *)imageURL expectedIdentifier:(NSString *)expectedIdentifier {
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        (void)response;
        if (error || data.length == 0) {
            return;
        }

        UIImage *remoteImage = [UIImage imageWithData:data];
        if (!remoteImage) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf || ![strongSelf.representedImageIdentifier isEqualToString:expectedIdentifier]) {
                return;
            }
            strongSelf.photoImageView.image = remoteImage;
        });
    }];
    [task resume];
}

- (void)loadMediaFileWithIdentifier:(NSString *)identifier expectedIdentifier:(NSString *)expectedIdentifier {
    if (identifier.length == 0) {
        return;
    }

    [[LuketAPIClient sharedClient] getPath:@"api/file/download" parameters:@{@"fileName": identifier} completion:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"[Luket] Home media file load failed: %@", error.localizedDescription);
            return;
        }

        NSString *mediaString = [self mediaStringFromDownloadResponse:responseObject];
        UIImage *image = [self imageFromMediaString:mediaString];
        if (image) {
            if (![self.representedImageIdentifier isEqualToString:expectedIdentifier]) {
                return;
            }
            self.photoImageView.image = image;
            return;
        }

        NSURL *imageURL = [self directImageURLWithIdentifier:mediaString];
        if (imageURL) {
            NSLog(@"[Luket] Home media image URL: %@", imageURL.absoluteString);
            [self loadImageWithURL:imageURL expectedIdentifier:expectedIdentifier];
            return;
        }

        if ([responseObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            NSLog(@"[Luket] Home media file response: %@", dictionary[@"msg"] ?: dictionary);
        }
    }];
}

- (NSString *)mediaStringFromDownloadResponse:(id)responseObject {
    if ([responseObject isKindOfClass:NSString.class]) {
        return responseObject;
    }

    if (![responseObject isKindOfClass:NSDictionary.class]) {
        return @"";
    }

    NSDictionary *dictionary = (NSDictionary *)responseObject;
    id data = dictionary[@"data"];
    if ([data isKindOfClass:NSString.class]) {
        return data;
    }

    if (![data isKindOfClass:NSDictionary.class]) {
        return @"";
    }

    NSDictionary *dataDictionary = (NSDictionary *)data;
    NSArray<NSString *> *keys = @[@"url", @"fileUrl", @"downloadUrl", @"path", @"filePath"];
    for (NSString *key in keys) {
        id value = dataDictionary[key];
        if ([value isKindOfClass:NSString.class] && [value length] > 0) {
            return value;
        }
    }
    return @"";
}

- (UIImage *)imageFromMediaString:(NSString *)mediaString {
    if (mediaString.length == 0 || [mediaString hasPrefix:@"http://"] || [mediaString hasPrefix:@"https://"]) {
        return nil;
    }

    NSString *base64String = mediaString;
    NSRange commaRange = [base64String rangeOfString:@","];
    if ([base64String hasPrefix:@"data:image"] && commaRange.location != NSNotFound) {
        base64String = [base64String substringFromIndex:commaRange.location + 1];
    }

    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return imageData.length > 0 ? [UIImage imageWithData:imageData] : nil;
}

- (UIImage *)localImageWithIdentifier:(NSString *)identifier {
    if (identifier.length == 0) {
        return nil;
    }

    UIImage *image = [UIImage imageNamed:identifier];
    if (image) {
        return image;
    }

    NSString *imageNameWithoutExtension = identifier.stringByDeletingPathExtension;
    if (imageNameWithoutExtension.length > 0 && ![imageNameWithoutExtension isEqualToString:identifier]) {
        image = [UIImage imageNamed:imageNameWithoutExtension];
        if (image) {
            return image;
        }
    }

    NSString *bundlePath = [NSBundle.mainBundle pathForResource:identifier ofType:nil];
    if (!bundlePath && identifier.lastPathComponent.length > 0) {
        bundlePath = [NSBundle.mainBundle pathForResource:identifier.lastPathComponent ofType:nil];
    }
    return bundlePath.length > 0 ? [UIImage imageWithContentsOfFile:bundlePath] : nil;
}

- (NSURL *)directImageURLWithIdentifier:(NSString *)identifier {
    if (identifier.length == 0) {
        return nil;
    }

    if ([identifier hasPrefix:@"http://"] || [identifier hasPrefix:@"https://"]) {
        return [NSURL URLWithString:identifier];
    }

    NSString *baseURLString = LuketAPIClient.sharedClient.baseURLString.length > 0 ? LuketAPIClient.sharedClient.baseURLString : @"https://dev.chavytogo.com/";
    if (![baseURLString hasSuffix:@"/"]) {
        baseURLString = [baseURLString stringByAppendingString:@"/"];
    }

    if ([identifier hasPrefix:@"/"]) {
        NSURL *baseURL = [NSURL URLWithString:baseURLString];
        return [NSURL URLWithString:[identifier substringFromIndex:1] relativeToURL:baseURL].absoluteURL;
    }

    return nil;
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
@property (nonatomic, copy) NSArray<LuketPost *> *posts;
@property (nonatomic, copy) NSArray<LuketPost *> *visiblePosts;
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
    [self loadPosts];
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

    __weak typeof(self) weakSelf = self;
    [[LuketDataService sharedService] fetchGlobalDataWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        if (error) {
            NSLog(@"[Luket] Home postList load failed: %@", error.localizedDescription);
            return;
        }

        strongSelf.posts = data.postList ?: @[];
        NSLog(@"[Luket] Home postList count: %lu", (unsigned long)strongSelf.posts.count);
        [strongSelf updateVisiblePosts];
    }];
}

- (void)updateVisiblePosts {
    self.visiblePosts = self.posts ?: @[];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.visiblePosts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeFeedCell" forIndexPath:indexPath];
    [cell configureWithPost:self.visiblePosts[indexPath.item] index:indexPath.item];
    
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
