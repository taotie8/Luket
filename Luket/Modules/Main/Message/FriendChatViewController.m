//
//  FriendChatViewController.m
//  Luket
//

#import "FriendChatViewController.h"
#import "Cell/FriendChatMessageCell.h"
#import "../Common/LuketMediaResource.h"
#import "../Data/Service/LuketDataService.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const FriendChatMessagesKeyPrefix = @"FriendChatMessages";
static NSString * const FriendChatUpdatedTimeKeyPrefix = @"FriendChatUpdatedTime";
static NSString * const FriendChatTitleKeyPrefix = @"FriendChatTitle";

@interface FriendChatViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomInputView;
@property (nonatomic, strong) UITextField *messageTextField;
@property (nonatomic, strong) NSMutableArray<NSDictionary<NSString *, id> *> *messages;
@property (nonatomic, assign) CGFloat keyboardOffset;
@property (nonatomic, strong) UIView *mutualFollowOverlayView;

@end

@implementation FriendChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMessages];
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self loadConversationUserIfNeeded];
    [self setupKeyboardHandling];
}

- (void)setupMessages {
    NSArray *savedMessages = [NSUserDefaults.standardUserDefaults arrayForKey:[self messagesStorageKey]];
    if ([self shouldIgnoreLegacyDefaultMessages:savedMessages]) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:[self messagesStorageKey]];
        self.messages = [NSMutableArray array];
        return;
    }

    if (savedMessages.count > 0) {
        self.messages = [savedMessages mutableCopy];
        return;
    }

    self.messages = [NSMutableArray array];
}

- (BOOL)shouldIgnoreLegacyDefaultMessages:(NSArray *)messages {
    if (messages.count != 2) {
        return NO;
    }

    NSDictionary *firstMessage = messages.firstObject;
    NSDictionary *secondMessage = messages.lastObject;
    return [firstMessage[@"text"] isEqualToString:@"Hey guys! Just came back from an\namazing long-distance swim."]
        && [firstMessage[@"name"] isEqualToString:@"Harlan"]
        && [secondMessage[@"text"] isEqualToString:@"Tell us about it now!"]
        && [secondMessage[@"name"] isEqualToString:@"Thea"];
}

- (void)saveMessages {
    [NSUserDefaults.standardUserDefaults setObject:self.messages forKey:[self messagesStorageKey]];
    [NSUserDefaults.standardUserDefaults setDouble:NSDate.date.timeIntervalSince1970 forKey:[self updatedTimeStorageKey]];
    if (self.conversationTitle.length > 0) {
        [NSUserDefaults.standardUserDefaults setObject:self.conversationTitle forKey:[self titleStorageKey]];
    }
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)messagesStorageKey {
    NSString *userId = [self.conversationUserId stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (userId.length == 0) {
        return FriendChatMessagesKeyPrefix;
    }

    return [NSString stringWithFormat:@"%@.%@", FriendChatMessagesKeyPrefix, userId];
}

- (NSString *)updatedTimeStorageKey {
    NSString *userId = [self.conversationUserId stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (userId.length == 0) {
        return FriendChatUpdatedTimeKeyPrefix;
    }

    return [NSString stringWithFormat:@"%@.%@", FriendChatUpdatedTimeKeyPrefix, userId];
}

- (NSString *)titleStorageKey {
    NSString *userId = [self.conversationUserId stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (userId.length == 0) {
        return FriendChatTitleKeyPrefix;
    }

    return [NSString stringWithFormat:@"%@.%@", FriendChatTitleKeyPrefix, userId];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}

- (void)setupViews {
    UIImageView *headerWaveView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageHeaderWave"]];
    headerWaveView.tag = 1001;
    headerWaveView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:headerWaveView];

    UIView *topContentView = [[UIView alloc] init];
    topContentView.tag = 1006;
    topContentView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:topContentView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = 1002;
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topContentView addSubview:backButton];

    UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    avatarView.tag = 1003;
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    avatarView.clipsToBounds = YES;
    [topContentView addSubview:avatarView];
    [self setImageView:avatarView identifier:self.conversationAvatarIdentifier placeholderImageName:@"HomeHeroImage"];

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.tag = 1004;
    nameLabel.text = self.conversationTitle.length > 0 ? self.conversationTitle : @"Harlan";
    nameLabel.textColor = [self titleColor];
    nameLabel.font = [self titleFontWithSize:20.0];
    [topContentView addSubview:nameLabel];

    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.tag = 1005;
    [moreButton setImage:[[UIImage imageNamed:@"DetailMoreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topContentView addSubview:moreButton];

    [self setupTableView];
    [self setupBottomInputView];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:FriendChatMessageCell.class forCellReuseIdentifier:@"FriendChatMessageCell"];
    [self.view addSubview:self.tableView];
}

- (void)setupBottomInputView {
    self.bottomInputView = [[UIView alloc] init];
    self.bottomInputView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.bottomInputView];

    self.messageTextField = [[UITextField alloc] init];
    self.messageTextField.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:244.0 / 255.0 blue:248.0 / 255.0 alpha:1.0];
    self.messageTextField.layer.cornerRadius = 31.0;
    self.messageTextField.layer.masksToBounds = YES;
    self.messageTextField.delegate = self;
    self.messageTextField.returnKeyType = UIReturnKeyDone;
    self.messageTextField.textColor = [self titleColor];
    self.messageTextField.font = [UIFont systemFontOfSize:17.0];
    self.messageTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 24.0, 1.0)];
    self.messageTextField.leftViewMode = UITextFieldViewModeAlways;
    self.messageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Say something....."
                                                                                   attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:162.0 / 255.0 green:176.0 / 255.0 blue:196.0 / 255.0 alpha:1.0]}];
    [self.bottomInputView addSubview:self.messageTextField];

    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.tag = 1201;
    [sendButton setImage:[[UIImage imageNamed:@"DetailSendButtonBackground"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomInputView addSubview:sendButton];
}

- (void)layoutViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);

    UIImageView *headerWaveView = [self.view viewWithTag:1001];
    headerWaveView.frame = CGRectMake(0.0, 0.0, width, 128.0);

    UIView *topContentView = [self.view viewWithTag:1006];
    topContentView.frame = CGRectMake(5.0, 50.0, width - 10.0, 56.0);

    UIButton *backButton = [topContentView viewWithTag:1002];
    backButton.frame = CGRectMake(10.0, 6.0, 44.0, 44.0);

    UIImageView *avatarView = [topContentView viewWithTag:1003];
    avatarView.frame = CGRectMake(CGRectGetMaxX(backButton.frame) + 15.0, 6.0, 45.0, 45.0);
    avatarView.layer.cornerRadius = 22.5;

    UIButton *moreButton = [topContentView viewWithTag:1005];
    moreButton.frame = CGRectMake(CGRectGetWidth(topContentView.bounds) - 44.0, 6.0, 44.0, 44.0);

    UILabel *nameLabel = [topContentView viewWithTag:1004];
    CGFloat nameX = CGRectGetMaxX(avatarView.frame) + 15.0;
    nameLabel.frame = CGRectMake(nameX, 20.0, MAX(0.0, CGRectGetMinX(moreButton.frame) - nameX - 8.0), 24.0);

    CGFloat bottomHeight = 93.0;
    CGFloat tableTop = 154.0;
    CGFloat bottomY = height - bottomHeight - self.keyboardOffset;
    self.tableView.frame = CGRectMake(0.0, tableTop, width, MAX(0.0, bottomY - tableTop));
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    self.bottomInputView.frame = CGRectMake(0.0, height - bottomHeight - self.keyboardOffset, width, bottomHeight);
    self.messageTextField.frame = CGRectMake(20.0, 12.0, width - 40.0, 62.0);

    UIButton *sendButton = [self.bottomInputView viewWithTag:1201];
    sendButton.frame = CGRectMake(width - 114.0, 15.0, 86.0, 52.0);
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadConversationUserIfNeeded {
    __weak typeof(self) weakSelf = self;
    [[LuketDataService sharedService] loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || error || !data) {
            return;
        }

        LuketUser *user = [strongSelf userWithId:strongSelf.conversationUserId globalData:data];
        if (!user) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel *nameLabel = [strongSelf.view viewWithTag:1004];
            if (strongSelf.conversationTitle.length == 0) {
                nameLabel.text = [strongSelf displayNameForUser:user];
            }

            UIImageView *avatarView = [strongSelf.view viewWithTag:1003];
            [strongSelf setImageView:avatarView identifier:user.avatarUrl placeholderImageName:@"HomeHeroImage"];
        });
    }];
}

- (LuketUser *)userWithId:(NSString *)userId globalData:(LuketGlobalData *)globalData {
    NSString *targetUserId = [userId stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (targetUserId.length == 0) {
        return nil;
    }

    for (LuketUser *user in globalData.userList) {
        if ([user.userId isEqualToString:targetUserId]) {
            return user;
        }
    }
    return nil;
}

- (NSString *)displayNameForUser:(LuketUser *)user {
    if (user.nickname.length > 0) {
        return user.nickname;
    }
    if (user.email.length > 0) {
        return user.email;
    }
    if (user.userId.length > 0) {
        return user.userId;
    }
    return @"";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendChatMessageCell" forIndexPath:indexPath];
    NSDictionary<NSString *, id> *message = self.messages[indexPath.row];
    [cell configureWithText:message[@"text"]
                       name:message[@"name"]
                   incoming:[message[@"incoming"] boolValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary<NSString *, id> *message = self.messages[indexPath.row];
    return [FriendChatMessageCell heightForText:message[@"text"]
                                       incoming:[message[@"incoming"] boolValue]
                                          width:CGRectGetWidth(tableView.bounds)];
}

- (void)sendButtonTapped {
    NSString *text = [self.messageTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (text.length == 0) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [[LuketDataService sharedService] loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        if (![strongSelf canChatWithGlobalData:data]) {
            [strongSelf showMutualFollowPrompt];
            return;
        }

        [strongSelf sendMessageWithText:text];
    }];
}

- (void)sendMessageWithText:(NSString *)text {
    [self.messages addObject:@{
        @"text": text,
        @"name": @"Thea",
        @"incoming": @NO
    }];
    [self saveMessages];
    self.messageTextField.text = @"";

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (BOOL)canChatWithGlobalData:(LuketGlobalData *)globalData {
    NSString *currentUserId = [self currentUserId];
    NSString *targetUserId = [self.conversationUserId stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (currentUserId.length == 0 || targetUserId.length == 0 || [currentUserId isEqualToString:targetUserId]) {
        return YES;
    }

    return [self userId:currentUserId followsUserId:targetUserId globalData:globalData]
        && [self userId:targetUserId followsUserId:currentUserId globalData:globalData];
}

- (BOOL)userId:(NSString *)userId followsUserId:(NSString *)targetUserId globalData:(LuketGlobalData *)globalData {
    for (LuketFollowRelation *relation in globalData.followList) {
        if ([relation.userId isEqualToString:userId] && [relation.targetUserId isEqualToString:targetUserId]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)currentUserId {
    LuketDataService *service = LuketDataService.sharedService;
    if (service.currentLoginUserId.length > 0) {
        return service.currentLoginUserId;
    }
    return service.currentUser.userId ?: @"";
}

- (void)showMutualFollowPrompt {
    [self dismissKeyboard];
    if (self.mutualFollowOverlayView) {
        return;
    }

    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.backgroundColor = [UIColor colorWithRed:24.0 / 255.0 green:42.0 / 255.0 blue:55.0 / 255.0 alpha:0.68];

    UIImageView *cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FriendChatMutualFollowCard"]];
    cardView.userInteractionEnabled = YES;
    cardView.contentMode = UIViewContentModeScaleAspectFit;
    cardView.translatesAutoresizingMaskIntoConstraints = NO;
    [overlayView addSubview:cardView];

    UIButton *gotItButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gotItButton.translatesAutoresizingMaskIntoConstraints = NO;
    [gotItButton setImage:[[UIImage imageNamed:@"FriendChatGotItButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [gotItButton addTarget:self action:@selector(mutualFollowGotItButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:gotItButton];

    [self.view addSubview:overlayView];
    self.mutualFollowOverlayView = overlayView;

    [NSLayoutConstraint activateConstraints:@[
        [cardView.centerXAnchor constraintEqualToAnchor:overlayView.centerXAnchor],
        [cardView.centerYAnchor constraintEqualToAnchor:overlayView.centerYAnchor],
        [cardView.widthAnchor constraintEqualToAnchor:overlayView.widthAnchor multiplier:0.86],
        [cardView.heightAnchor constraintEqualToAnchor:cardView.widthAnchor multiplier:975.0 / 997.0],

        [gotItButton.centerXAnchor constraintEqualToAnchor:cardView.centerXAnchor],
        [gotItButton.bottomAnchor constraintEqualToAnchor:cardView.bottomAnchor constant:-61.0],
        [gotItButton.widthAnchor constraintEqualToAnchor:cardView.widthAnchor multiplier:0.64],
        [gotItButton.heightAnchor constraintEqualToAnchor:gotItButton.widthAnchor multiplier:177.0 / 954.0]
    ]];
}

- (void)mutualFollowGotItButtonTapped {
    [self.mutualFollowOverlayView removeFromSuperview];
    self.mutualFollowOverlayView = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moreButtonTapped {
}

- (void)setupKeyboardHandling {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [self.view convertRect:[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    self.keyboardOffset = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(keyboardFrame);

    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutViews];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardOffset = 0.0;

    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutViews];
    } completion:nil];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendButtonTapped];
    return YES;
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIColor *)bubbleColor {
    return [UIColor colorWithRed:31.0 / 255.0 green:62.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
