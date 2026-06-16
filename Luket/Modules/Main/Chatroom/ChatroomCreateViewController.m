//
//  ChatroomCreateViewController.m
//  Luket
//

#import "ChatroomCreateViewController.h"

@interface ChatroomCreateViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIView *topCardView;
@property (nonatomic, strong) UIView *roomNameContentView;
@property (nonatomic, strong) UIView *introduceContentView;
@property (nonatomic, strong) UITextField *roomNameTextField;
@property (nonatomic, strong) UITextView *introduceTextView;
@property (nonatomic, assign) CGFloat keyboardOffset;

@end

@implementation ChatroomCreateViewController

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
    [self setupTopCard];
    [self setupRoomNameCard];
    [self setupIntroduceCard];
}

- (void)setupTopCard {
    self.topCardView = [[UIView alloc] init];
    self.topCardView.backgroundColor = UIColor.whiteColor;
    self.topCardView.layer.cornerRadius = 11.0;
    self.topCardView.layer.masksToBounds = YES;
    [self.view addSubview:self.topCardView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16.0, 12.0, 32.0, 32.0);
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topCardView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 0.0, 160.0, 56.0)];
    titleLabel.text = @"Create";
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [self.topCardView addSubview:titleLabel];
    
    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createButton.tag = 1001;
    [createButton setImage:[[UIImage imageNamed:@"ChatroomCreateSubmitButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topCardView addSubview:createButton];
}

- (void)setupRoomNameCard {
    self.roomNameContentView = [[UIView alloc] init];
    [self.view addSubview:self.roomNameContentView];
    
    UIImageView *cardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomCreateRoomNameCard"]];
    cardImageView.tag = 1001;
    cardImageView.contentMode = UIViewContentModeScaleToFill;
    [self.roomNameContentView addSubview:cardImageView];
    
    self.roomNameTextField = [self textFieldWithPlaceholder:@"Please enter"];
    [self.roomNameContentView addSubview:self.roomNameTextField];
}

- (void)setupIntroduceCard {
    self.introduceContentView = [[UIView alloc] init];
    [self.view addSubview:self.introduceContentView];
    
    UIImageView *cardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomCreateIntroduceCard"]];
    cardImageView.tag = 1001;
    cardImageView.contentMode = UIViewContentModeScaleToFill;
    [self.introduceContentView addSubview:cardImageView];
    
    self.introduceTextView = [[UITextView alloc] init];
    self.introduceTextView.backgroundColor = [self inputColor];
    self.introduceTextView.layer.cornerRadius = 11.0;
    self.introduceTextView.layer.masksToBounds = YES;
    self.introduceTextView.delegate = self;
    self.introduceTextView.returnKeyType = UIReturnKeyDone;
    self.introduceTextView.text = @"Please enter";
    self.introduceTextView.textColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    self.introduceTextView.font = [UIFont systemFontOfSize:16.0];
    self.introduceTextView.textContainerInset = UIEdgeInsetsMake(14.0, 16.0, 14.0, 16.0);
    [self.introduceContentView addSubview:self.introduceTextView];
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [self inputColor];
    textField.layer.cornerRadius = 11.0;
    textField.layer.masksToBounds = YES;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.textColor = UIColor.whiteColor;
    textField.font = [UIFont systemFontOfSize:16.0];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 24.0, 1.0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.35]}];
    return textField;
}

- (void)layoutViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat topY = self.view.safeAreaInsets.top + 5.0;
    
    CGFloat contentWidth = width - 40.0;
    self.topCardView.frame = CGRectMake(20.0, topY, contentWidth, 56.0);
    
    UIButton *createButton = [self.topCardView viewWithTag:1001];
    createButton.frame = CGRectMake(contentWidth - 100.0, 6.0, 80.0, 44.0);
    
    CGFloat roomNameHeight = 160.0;
    self.roomNameContentView.frame = CGRectMake(20.0,
                                                CGRectGetMaxY(self.topCardView.frame) + 24.0,
                                                contentWidth,
                                                roomNameHeight);
    
    UIImageView *roomNameCardView = [self.roomNameContentView viewWithTag:1001];
    roomNameCardView.frame = self.roomNameContentView.bounds;
    
    self.roomNameTextField.frame = CGRectMake(21.0, 96.0, contentWidth - 42.0, 41.0);
    self.roomNameTextField.layer.cornerRadius = 11.0;

    CGFloat introduceHeight = 191.0;
    self.introduceContentView.frame = CGRectMake(20.0,
                                                 CGRectGetMaxY(self.roomNameContentView.frame) + 10.0,
                                                 contentWidth,
                                                 introduceHeight);
    
    UIImageView *introduceCardView = [self.introduceContentView viewWithTag:1001];
    introduceCardView.frame = self.introduceContentView.bounds;
    
    self.introduceTextView.frame = CGRectMake(21.0, 48.0, contentWidth - 42.0, 126.0);
    self.introduceTextView.layer.cornerRadius = 11.0;
    
    self.roomNameContentView.transform = CGAffineTransformMakeTranslation(0.0, -self.keyboardOffset);
    self.introduceContentView.transform = CGAffineTransformMakeTranslation(0.0, -self.keyboardOffset);
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createButtonTapped {
    [self.view endEditing:YES];
    NSString *roomName = [self.roomNameTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSString *introduction = [self.introduceTextView.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (roomName.length == 0) {
        [self showValidationMessage:@"Please enter a room name."];
        return;
    }
    if (introduction.length == 0 || [introduction isEqualToString:@"Please enter"]) {
        [self showValidationMessage:@"Please enter an introduction."];
        return;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Group created successfully."
                                                                             message:@"It is under review."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showValidationMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
    CGRect introduceFrame = [self.introduceContentView convertRect:self.introduceTextView.frame toView:self.view];
    CGFloat overlap = CGRectGetMaxY(introduceFrame) + 16.0 - CGRectGetMinY(keyboardFrame);
    self.keyboardOffset = MAX(overlap, 0.0);
    
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Please enter"]) {
        textView.text = @"";
        textView.textColor = UIColor.whiteColor;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = @"Please enter";
        textView.textColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text containsString:@"\n"]) {
        textView.text = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [textView resignFirstResponder];
    }
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIColor *)inputColor {
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
