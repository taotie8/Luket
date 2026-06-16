//
//  ChatroomDetailViewController.m
//  Luket
//

#import "ChatroomDetailViewController.h"
#import "ChatroomMemberView.h"
#import "ChatroomMessageCell.h"
#import "../Data/Service/LuketDataService.h"
#import "../Report/ReportViewController.h"

static NSString * const ChatroomMessagesKeyPrefix = @"ChatroomMessages";
static NSString * const ChatroomFavoriteGroupKeyPrefix = @"ChatroomFavoriteGroup";
static NSString * const ChatroomBlockedGroupKeyPrefix = @"ChatroomBlockedGroup";

@interface ChatroomDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *messagesTableView;
@property (nonatomic, strong) UIView *inputBarView;
@property (nonatomic, strong) UIStackView *memberStackView;
@property (nonatomic, strong) UIButton *heartButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UITextField *messageTextField;
@property (nonatomic, strong) NSLayoutConstraint *inputBarBottomConstraint;
@property (nonatomic, copy) NSArray<LuketUser *> *users;
@property (nonatomic, strong) NSMutableArray<NSDictionary<NSString *, id> *> *messages;
@property (nonatomic, assign) BOOL liked;

@end

@implementation ChatroomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadMessages];
    self.liked = [self isGroupFavorited];
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupHeader];
    [self setupInputBar];
    [self setupMessages];
    [self updateHeartButton];
    [self loadMembers];
    [self setupKeyboardHandling];
}

- (void)setupHeader {
    self.headerView = [[UIView alloc] init];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.headerView];

    UIImageView *headerBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomHeaderWave"]];
    headerBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    headerBackgroundView.contentMode = UIViewContentModeScaleToFill;
    [self.headerView addSubview:headerBackgroundView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:backButton];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = self.groupChat.title.length > 0 ? self.groupChat.title : @"Journey Shares";
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [self.headerView addSubview:titleLabel];

    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.translatesAutoresizingMaskIntoConstraints = NO;
    moreButton.tag = 1005;
    [moreButton setImage:[[UIImage imageNamed:@"DetailMoreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:moreButton];

    self.memberStackView = [[UIStackView alloc] init];
    self.memberStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.memberStackView.axis = UILayoutConstraintAxisHorizontal;
    self.memberStackView.alignment = UIStackViewAlignmentTop;
    self.memberStackView.distribution = UIStackViewDistributionFill;
    self.memberStackView.spacing = 8.0;
    [self.headerView addSubview:self.memberStackView];

    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.headerView.heightAnchor constraintEqualToConstant:247],

        [headerBackgroundView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [headerBackgroundView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [headerBackgroundView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [headerBackgroundView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],

        [backButton.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:20.0],
        [backButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:6.0],
        [backButton.widthAnchor constraintEqualToConstant:44],
        [backButton.heightAnchor constraintEqualToConstant:44],

        [titleLabel.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:6.0],
        [titleLabel.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor],
        [titleLabel.heightAnchor constraintEqualToConstant:27.0],

        [moreButton.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor constant:-20],
        [moreButton.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor],
        [moreButton.widthAnchor constraintEqualToConstant:32.0],
        [moreButton.heightAnchor constraintEqualToConstant:32.0],

        [self.memberStackView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:20.0],
        [self.memberStackView.topAnchor constraintEqualToAnchor:backButton.bottomAnchor constant:18.0],
        [self.memberStackView.heightAnchor constraintEqualToConstant:100.0]
    ]];

    [self updateMemberViews];
}

- (void)loadMembers {
    [[LuketDataService sharedService] loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable data, NSError * _Nullable error) {
        if (error || !data) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.users = data.userList ?: @[];
            [self updateMemberViews];
        });
    }];
}

- (void)updateMemberViews {
    if (!self.memberStackView) {
        return;
    }

    for (UIView *view in self.memberStackView.arrangedSubviews) {
        [self.memberStackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }

    NSArray<NSString *> *memberIds = self.groupChat.memberIds ?: @[];
    NSInteger displayCount = MIN(memberIds.count, 6);
    for (NSInteger index = 0; index < displayCount; index++) {
        NSString *memberId = memberIds[index];
        LuketUser *user = [self userWithId:memberId];
        BOOL isCreator = self.groupChat.creatorUserId.length > 0 && [memberId isEqualToString:self.groupChat.creatorUserId];
        ChatroomMemberView *memberView = [[ChatroomMemberView alloc] initWithName:@"" showCreatorBadge:isCreator];
        [memberView configureWithName:[self displayNameForUser:user fallbackUserId:memberId]
                     avatarIdentifier:user.avatarUrl
                     showCreatorBadge:isCreator];
        [self.memberStackView addArrangedSubview:memberView];
        [NSLayoutConstraint activateConstraints:@[
            [memberView.widthAnchor constraintEqualToConstant:60.0],
            [memberView.heightAnchor constraintEqualToConstant:isCreator ? 95.0 : 60.0]
        ]];
        memberView.transform = index % 2 == 0 ? CGAffineTransformIdentity : CGAffineTransformMakeScale(-1.0, 1.0);
    }
}

- (LuketUser *)userWithId:(NSString *)userId {
    for (LuketUser *user in self.users) {
        if ([user.userId isEqualToString:userId]) {
            return user;
        }
    }

    return nil;
}

- (NSString *)displayNameForUser:(LuketUser *)user fallbackUserId:(NSString *)userId {
    if (user.nickname.length > 0) {
        return user.nickname;
    }
    if (user.email.length > 0) {
        return user.email;
    }
    if (userId.length > 0) {
        return userId;
    }
    return @"";
}

- (void)setupMessages {
    self.messagesTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.messagesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.messagesTableView.backgroundColor = [self pageBackgroundColor];
    self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messagesTableView.showsVerticalScrollIndicator = NO;
    self.messagesTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.messagesTableView.contentInset = UIEdgeInsetsZero;
    self.messagesTableView.scrollIndicatorInsets = self.messagesTableView.contentInset;
    self.messagesTableView.estimatedRowHeight = 0.0;
    self.messagesTableView.estimatedSectionHeaderHeight = 0.0;
    self.messagesTableView.estimatedSectionFooterHeight = 0.0;
    if (@available(iOS 15.0, *)) {
        self.messagesTableView.sectionHeaderTopPadding = 0.0;
    }
    self.messagesTableView.tableHeaderView = [self groupPromptHeaderView];
    self.messagesTableView.dataSource = self;
    self.messagesTableView.delegate = self;
    [self.messagesTableView registerClass:ChatroomMessageCell.class forCellReuseIdentifier:[ChatroomMessageCell reuseIdentifier]];

    [self.view addSubview:self.messagesTableView];

    [NSLayoutConstraint activateConstraints:@[
        [self.messagesTableView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.messagesTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.messagesTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.messagesTableView.bottomAnchor constraintEqualToAnchor:self.inputBarView.topAnchor]
    ]];
}

- (UIView *)groupPromptHeaderView {
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat horizontalInset = 20.0;
    CGFloat topPadding = 22.0;
    CGFloat bottomPadding = 34.0;
    CGFloat labelWidth = width - horizontalInset * 2.0;
    NSString *promptText = [self groupPromptText];

    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    promptLabel.text = promptText;
    promptLabel.textColor = [self titleColor];
    promptLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    promptLabel.numberOfLines = 0;
    promptLabel.textAlignment = NSTextAlignmentCenter;

    CGSize labelSize = [promptLabel sizeThatFits:CGSizeMake(labelWidth - 32.0, CGFLOAT_MAX)];
    CGFloat promptHeight = MAX(46.0, ceil(labelSize.height) + 24.0);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, topPadding + promptHeight + bottomPadding)];
    headerView.backgroundColor = [self pageBackgroundColor];

    UIView *promptBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(horizontalInset, topPadding, labelWidth, promptHeight)];
    promptBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.58];
    promptBackgroundView.layer.cornerRadius = 14.0;
    promptBackgroundView.layer.masksToBounds = YES;
    [headerView addSubview:promptBackgroundView];

    promptLabel.frame = CGRectInset(promptBackgroundView.bounds, 16.0, 12.0);
    [promptBackgroundView addSubview:promptLabel];

    return headerView;
}

- (NSString *)groupPromptText {
    return @"Please keep the conversation friendly. Do not post illegal, harmful, abusive, explicit, fraudulent, or privacy-violating content.";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatroomMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChatroomMessageCell reuseIdentifier] forIndexPath:indexPath];
    NSDictionary<NSString *, id> *message = self.messages[indexPath.row];
    [cell configureWithName:message[@"name"]
                      text:message[@"text"]
                  outgoing:[message[@"outgoing"] boolValue]
               bubbleWidth:[message[@"bubbleWidth"] doubleValue]
              bubbleHeight:[message[@"bubbleHeight"] doubleValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messages[indexPath.row][@"rowHeight"] doubleValue];
}

- (void)loadMessages {
    NSArray *savedMessages = [NSUserDefaults.standardUserDefaults arrayForKey:[self messagesStorageKey]];
    self.messages = savedMessages.count > 0 ? [savedMessages mutableCopy] : [NSMutableArray array];
}

- (void)saveMessages {
    [NSUserDefaults.standardUserDefaults setObject:self.messages forKey:[self messagesStorageKey]];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)messagesStorageKey {
    return [NSString stringWithFormat:@"%@.%@", ChatroomMessagesKeyPrefix, [self normalizedGroupId]];
}

- (NSString *)favoriteStorageKey {
    return [NSString stringWithFormat:@"%@.%@", ChatroomFavoriteGroupKeyPrefix, [self normalizedGroupId]];
}

- (NSString *)blockedStorageKey {
    return [NSString stringWithFormat:@"%@.%@", ChatroomBlockedGroupKeyPrefix, [self normalizedGroupId]];
}

- (NSString *)normalizedGroupId {
    NSString *groupId = [self.groupChat.groupId stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (groupId.length == 0) {
        groupId = self.groupChat.title.length > 0 ? self.groupChat.title : @"default";
    }

    return groupId;
}

- (void)sendButtonTapped {
    NSString *text = [self.messageTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (text.length == 0) {
        return;
    }

    NSDictionary<NSString *, id> *message = [self outgoingMessageWithText:text];
    [self.messages addObject:message];
    [self saveMessages];
    self.messageTextField.text = @"";

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
    [self.messagesTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.messagesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSDictionary<NSString *, id> *)outgoingMessageWithText:(NSString *)text {
    CGFloat bubbleWidth = [self outgoingBubbleWidthForText:text];
    CGFloat bubbleHeight = [self bubbleHeightForText:text width:bubbleWidth];
    CGFloat rowHeight = MAX(72.0, bubbleHeight + 30.0);
    return @{
        @"name": [self currentUserDisplayName],
        @"text": text,
        @"outgoing": @YES,
        @"rowHeight": @(rowHeight),
        @"bubbleWidth": @(bubbleWidth),
        @"bubbleHeight": @(bubbleHeight)
    };
}

- (CGFloat)outgoingBubbleWidthForText:(NSString *)text {
    CGFloat maxWidth = CGRectGetWidth(self.view.bounds) - 120.0;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maxWidth - 36.0, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                     context:nil];
    return MIN(maxWidth, MAX(166.0, ceil(rect.size.width) + 36.0));
}

- (CGFloat)bubbleHeightForText:(NSString *)text width:(CGFloat)width {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width - 36.0, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                     context:nil];
    return MAX(42.0, ceil(rect.size.height) + 24.0);
}

- (NSString *)currentUserDisplayName {
    LuketUser *currentUser = LuketDataService.sharedService.currentUser;
    if (currentUser.nickname.length > 0) {
        return currentUser.nickname;
    }
    if (currentUser.email.length > 0) {
        return currentUser.email;
    }
    if (currentUser.userId.length > 0) {
        return currentUser.userId;
    }
    return @"Me";
}

- (void)setupInputBar {
    self.inputBarView = [[UIView alloc] init];
    self.inputBarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputBarView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.inputBarView];

    UIView *inputBackgroundView = [[UIView alloc] init];
    inputBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    inputBackgroundView.backgroundColor = [UIColor colorWithRed:241.0 / 255.0 green:243.0 / 255.0 blue:246.0 / 255.0 alpha:1.0];
    inputBackgroundView.layer.cornerRadius = 28.0;
    [self.inputBarView addSubview:inputBackgroundView];

    UITextField *textField = [[UITextField alloc] init];
    self.messageTextField = textField;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:14.0];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Say something....."
                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.66 green:0.7 blue:0.78 alpha:1.0]}];
    [inputBackgroundView addSubview:textField];

    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sendButton setImage:[[UIImage imageNamed:@"DetailSendButtonBackground"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.inputBarView addSubview:self.sendButton];

    self.heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.heartButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.heartButton addTarget:self action:@selector(heartButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.inputBarView addSubview:self.heartButton];

    self.inputBarBottomConstraint = [self.inputBarView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];

    [NSLayoutConstraint activateConstraints:@[
        [self.inputBarView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.inputBarView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        self.inputBarBottomConstraint,
        [self.inputBarView.heightAnchor constraintEqualToConstant:88.0],

        [inputBackgroundView.leadingAnchor constraintEqualToAnchor:self.inputBarView.leadingAnchor constant:20.0],
        [inputBackgroundView.topAnchor constraintEqualToAnchor:self.inputBarView.topAnchor constant:8.0],
        [inputBackgroundView.trailingAnchor constraintEqualToAnchor:self.sendButton.trailingAnchor],
        [inputBackgroundView.heightAnchor constraintEqualToConstant:56.0],

        [textField.leadingAnchor constraintEqualToAnchor:inputBackgroundView.leadingAnchor constant:14.0],
        [textField.trailingAnchor constraintEqualToAnchor:self.sendButton.leadingAnchor constant:-8.0],
        [textField.topAnchor constraintEqualToAnchor:inputBackgroundView.topAnchor],
        [textField.bottomAnchor constraintEqualToAnchor:inputBackgroundView.bottomAnchor],

        [self.sendButton.trailingAnchor constraintEqualToAnchor:self.heartButton.leadingAnchor constant:-8.0],
        [self.sendButton.centerYAnchor constraintEqualToAnchor:inputBackgroundView.centerYAnchor],
        [self.sendButton.widthAnchor constraintEqualToConstant:86.0],
        [self.sendButton.heightAnchor constraintEqualToConstant:52.0],

        [self.heartButton.trailingAnchor constraintEqualToAnchor:self.inputBarView.trailingAnchor constant:-20.0],
        [self.heartButton.centerYAnchor constraintEqualToAnchor:inputBackgroundView.centerYAnchor],
        [self.heartButton.widthAnchor constraintEqualToConstant:60.0],
        [self.heartButton.heightAnchor constraintEqualToConstant:52.0]
    ]];
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
    CGFloat overlap = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(keyboardFrame);
    self.inputBarBottomConstraint.constant = -overlap;
    [self animateKeyboardChangeWithNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.inputBarBottomConstraint.constant = 0.0;
    [self animateKeyboardChangeWithNotification:notification];
}

- (void)animateKeyboardChangeWithNotification:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendButtonTapped];
    return YES;
}

- (void)heartButtonTapped {
    self.liked = !self.liked;
    [NSUserDefaults.standardUserDefaults setBool:self.liked forKey:[self favoriteStorageKey]];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self updateHeartButton];
}

- (BOOL)isGroupFavorited {
    return [NSUserDefaults.standardUserDefaults boolForKey:[self favoriteStorageKey]];
}

- (void)moreButtonTapped {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"Report"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self presentReportViewController];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:reportAction];
    [alertController addAction:cancelAction];

    UIButton *moreButton = [self.headerView viewWithTag:1005];
    alertController.popoverPresentationController.sourceView = moreButton ?: self.view;
    alertController.popoverPresentationController.sourceRect = moreButton ? moreButton.bounds : self.view.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)presentReportViewController {
    if (self.presentedViewController) {
        return;
    }

    ReportViewController *viewController = [[ReportViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)updateHeartButton {
    NSString *imageName = self.liked ? @"ChatroomHeartSelected" : @"ChatroomHeartNormal";
    [self.heartButton setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
