//
//  MessageViewController.m
//  Luket
//

#import "MessageViewController.h"
#import "FriendChatViewController.h"
#import "../Data/Service/LuketDataService.h"

static NSString * const MessageChatMessagesKeyPrefix = @"FriendChatMessages.";
static NSString * const MessageChatUpdatedTimeKeyPrefix = @"FriendChatUpdatedTime.";
static NSString * const MessageChatTitleKeyPrefix = @"FriendChatTitle.";

@interface MessageCell : UITableViewCell

- (void)configureWithTitle:(NSString *)title message:(NSString *)message index:(NSInteger)index;

@end

@interface MessageCell ()

@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.cardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageListCellBackground"]];
        self.cardImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.cardImageView];

        self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"MotoChat";
        self.titleLabel.textColor = [self titleColor];
        self.titleLabel.font = [self titleFontWithSize:20.0];
        [self.contentView addSubview:self.titleLabel];

        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.textColor = [self titleColor];
        self.messageLabel.font = [UIFont systemFontOfSize:14.0];
        self.messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.messageLabel];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat cardWidth = width - 40.0;

    self.cardImageView.frame = CGRectMake(20.0, 0.0, cardWidth, 73.0);
    self.avatarImageView.frame = CGRectMake(40.0, 17.0, 40.0, 40.0);
    self.avatarImageView.layer.cornerRadius = 20.0;
    CGFloat textWidth = CGRectGetMaxX(self.cardImageView.frame) - 100.0 - 20.0;
    self.titleLabel.frame = CGRectMake(100.0, 16.0, textWidth, 24.0);
    self.messageLabel.frame = CGRectMake(100.0, 43.0, textWidth, 22.0);
}

- (void)configureWithTitle:(NSString *)title message:(NSString *)message index:(NSInteger)index {
    self.titleLabel.text = title.length > 0 ? title : @"MotoChat";
    self.messageLabel.text = message.length > 0 ? message : @"";
    self.avatarImageView.transform = CGAffineTransformMakeScale(index % 2 == 0 ? 1.0 : -1.0, 1.0);
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end

@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *emptyStateImageView;
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, id> *> *conversations;
@property (nonatomic, copy) NSArray<LuketUser *> *users;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [self pageBackgroundColor];
    self.conversations = @[];
    [self setupViews];
    [self loadUsers];
    [self reloadConversations];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(blockedUsersDidChange)
                                                 name:@"LuketBlockedUsersDidChangeNotification"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadConversations];
}

- (void)blockedUsersDidChange {
    [self reloadConversations];
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
    [self.tableView registerClass:MessageCell.class forCellReuseIdentifier:@"MessageCell"];
    [self.view addSubview:self.tableView];

    self.emptyStateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CommonEmptyState"]];
    self.emptyStateImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.emptyStateImageView.hidden = YES;
    [self.view addSubview:self.emptyStateImageView];

    UIImageView *headerWaveView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageHeaderWave"]];
    headerWaveView.tag = 1001;
    headerWaveView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:headerWaveView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 1002;
    titleLabel.text = @"Message";
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [self.view addSubview:titleLabel];
}

- (void)layoutViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);

    UIImageView *headerWaveView = [self.view viewWithTag:1001];
    headerWaveView.frame = CGRectMake(0.0, 0.0, width, 128.0);

    UILabel *titleLabel = [self.view viewWithTag:1002];
    titleLabel.frame = CGRectMake(20.0, 56.0, 220.0, 34.0);

    self.tableView.frame = CGRectMake(0.0, 154.0, width, height - 154.0);
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.view.safeAreaInsets.bottom + 100.0, 0.0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    CGFloat emptyWidth = 121.0;
    CGFloat emptyHeight = 142.0;
    CGFloat emptyY = CGRectGetMinY(self.tableView.frame) + (CGRectGetHeight(self.tableView.frame) - emptyHeight) * 0.36;
    self.emptyStateImageView.frame = CGRectMake((width - emptyWidth) / 2.0, emptyY, emptyWidth, emptyHeight);
    [self.view bringSubviewToFront:self.emptyStateImageView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    NSDictionary<NSString *, id> *conversation = self.conversations[indexPath.row];
    [cell configureWithTitle:conversation[@"title"]
                     message:conversation[@"lastMessage"]
                       index:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 91.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary<NSString *, id> *conversation = self.conversations[indexPath.row];
    FriendChatViewController *viewController = [[FriendChatViewController alloc] init];
    viewController.conversationUserId = conversation[@"userId"];
    viewController.conversationTitle = conversation[@"title"];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)loadUsers {
    [[LuketDataService sharedService] loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        if (error || !data) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.users = data.userList ?: @[];
            [self reloadConversations];
        });
    }];
}

- (void)reloadConversations {
    NSMutableArray<NSDictionary<NSString *, id> *> *conversations = [NSMutableArray array];
    NSString *bundleIdentifier = NSBundle.mainBundle.bundleIdentifier;
    NSDictionary *defaults = bundleIdentifier.length > 0 ? [NSUserDefaults.standardUserDefaults persistentDomainForName:bundleIdentifier] : @{};

    for (NSString *key in defaults.allKeys) {
        if (![key hasPrefix:MessageChatMessagesKeyPrefix]) {
            continue;
        }

        NSArray *messages = [NSUserDefaults.standardUserDefaults arrayForKey:key];
        NSDictionary *lastMessage = messages.lastObject;
        NSString *messageText = [lastMessage[@"text"] isKindOfClass:NSString.class] ? lastMessage[@"text"] : @"";
        if (messageText.length == 0) {
            continue;
        }

        NSString *userId = [key substringFromIndex:MessageChatMessagesKeyPrefix.length];
        if ([self currentUserBlockedUserId:userId]) {
            continue;
        }

        NSString *updatedTimeKey = [NSString stringWithFormat:@"%@%@", MessageChatUpdatedTimeKeyPrefix, userId];
        NSString *titleKey = [NSString stringWithFormat:@"%@%@", MessageChatTitleKeyPrefix, userId];
        NSString *cachedTitle = [NSUserDefaults.standardUserDefaults stringForKey:titleKey];
        NSTimeInterval updatedTime = [NSUserDefaults.standardUserDefaults doubleForKey:updatedTimeKey];
        [conversations addObject:@{
            @"userId": userId ?: @"",
            @"title": cachedTitle.length > 0 ? cachedTitle : [self displayNameForUserId:userId],
            @"lastMessage": messageText,
            @"updatedTime": @(updatedTime)
        }];
    }

    [conversations sortUsingComparator:^NSComparisonResult(NSDictionary<NSString *,id> *first, NSDictionary<NSString *,id> *second) {
        NSTimeInterval firstTime = [first[@"updatedTime"] doubleValue];
        NSTimeInterval secondTime = [second[@"updatedTime"] doubleValue];
        if (firstTime > secondTime) {
            return NSOrderedAscending;
        }
        if (firstTime < secondTime) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];

    self.conversations = conversations.copy;
    [self.tableView reloadData];
    [self updateEmptyStateVisibility];
}

- (void)updateEmptyStateVisibility {
    self.emptyStateImageView.hidden = self.conversations.count > 0;
}

- (NSString *)displayNameForUserId:(NSString *)userId {
    for (LuketUser *user in self.users) {
        if (![user.userId isEqualToString:userId]) {
            continue;
        }
        if (user.nickname.length > 0) {
            return user.nickname;
        }
        if (user.email.length > 0) {
            return user.email;
        }
        break;
    }

    return userId.length > 0 ? userId : @"MotoChat";
}

- (BOOL)currentUserBlockedUserId:(NSString *)targetUserId {
    NSString *currentUserId = LuketDataService.sharedService.currentLoginUserId;
    if (currentUserId.length == 0 || targetUserId.length == 0) {
        return NO;
    }

    LuketGlobalData *globalData = LuketDataService.sharedService.cachedGlobalData;
    for (LuketBlackRelation *relation in globalData.blackList) {
        if ([relation.blockUserId isEqualToString:currentUserId] && [relation.targetUserId isEqualToString:targetUserId]) {
            return YES;
        }
    }
    return NO;
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
