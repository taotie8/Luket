//
//  ForgotPasswordViewController.m
//  Luket
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *topCardView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *formContentView;
@property (nonatomic, strong) UIImageView *formCardImageView;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *passwordAgainTextField;
@property (nonatomic, strong) UIImageView *nextButtonImageView;
@property (nonatomic, weak) UITextField *activeTextField;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:181.0 / 255.0 green:222.0 / 255.0 blue:240.0 / 255.0 alpha:1.0];
    [self setupViews];
    [self setupKeyboardHandling];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}

- (void)setupViews {
    self.topCardView = [[UIView alloc] init];
    self.topCardView.backgroundColor = [UIColor whiteColor];
    self.topCardView.layer.cornerRadius = 11.0;
    self.topCardView.layer.masksToBounds = YES;
    [self.view addSubview:self.topCardView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"AuthBackIcon"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topCardView addSubview:self.backButton];
    
    self.titleLabel = [self titleLabelWithText:@"Forgot password"];
    [self.topCardView addSubview:self.titleLabel];
    
    self.formContentView = [[UIView alloc] init];
    [self.view addSubview:self.formContentView];
    
    self.formCardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AuthFormCard"]];
    self.formCardImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.formContentView addSubview:self.formCardImageView];
    
    self.emailLabel = [self titleLabelWithText:@"Email"];
    self.emailLabel.textAlignment = NSTextAlignmentCenter;
    [self.formContentView addSubview:self.emailLabel];
    
    self.passwordLabel = [self titleLabelWithText:@"Password"];
    self.passwordLabel.textAlignment = NSTextAlignmentCenter;
    [self.formContentView addSubview:self.passwordLabel];
    
    self.emailTextField = [self textFieldWithPlaceholder:@"Enter email address" secureTextEntry:NO];
    [self.formContentView addSubview:self.emailTextField];
    
    self.passwordTextField = [self textFieldWithPlaceholder:@"Enter password" secureTextEntry:YES];
    [self.formContentView addSubview:self.passwordTextField];
    
    self.passwordAgainTextField = [self textFieldWithPlaceholder:@"Enter password again" secureTextEntry:YES];
    [self.formContentView addSubview:self.passwordAgainTextField];
    
    self.nextButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ForgotNextButton"]];
    self.nextButtonImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.nextButtonImageView.userInteractionEnabled = YES;
    [self.formContentView addSubview:self.nextButtonImageView];
}

- (UILabel *)titleLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    label.font = [self titleFontWithSize:20.0];
    return label;
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder secureTextEntry:(BOOL)secureTextEntry {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor colorWithRed:31.0 / 255.0 green:62.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    textField.layer.cornerRadius = 11.0;
    textField.layer.masksToBounds = YES;
    textField.secureTextEntry = secureTextEntry;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.textColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:16.0];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 17.0, 1.0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.35]}];
    return textField;
}

- (void)layoutViews {
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat topCardY = self.view.safeAreaInsets.top + 5.0;
    CGFloat topCardWidth = viewWidth - 54.0;
    
    self.topCardView.frame = CGRectMake(20, topCardY, topCardWidth, 56.0);
    self.backButton.frame = CGRectMake(16.0, 10.0, 32.0, 32.0);
    self.titleLabel.frame = CGRectMake(60.0, 0.0, 230.0, 52.0);
    
    CGFloat cardWidth = 340.0;
    CGFloat cardX = (viewWidth - cardWidth) / 2.0;
    CGFloat cardY = 138.0;
    
    self.formContentView.frame = CGRectMake(cardX, cardY, cardWidth, 447.0);
    self.formCardImageView.frame = self.formContentView.bounds;
    self.emailLabel.frame = CGRectMake(0.0, 63.0, cardWidth, 22.0);
    self.emailTextField.frame = CGRectMake(16.0, 97.0, cardWidth - 32.0, 51.0);
    self.passwordLabel.frame = CGRectMake(0.0, 172.0, cardWidth, 28.0);
    self.passwordTextField.frame = CGRectMake(16.0, 206.0, cardWidth - 32.0, 51.0);
    self.passwordAgainTextField.frame = CGRectMake(16.0, 265.0, cardWidth - 32.0, 51.0);
    self.nextButtonImageView.frame = CGRectMake((cardWidth - 318.0) / 2.0, 356.0, 318.0, 51.0);
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupKeyboardHandling {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.activeTextField) {
        return;
    }
    
    CGRect keyboardFrame = [self.view convertRect:[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    CGRect textFieldFrame = [self.activeTextField.superview convertRect:self.activeTextField.frame toView:self.view];
    CGFloat offset = MAX(CGRectGetMaxY(textFieldFrame) + 16.0 - CGRectGetMinY(keyboardFrame), 0.0);
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0.0, -offset);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
