//
//  FriendChatViewController.m
//  Luket
//

#import "FriendChatViewController.h"
#import "Cell/FriendChatMessageCell.h"

@interface FriendChatViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomInputView;
@property (nonatomic, strong) UITextField *messageTextField;
@property (nonatomic, assign) CGFloat keyboardOffset;

@end

@implementation FriendChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self setupKeyboardHandling];
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
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.tag = 1004;
    nameLabel.text = @"Harlan";
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
    topContentView.frame = CGRectMake(46.0, 64.0, width - 92.0, 56.0);
    
    UIButton *backButton = [topContentView viewWithTag:1002];
    backButton.frame = CGRectMake(10.0, 6.0, 44.0, 44.0);
    
    UIImageView *avatarView = [topContentView viewWithTag:1003];
    avatarView.frame = CGRectMake(132.0, 6.0, 45.0, 45.0);
    avatarView.layer.cornerRadius = 22.5;
    
    UILabel *nameLabel = [topContentView viewWithTag:1004];
    nameLabel.frame = CGRectMake(192.0, 20.0, 120.0, 24.0);
    
    UIButton *moreButton = [topContentView viewWithTag:1005];
    moreButton.frame = CGRectMake(CGRectGetWidth(topContentView.bounds) - 44.0, 6.0, 44.0, 44.0);
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendChatMessageCell" forIndexPath:indexPath];
    [cell configureWithText:[self messageTextAtIndex:indexPath.row]
                       name:[self messageNameAtIndex:indexPath.row]
                   incoming:[self isIncomingMessageAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FriendChatMessageCell heightForText:[self messageTextAtIndex:indexPath.row]
                                       incoming:[self isIncomingMessageAtIndex:indexPath.row]
                                          width:CGRectGetWidth(tableView.bounds)];
}

- (NSString *)messageTextAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"Hey guys! Just came back from an\namazing long-distance swim.";
    }
    
    return @"Tell us about it now!";
}

- (NSString *)messageNameAtIndex:(NSInteger)index {
    return index == 0 ? @"Harlan" : @"Thea";
}

- (BOOL)isIncomingMessageAtIndex:(NSInteger)index {
    return index == 0;
}

- (void)sendButtonTapped {
    [self.view endEditing:YES];
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
    [textField resignFirstResponder];
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
