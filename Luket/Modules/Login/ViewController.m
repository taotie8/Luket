//
//  ViewController.m
//  Luket
//
//  Created by 上包666 on 2026/6/3.
//

#import "ViewController.h"
#import "SignUpViewController.h"
#import "ForgotPasswordViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *cardContentView;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UIImageView *welcomeImageView;
@property (nonatomic, strong) UIImageView *emailTitleImageView;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIImageView *forgotPasswordImageView;
@property (nonatomic, strong) UIImageView *loginButtonImageView;
@property (nonatomic, strong) UIImageView *createAccountImageView;
@property (nonatomic, strong) UIButton *agreementButton;
@property (nonatomic, strong) UIImageView *agreementTextImageView;
@property (nonatomic, strong) UIView *eulaMaskView;
@property (nonatomic, strong) UIImageView *eulaCardImageView;
@property (nonatomic, strong) UILabel *eulaTitleLabel;
@property (nonatomic, strong) UITextView *eulaTextView;
@property (nonatomic, strong) UIImageView *eulaAgreeButtonImageView;
@property (nonatomic, strong) UIButton *eulaCloseButton;
@property (nonatomic, weak) UITextField *activeTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:181.0 / 255.0 green:222.0 / 255.0 blue:240.0 / 255.0 alpha:1.0];
    [self setupLoginViews];
    [self setupKeyboardHandling];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutLoginViews];
}

- (void)setupLoginViews {
    self.backgroundImageView = [self imageViewWithName:@"LoginBackground"];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.cardContentView = [[UIView alloc] init];
    [self.view addSubview:self.cardContentView];
    
    self.cardImageView = [self imageViewWithName:@"LoginCard"];
    [self.cardContentView addSubview:self.cardImageView];
    
    self.welcomeImageView = [self imageViewWithName:@"LoginWelcomeHeader"];
    [self.cardContentView addSubview:self.welcomeImageView];
    
    self.emailTitleImageView = [self imageViewWithName:@"LoginEmailTitle"];
    [self.cardContentView addSubview:self.emailTitleImageView];
    
    self.emailTextField = [self textFieldWithPlaceholder:@"Enter email address" secureTextEntry:NO];
    [self.cardContentView addSubview:self.emailTextField];
    
    self.passwordTextField = [self textFieldWithPlaceholder:@"Enter password" secureTextEntry:YES];
    [self.cardContentView addSubview:self.passwordTextField];
    
    self.forgotPasswordImageView = [self imageViewWithName:@"LoginForgotPassword"];
    self.forgotPasswordImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *forgotTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordTapped)];
    [self.forgotPasswordImageView addGestureRecognizer:forgotTap];
    [self.cardContentView addSubview:self.forgotPasswordImageView];
    
    self.loginButtonImageView = [self imageViewWithName:@"LoginButton"];
    self.loginButtonImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginButtonTapped)];
    [self.loginButtonImageView addGestureRecognizer:loginTap];
    [self.cardContentView addSubview:self.loginButtonImageView];
    
    self.createAccountImageView = [self imageViewWithName:@"LoginCreateAccountText"];
    self.createAccountImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *signUpTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signUpTapped)];
    [self.createAccountImageView addGestureRecognizer:signUpTap];
    [self.cardContentView addSubview:self.createAccountImageView];
    
    self.agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreementButton setImage:[UIImage imageNamed:@"LoginAgreementUnchecked"] forState:UIControlStateNormal];
    [self.agreementButton setImage:[UIImage imageNamed:@"LoginAgreementChecked"] forState:UIControlStateSelected];
    [self.agreementButton addTarget:self action:@selector(agreementButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.agreementButton];
    
    self.agreementTextImageView = [self imageViewWithName:@"LoginAgreementText"];
    self.agreementTextImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *agreementTextTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showEULAView)];
    [self.agreementTextImageView addGestureRecognizer:agreementTextTap];
    [self.view addSubview:self.agreementTextImageView];
    
    [self setupEULAView];
}

- (UIImageView *)imageViewWithName:(NSString *)name {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
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
    textField.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 17.0, 1.0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.35]}];
    return textField;
}

- (void)layoutLoginViews {
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    
    self.backgroundImageView.frame = self.view.bounds;
    
    CGFloat cardWidth = 340.0;
    CGFloat cardHeight = 467.0;
    CGFloat cardX = (viewWidth - cardWidth) / 2.0;
    CGFloat cardY = (viewHeight - cardHeight) / 2.0 - 10.0;
    
    self.cardContentView.frame = CGRectMake(cardX, cardY, cardWidth, cardHeight);
    self.cardImageView.frame = self.cardContentView.bounds;
    self.welcomeImageView.frame = CGRectMake((cardWidth - 153.0) / 2.0, 65.0, 153.0, 60.0);
    self.emailTitleImageView.frame = CGRectMake((cardWidth - 184.0) / 2.0, CGRectGetMaxY(self.welcomeImageView.frame) + 36.0, 184.0, 22.0);
    self.emailTextField.frame = CGRectMake(16.0,
                                           193.0,
                                           cardWidth - 32.0,
                                           51.0);
    self.emailTextField.layer.cornerRadius = 11.0;
    self.passwordTextField.frame = CGRectMake(16.0,
                                              252.0,
                                              cardWidth - 32.0,
                                              51.0);
    self.passwordTextField.layer.cornerRadius = 11.0;
    self.forgotPasswordImageView.frame = CGRectMake(cardWidth - 16.0 - 104.0, 315.0, 104.0, 17.0);
    self.loginButtonImageView.frame = CGRectMake((cardWidth - 318.0) / 2.0, 356.0, 318.0, 59.0);
    self.createAccountImageView.frame = CGRectMake((cardWidth - 275.0) / 2.0, 422.0, 275.0, 30.0);
    
    CGFloat agreementY = CGRectGetMaxY(self.cardContentView.frame) + 35.0;
    self.agreementButton.frame = CGRectMake(29.0, agreementY, 27.0, 27.0);
    self.agreementTextImageView.frame = CGRectMake(60.0, agreementY + 4.0, 286.0, 17.0);
    [self layoutEULAViews];
}

- (void)agreementButtonTapped:(UIButton *)button {
    button.selected = !button.selected;
}

- (void)loginButtonTapped {
    if (!self.agreementButton.selected) {
        [self showEULAView];
        return;
    }
}

- (void)signUpTapped {
    SignUpViewController *viewController = [[SignUpViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)forgotPasswordTapped {
    ForgotPasswordViewController *viewController = [[ForgotPasswordViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)setupEULAView {
    self.eulaMaskView = [[UIView alloc] init];
    self.eulaMaskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.58];
    self.eulaMaskView.hidden = YES;
    [self.view addSubview:self.eulaMaskView];
    
    self.eulaCardImageView = [self imageViewWithName:@"LoginEULACard"];
    [self.eulaMaskView addSubview:self.eulaCardImageView];
    
    self.eulaTitleLabel = [[UILabel alloc] init];
    self.eulaTitleLabel.text = @"EULA";
    self.eulaTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.eulaTitleLabel.textColor = [UIColor colorWithRed:31.0 / 255.0 green:62.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    self.eulaTitleLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
    [self.eulaMaskView addSubview:self.eulaTitleLabel];
    
    self.eulaTextView = [[UITextView alloc] init];
    self.eulaTextView.backgroundColor = [UIColor clearColor];
    self.eulaTextView.editable = NO;
    self.eulaTextView.textColor = [UIColor colorWithRed:31.0 / 255.0 green:62.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    self.eulaTextView.font = [UIFont systemFontOfSize:15.0];
    [self.eulaMaskView addSubview:self.eulaTextView];
    
    self.eulaAgreeButtonImageView = [self imageViewWithName:@"LoginEULAAgreeButton"];
    self.eulaAgreeButtonImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *agreeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eulaAgreeButtonTapped)];
    [self.eulaAgreeButtonImageView addGestureRecognizer:agreeTap];
    [self.eulaMaskView addSubview:self.eulaAgreeButtonImageView];
    
    self.eulaCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.eulaCloseButton setImage:[UIImage imageNamed:@"LoginEULACloseButton"] forState:UIControlStateNormal];
    [self.eulaCloseButton addTarget:self action:@selector(hideEULAView) forControlEvents:UIControlEventTouchUpInside];
    [self.eulaMaskView addSubview:self.eulaCloseButton];
}

- (void)layoutEULAViews {
    self.eulaMaskView.frame = self.view.bounds;
    
    CGFloat cardWidth = 335.0;
    CGFloat cardHeight = 561.0;
    CGFloat cardX = (CGRectGetWidth(self.eulaMaskView.bounds) - cardWidth) / 2.0;
    CGFloat cardY = (CGRectGetHeight(self.eulaMaskView.bounds) - cardHeight) / 2.0 - 10.0;
    
    self.eulaCardImageView.frame = CGRectMake(cardX, cardY, cardWidth, cardHeight);
    self.eulaTitleLabel.frame = CGRectMake(cardX, cardY + 70.0, cardWidth, 30.0);
    self.eulaTextView.frame = CGRectMake(cardX + 32.0, cardY + 120.0, cardWidth - 64.0, 310.0);
    self.eulaAgreeButtonImageView.frame = CGRectMake(cardX + (cardWidth - 318.0) / 2.0, cardY + 477.0, 318.0, 59.0);
    self.eulaCloseButton.frame = CGRectMake((CGRectGetWidth(self.eulaMaskView.bounds) - 48.0) / 2.0,
                                            CGRectGetMaxY(self.eulaCardImageView.frame) + 22.0,
                                            48.0,
                                            48.0);
}

- (void)showEULAView {
    [self.view endEditing:YES];
    self.eulaMaskView.hidden = NO;
    [self.view bringSubviewToFront:self.eulaMaskView];
}

- (void)hideEULAView {
    self.eulaMaskView.hidden = YES;
}

- (void)eulaAgreeButtonTapped {
    self.agreementButton.selected = YES;
    [self hideEULAView];
}

- (void)setupKeyboardHandling {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.activeTextField) {
        return;
    }
    
    CGRect keyboardFrame = [self.view convertRect:[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    CGRect textFieldFrame = [self.activeTextField.superview convertRect:self.activeTextField.frame toView:self.view];
    CGFloat overlap = CGRectGetMaxY(textFieldFrame) + 16.0 - CGRectGetMinY(keyboardFrame);
    CGFloat offset = MAX(overlap, 0.0);
    
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
