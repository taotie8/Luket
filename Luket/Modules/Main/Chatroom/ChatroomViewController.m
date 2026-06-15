//
//  ChatroomViewController.m
//  Luket
//

#import "ChatroomViewController.h"
#import "ChatroomCreateViewController.h"
#import "ChatroomDetailViewController.h"
#import "../Common/LuketMediaResource.h"
#import "../Data/Service/LuketDataService.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef NS_ENUM(NSUInteger, ChatroomSegment) {
    ChatroomSegmentForYou,
    ChatroomSegmentTrending,
    ChatroomSegmentFollowing
};

static CGFloat const ChatroomRoomCellHeight = 133.0;
static CGFloat const ChatroomRoomCardHeight = 117.0;
static CGFloat const ChatroomRoomAvatarSize = 117.0;
static NSString * const ChatroomListFavoriteGroupKeyPrefix = @"ChatroomFavoriteGroup";
static NSString * const ChatroomListBlockedGroupKeyPrefix = @"ChatroomBlockedGroup";

@interface ChatroomRoomView : UIView

- (void)configureWithGroup:(LuketGroupChat *)group users:(NSArray<LuketUser *> *)users index:(NSInteger)index;

@end

@interface ChatroomRoomView ()

@property (nonatomic, strong) CAShapeLayer *cardLayer;
@property (nonatomic, strong) UIImageView *photoImageView;

@end

@implementation ChatroomRoomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;

        self.cardLayer = [CAShapeLayer layer];
        self.cardLayer.fillColor = [UIColor colorWithWhite:1.0 alpha:0.86].CGColor;
        self.cardLayer.strokeColor = UIColor.whiteColor.CGColor;
        self.cardLayer.lineWidth = 2.0;
        [self.layer addSublayer:self.cardLayer];

        UIImageView *backgroundPhotoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        backgroundPhotoView.tag = 1001;
        backgroundPhotoView.contentMode = UIViewContentModeScaleAspectFill;
        backgroundPhotoView.clipsToBounds = YES;
        backgroundPhotoView.alpha = 0.14;
        [self addSubview:backgroundPhotoView];

        self.photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.clipsToBounds = YES;
        [self addSubview:self.photoImageView];

        UIView *fadeView = [[UIView alloc] init];
        fadeView.tag = 1002;
        fadeView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.72];
        [self addSubview:fadeView];

        UILabel *titleLabel = [self labelWithText:@"MotoChat" fontSize:20.0 weight:UIFontWeightBold];
        titleLabel.tag = 1003;
        [self addSubview:titleLabel];

        UILabel *subtitleLabel = [self labelWithText:@"A cozy chat room fo..." fontSize:14.0 weight:UIFontWeightRegular];
        subtitleLabel.tag = 1004;
        [self addSubview:subtitleLabel];

        UIImageView *fireView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomFireIcon"]];
        fireView.tag = 1005;
        fireView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:fireView];

        UILabel *heatLabel = [self labelWithText:@"3.3w" fontSize:13.0 weight:UIFontWeightBold];
        heatLabel.tag = 1006;
        heatLabel.textColor = [UIColor colorWithRed:1.0 green:105.0 / 255.0 blue:103.0 / 255.0 alpha:1.0];
        [self addSubview:heatLabel];

        for (NSInteger index = 0; index < 3; index++) {
            UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
            avatarView.tag = 1010 + index;
            avatarView.contentMode = UIViewContentModeScaleAspectFill;
            avatarView.clipsToBounds = YES;
            [self addSubview:avatarView];
        }

        UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomPlusBubble"]];
        bubbleView.tag = 1020;
        bubbleView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:bubbleView];

        UILabel *memberCountLabel = [self labelWithText:@"0" fontSize:12.0 weight:UIFontWeightBold];
        memberCountLabel.tag = 1021;
        memberCountLabel.textAlignment = NSTextAlignmentCenter;
        memberCountLabel.textColor = UIColor.whiteColor;
        memberCountLabel.adjustsFontSizeToFitWidth = YES;
        memberCountLabel.minimumScaleFactor = 0.7;
        [self addSubview:memberCountLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat scale = 1.0;

    self.cardLayer.frame = self.bounds;
    self.cardLayer.path = [self cardPathWithWidth:width height:height scale:scale].CGPath;

    UIImageView *backgroundPhotoView = [self viewWithTag:1001];
    backgroundPhotoView.frame = CGRectMake(119.0 * scale, 5.0 * scale, width - 134.0 * scale, height - 10.0 * scale);
    backgroundPhotoView.layer.cornerRadius = 10.0 * scale;

    self.photoImageView.frame = CGRectMake(8.0 * scale, 0.0, ChatroomRoomAvatarSize, ChatroomRoomAvatarSize);
    self.photoImageView.layer.cornerRadius = 12.0 * scale;

    UIView *fadeView = [self viewWithTag:1002];
    fadeView.frame = CGRectMake(120.0 * scale, 6.0 * scale, width - 135.0 * scale, height - 12.0 * scale);

    UILabel *titleLabel = [self viewWithTag:1003];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) + 8.0, 16.0, 128.0 * scale, 27.0);

    UILabel *subtitleLabel = [self viewWithTag:1004];
    subtitleLabel.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) + 8.0, CGRectGetMaxY(titleLabel.frame) + 12.0, 150.0 * scale, 17.0);

    UIImageView *fireView = [self viewWithTag:1005];
    fireView.frame = CGRectMake(256.0 * scale, CGRectGetMidY(titleLabel.frame) - 16.0 * scale, 32.0 * scale, 32.0 * scale);

    UILabel *heatLabel = [self viewWithTag:1006];
    heatLabel.frame = CGRectMake(CGRectGetMaxX(fireView.frame) + 4.0 * scale, CGRectGetMidY(fireView.frame) - 9.0 * scale, 42.0 * scale, 18.0 * scale);

    for (NSInteger index = 0; index < 3; index++) {
        UIImageView *avatarView = [self viewWithTag:1010 + index];
        avatarView.frame = CGRectMake(CGRectGetMaxX(self.photoImageView.frame) + 8.0 + 32.0 * index, CGRectGetMaxY(subtitleLabel.frame) + 12.0, 24.0, 24.0);
        avatarView.layer.cornerRadius = 12.0;
        avatarView.transform = CGAffineTransformMakeScale(index % 2 == 0 ? 1.0 : -1.0, 1.0);
    }

    UIImageView *bubbleView = [self viewWithTag:1020];
    UIImageView *lastAvatarView = [self viewWithTag:1012];
    bubbleView.frame = CGRectMake(CGRectGetMaxX(lastAvatarView.frame) + 8.0, CGRectGetMidY(lastAvatarView.frame) - 17.0 * scale, 51.0 * scale, 34.0 * scale);

    UILabel *memberCountLabel = [self viewWithTag:1021];
    memberCountLabel.frame = CGRectInset(bubbleView.frame, 8.0 * scale, 6.0 * scale);
}

- (void)configureWithGroup:(LuketGroupChat *)group users:(NSArray<LuketUser *> *)users index:(NSInteger)index {
    UILabel *titleLabel = [self viewWithTag:1003];
    titleLabel.text = group.title.length > 0 ? group.title : @"MotoChat";

    UILabel *subtitleLabel = [self viewWithTag:1004];
    subtitleLabel.text = group.groupDescription.length > 0 ? group.groupDescription : @"";

    UILabel *heatLabel = [self viewWithTag:1006];
    heatLabel.text = [self heatTextForCount:group.likeCount];

    UILabel *memberCountLabel = [self viewWithTag:1021];
    memberCountLabel.text = [self memberCountTextForCount:group.memberIds.count];

    NSString *coverIdentifier = [self coverIdentifierForGroup:group users:users];
    [self setImageView:self.photoImageView identifier:coverIdentifier];

    UIImageView *backgroundPhotoView = [self viewWithTag:1001];
    [self setImageView:backgroundPhotoView identifier:coverIdentifier];

    [self configureMemberAvatarsWithGroup:group users:users];

    CGFloat shift = (index % 4) * 0.16;
    self.photoImageView.transform = CGAffineTransformMakeTranslation(-80.0 * shift, 0.0);
}

- (NSString *)coverIdentifierForGroup:(LuketGroupChat *)group users:(NSArray<LuketUser *> *)users {
    if (group.coverUrl.length > 0) {
        return group.coverUrl;
    }

    NSString *firstMemberId = group.memberIds.firstObject;
    LuketUser *firstMember = [self userWithId:firstMemberId users:users];
    return firstMember.avatarUrl ?: @"";
}

- (void)configureMemberAvatarsWithGroup:(LuketGroupChat *)group users:(NSArray<LuketUser *> *)users {
    for (NSInteger index = 0; index < 3; index++) {
        UIImageView *avatarView = [self viewWithTag:1010 + index];
        if (index >= group.memberIds.count) {
            avatarView.hidden = YES;
            continue;
        }

        avatarView.hidden = NO;
        NSString *memberId = group.memberIds[index];
        LuketUser *user = [self userWithId:memberId users:users];
        [self setImageView:avatarView identifier:user.avatarUrl];
    }
}

- (LuketUser *)userWithId:(NSString *)userId users:(NSArray<LuketUser *> *)users {
    for (LuketUser *user in users) {
        if ([user.userId isEqualToString:userId]) {
            return user;
        }
    }

    return nil;
}

- (void)setImageView:(UIImageView *)imageView identifier:(NSString *)identifier {
    UIImage *placeholderImage = [UIImage imageNamed:@"HomeHeroImage"];
    UIImage *localImage = [UIImage imageNamed:identifier];
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

    [imageView sd_setImageWithURL:imageURL placeholderImage:placeholderImage];
}

- (NSString *)heatTextForCount:(NSInteger)count {
    if (count >= 10000) {
        CGFloat wanCount = count / 10000.0;
        return [NSString stringWithFormat:@"%.1fw", wanCount];
    }

    return [NSString stringWithFormat:@"%ld", (long)MAX(count, 0)];
}

- (NSString *)memberCountTextForCount:(NSInteger)count {
    if (count > 99) {
        return @"99+";
    }

    return [NSString stringWithFormat:@"%ld", (long)MAX(count, 0)];
}

- (UIBezierPath *)cardPathWithWidth:(CGFloat)width height:(CGFloat)height scale:(CGFloat)scale {
    CGFloat inset = 3.0 * scale;
    CGFloat leftTop = 20.0 * scale;
    CGFloat side = 13.0 * scale;
    CGFloat radius = 18.0 * scale;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftTop, inset)];
    [path addLineToPoint:CGPointMake(width - leftTop - side, inset)];
    [path addQuadCurveToPoint:CGPointMake(width - side, radius) controlPoint:CGPointMake(width - side, inset)];
    [path addLineToPoint:CGPointMake(width - inset, height / 2.0)];
    [path addLineToPoint:CGPointMake(width - side, height - radius)];
    [path addQuadCurveToPoint:CGPointMake(width - leftTop - side, height - inset) controlPoint:CGPointMake(width - side, height - inset)];
    [path addLineToPoint:CGPointMake(leftTop, height - inset)];
    [path addQuadCurveToPoint:CGPointMake(side, height - radius) controlPoint:CGPointMake(side, height - inset)];
    [path addLineToPoint:CGPointMake(inset, height / 2.0)];
    [path addLineToPoint:CGPointMake(side, radius)];
    [path addQuadCurveToPoint:CGPointMake(leftTop, inset) controlPoint:CGPointMake(side, inset)];
    [path closePath];
    return path;
}

- (UILabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize weight:(UIFontWeight)weight {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    UIFont *titleFont = [UIFont fontWithName:@"PangMenZhengDao" size:fontSize];
    label.font = weight == UIFontWeightBold && titleFont ? titleFont : [UIFont systemFontOfSize:fontSize weight:weight];
    return label;
}

@end

@interface ChatroomRoomCell : UITableViewCell

- (void)configureWithGroup:(LuketGroupChat *)group users:(NSArray<LuketUser *> *)users index:(NSInteger)index;

@end

@interface ChatroomRoomCell ()

@property (nonatomic, strong) ChatroomRoomView *roomView;

@end

@implementation ChatroomRoomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.roomView = [[ChatroomRoomView alloc] init];
        [self.contentView addSubview:self.roomView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat scale = width / 375.0;
    CGFloat roomWidth = MIN(335.0 * scale, width - 40.0 * scale);
    CGFloat roomHeight = ChatroomRoomCardHeight;
    self.roomView.frame = CGRectMake((width - roomWidth) / 2.0, 0.0, roomWidth, roomHeight);
}

- (void)configureWithGroup:(LuketGroupChat *)group users:(NSArray<LuketUser *> *)users index:(NSInteger)index {
    [self.roomView configureWithGroup:group users:users index:index];
}

@end

@interface ChatroomViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<UIButton *> *segmentButtons;
@property (nonatomic, copy) NSArray<LuketGroupChat *> *groupChats;
@property (nonatomic, copy) NSArray<LuketGroupChat *> *displayedGroupChats;
@property (nonatomic, copy) NSArray<LuketUser *> *users;
@property (nonatomic, assign) ChatroomSegment segment;
@property (nonatomic, assign) BOOL loadedRemoteData;

@end

@implementation ChatroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.segment = ChatroomSegmentForYou;
    self.groupChats = @[];
    self.displayedGroupChats = @[];
    self.users = @[];
    self.loadedRemoteData = NO;
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self updateSegmentButtons];
    [self loadRemoteDataIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateDisplayedGroupChats];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}

- (void)setupViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [self pageBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:ChatroomRoomCell.class forCellReuseIdentifier:@"ChatroomRoomCell"];
    [self.view addSubview:self.tableView];

    UIImageView *headerWaveView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomHeaderWave"]];
    headerWaveView.tag = 1001;
    headerWaveView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:headerWaveView];

    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomTitle"]];
    titleView.tag = 1002;
    titleView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:titleView];

    NSArray<NSNumber *> *tags = @[@(ChatroomSegmentForYou), @(ChatroomSegmentTrending), @(ChatroomSegmentFollowing)];
    NSMutableArray<UIButton *> *buttons = [NSMutableArray arrayWithCapacity:tags.count];
    for (NSNumber *tagNumber in tags) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = tagNumber.integerValue;
        [button addTarget:self action:@selector(segmentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [buttons addObject:button];
    }
    self.segmentButtons = buttons;

    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createButton.tag = 1003;
    [createButton setImage:[[UIImage imageNamed:@"ChatroomCreateButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createButton];
}

- (void)layoutViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat scale = 1.0;

    UIImageView *headerWaveView = [self.view viewWithTag:1001];
    headerWaveView.frame = CGRectMake(0.0, -107.0, width, 278);

    UIImageView *titleView = [self.view viewWithTag:1002];
    titleView.frame = CGRectMake(20, 56, 93.0, 22.0);

    NSArray<NSValue *> *buttonFrames = @[
        [NSValue valueWithCGRect:CGRectMake(20.0 * scale, 94.0 * scale, 94.0 * scale, 40.0 * scale)],
        [NSValue valueWithCGRect:CGRectMake(128.0 * scale, 94.0 * scale, 104.0 * scale, 40.0 * scale)],
        [NSValue valueWithCGRect:CGRectMake(246.0 * scale, 94.0 * scale, 109.0 * scale, 40.0 * scale)]
    ];
    for (NSInteger index = 0; index < self.segmentButtons.count; index++) {
        self.segmentButtons[index].frame = buttonFrames[index].CGRectValue;
    }

    CGFloat listY = 182.0 * scale;
    self.tableView.frame = CGRectMake(0.0, listY, width, height - listY);
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.view.safeAreaInsets.bottom + 112.0, 0.0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    UIButton *createButton = [self.view viewWithTag:1003];
    createButton.frame = CGRectMake(width - 136.0 * scale, height - self.view.safeAreaInsets.bottom - 145.0 * scale, 118.0 * scale, 55.0 * scale);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayedGroupChats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatroomRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatroomRoomCell" forIndexPath:indexPath];
    [cell configureWithGroup:self.displayedGroupChats[indexPath.row] users:self.users index:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChatroomRoomCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatroomDetailViewController *viewController = [[ChatroomDetailViewController alloc] init];
    viewController.groupChat = self.displayedGroupChats[indexPath.row];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)createButtonTapped {
    ChatroomCreateViewController *viewController = [[ChatroomCreateViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)segmentButtonTapped:(UIButton *)sender {
    self.segment = sender.tag;
    [self updateSegmentButtons];
    [self updateDisplayedGroupChats];
}

- (void)loadRemoteDataIfNeeded {
    if (self.loadedRemoteData) {
        return;
    }

    self.loadedRemoteData = YES;
    [self fetchGlobalGroupChats];
}

- (void)fetchGroupChats {
    [self fetchGlobalGroupChats];
}

- (void)fetchGlobalGroupChats {
    [[LuketDataService sharedService] loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        if (error || !data) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.groupChats = data.groupChats ?: @[];
            self.users = data.userList ?: @[];
            [self updateDisplayedGroupChats];
        });
    }];
}

- (void)fetchUsers {
    [[LuketDataService sharedService] loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        if (error || !data) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.users = data.userList ?: @[];
            [self.tableView reloadData];
        });
    }];
}

- (void)updateDisplayedGroupChats {
    NSArray<LuketGroupChat *> *groups = self.groupChats ?: @[];
    NSPredicate *visiblePredicate = [NSPredicate predicateWithBlock:^BOOL(LuketGroupChat *group, NSDictionary<NSString *,id> *bindings) {
        return ![self isGroupBlocked:group];
    }];
    groups = [groups filteredArrayUsingPredicate:visiblePredicate];

    if (self.segment == ChatroomSegmentTrending) {
        groups = [groups sortedArrayUsingComparator:^NSComparisonResult(LuketGroupChat *first, LuketGroupChat *second) {
            if (first.likeCount > second.likeCount) {
                return NSOrderedAscending;
            }
            if (first.likeCount < second.likeCount) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
    } else if (self.segment == ChatroomSegmentFollowing) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(LuketGroupChat *group, NSDictionary<NSString *,id> *bindings) {
            return [self isGroupFavorited:group];
        }];
        groups = [groups filteredArrayUsingPredicate:predicate];
    }

    self.displayedGroupChats = groups;
    [self.tableView reloadData];
}

- (BOOL)isGroupFavorited:(LuketGroupChat *)group {
    return [NSUserDefaults.standardUserDefaults boolForKey:[self favoriteStorageKeyForGroup:group]];
}

- (BOOL)isGroupBlocked:(LuketGroupChat *)group {
    return [NSUserDefaults.standardUserDefaults boolForKey:[self blockedStorageKeyForGroup:group]];
}

- (NSString *)favoriteStorageKeyForGroup:(LuketGroupChat *)group {
    return [NSString stringWithFormat:@"%@.%@", ChatroomListFavoriteGroupKeyPrefix, [self normalizedGroupIdForGroup:group]];
}

- (NSString *)blockedStorageKeyForGroup:(LuketGroupChat *)group {
    return [NSString stringWithFormat:@"%@.%@", ChatroomListBlockedGroupKeyPrefix, [self normalizedGroupIdForGroup:group]];
}

- (NSString *)normalizedGroupIdForGroup:(LuketGroupChat *)group {
    NSString *groupId = [group.groupId stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (groupId.length == 0) {
        groupId = group.title.length > 0 ? group.title : @"default";
    }

    return groupId;
}

- (void)updateSegmentButtons {
    NSArray<NSString *> *normalImages = @[
        @"ChatroomForYouNormal",
        @"ChatroomTrendingNormal",
        @"ChatroomFollowingNormal"
    ];
    NSArray<NSString *> *selectedImages = @[
        @"ChatroomForYouSelected",
        @"ChatroomTrendingSelected",
        @"ChatroomFollowingSelected"
    ];

    for (NSInteger index = 0; index < self.segmentButtons.count; index++) {
        UIButton *button = self.segmentButtons[index];
        NSArray<NSString *> *images = button.tag == self.segment ? selectedImages : normalImages;
        [button setImage:[[UIImage imageNamed:images[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

@end
