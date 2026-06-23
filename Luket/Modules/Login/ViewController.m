//
//  ViewController.m
//  Luket
//
//  Created by 上包666 on 2026/6/3.
//

#import "ViewController.h"
#import "SignUpViewController.h"
#import "ForgotPasswordViewController.h"
#import "../Main/Data/Service/LuketDataService.h"
#import "../Main/TabBar/MainTabBarController.h"

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
@property (nonatomic, strong) UIActivityIndicatorView *loginIndicatorView;
@property (nonatomic, weak) UITextField *activeTextField;
@property (nonatomic, assign) BOOL loggingIn;

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
    
    self.loginIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loginIndicatorView.hidesWhenStopped = YES;
    self.loginIndicatorView.color = UIColor.whiteColor;
    [self.cardContentView addSubview:self.loginIndicatorView];
    
    self.createAccountImageView = [self imageViewWithName:@"LoginCreateAccountText"];
    self.createAccountImageView.userInteractionEnabled = YES;
    self.createAccountImageView.contentMode = UIViewContentModeScaleAspectFit;
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
    imageView.contentMode = UIViewContentModeScaleToFill;
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
    
    CGFloat cardWidth = viewWidth - 34.0;
    
    CGFloat cardHeight = 463.0;
    CGFloat cardX = 17.0;
    CGFloat cardY = (viewHeight - cardHeight) / 2.0;
    
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
    self.loginIndicatorView.center = CGPointMake(CGRectGetMidX(self.loginButtonImageView.frame), CGRectGetMidY(self.loginButtonImageView.frame));
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
    
    if (self.loggingIn) {
        return;
    }
    
    NSString *email = [self trimmedText:self.emailTextField.text];
    NSString *password = [self trimmedText:self.passwordTextField.text];
    if (email.length == 0) {
        [self showAlertWithMessage:@"Please enter email address."];
        return;
    }
    if (password.length == 0) {
        [self showAlertWithMessage:@"Please enter password."];
        return;
    }
    
    [self.view endEditing:YES];
    [self setLoggingIn:YES];
    
    __weak typeof(self) weakSelf = self;
    [[LuketDataService sharedService] loginWithEmail:email password:password completion:^(LuketUser * _Nullable user, NSError * _Nullable error) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) {
            return;
        }
        
        [self setLoggingIn:NO];
        if (error) {
            [self showAlertWithMessage:@"Login failed."];
            return;
        }
        
        [self enterMainPage];
    }];
}

- (void)signUpTapped {
    if (!self.agreementButton.selected) {
        [self showEULAView];
        return;
    }

    SignUpViewController *viewController = [[SignUpViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)forgotPasswordTapped {
    ForgotPasswordViewController *viewController = [[ForgotPasswordViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)setLoggingIn:(BOOL)loggingIn {
    _loggingIn = loggingIn;
    self.loginButtonImageView.userInteractionEnabled = !loggingIn;
    self.loginButtonImageView.alpha = loggingIn ? 0.72 : 1.0;
    if (loggingIn) {
        [self.loginIndicatorView startAnimating];
    } else {
        [self.loginIndicatorView stopAnimating];
    }
}

- (NSString *)trimmedText:(NSString *)text {
    return [text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] ?: @"";
}

- (void)enterMainPage {
    UIWindow *window = self.view.window;
    MainTabBarController *tabBarController = [[MainTabBarController alloc] init];
    if (!window) {
        tabBarController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:tabBarController animated:YES completion:nil];
        return;
    }
    
    [UIView transitionWithView:window duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        window.rootViewController = tabBarController;
    } completion:nil];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
    self.eulaTextView.text = @"Terms of Use\n\n"
    @"Welcome to Luvet (the App).\n\n"
    @"By downloading, accessing, or using Luvet, you agree to these Terms of Use. If you do not agree, please discontinue use.\n\n"
    @"1. Eligibility\n\n"
    @"Luvet is intended only for users aged 18 and older.\n\n"
    @"Users under the age of 18 are strictly prohibited from creating accounts or using the App.\n\n"
    @"By registering and using Luvet, you confirm that you meet this requirement.\n\n"
    @"Luvet reserves the right to restrict, suspend, or remove accounts that violate age requirements.\n\n"
    @"2. Service Description\n\n"
    @"Luvet provides swimming-related community and creative features, including:\n\n"
    @"* Swimming-themed content sharing\n"
    @"* Posts, photos, comments, and community interactions\n"
    @"* Group chat features\n"
    @"* AI-powered swimwear recommendation features\n"
    @"* Profile and account management features\n\n"
    @"Luvet is designed for swimming interest sharing, style inspiration, and community interaction.\n\n"
    @"3. Account Registration\n\n"
    @"Users must register an account to use Luvet.\n\n"
    @"Anonymous use is not supported.\n\n"
    @"Users are responsible for maintaining account security and ensuring that the information they provide is accurate and lawful.\n\n"
    @"Users may not impersonate others or create misleading accounts.\n\n"
    @"4. User Content\n\n"
    @"Users may upload, publish, or share posts, images, text, comments, and other swimming-related content.\n\n"
    @"Users retain ownership of their content.\n\n"
    @"By publishing content in Luvet, users grant Luvet a limited, non-exclusive license to display, operate, and distribute such content within the service as necessary to provide the App.\n\n"
    @"Users are responsible for the content they upload or share.\n\n"
    @"5. Prohibited Content and Conduct\n\n"
    @"Users may not use Luvet to post, share, or promote:\n\n"
    @"* Illegal, harmful, abusive, threatening, or harassing content\n"
    @"* Sexually explicit, pornographic, or exploitative content\n"
    @"* Content involving minors in inappropriate contexts\n"
    @"* Hate speech, discrimination, or violent content\n"
    @"* Spam, scams, misleading information, or unauthorized advertising\n"
    @"* Content that infringes intellectual property rights\n"
    @"* Content that violates privacy or personal rights\n"
    @"* Any activity that disrupts, abuses, or harms the App or other users\n\n"
    @"6. Group Chat and Community Interaction\n\n"
    @"Luvet may provide group chat and community interaction features.\n\n"
    @"Users must communicate respectfully and follow community rules.\n\n"
    @"Luvet may restrict, remove, or moderate content or accounts that violate these Terms or create safety risks.\n\n"
    @"7. AI Swimwear Recommendation Feature\n\n"
    @"The AI swimwear recommendation feature is provided for inspiration and reference.\n\n"
    @"AI-generated suggestions may not always be accurate, complete, or suitable for every user.\n\n"
    @"Users remain responsible for their own decisions and use of any recommendations.\n\n"
    @"Luvet does not provide professional medical, safety, or swimming instruction advice.\n\n"
    @"8. Purchases\n\n"
    @"Some features may require in-app purchases.\n\n"
    @"Payments are processed through Apple App Store.\n\n"
    @"All purchases are subject to Apple's payment terms and policies.\n\n"
    @"9. Account Suspension and Termination\n\n"
    @"Luvet may suspend, restrict, or terminate accounts that violate these Terms, community rules, safety requirements, or applicable laws.\n\n"
    @"10. Disclaimer\n\n"
    @"Luvet is provided on an as available basis.\n\n"
    @"Luvet does not guarantee uninterrupted operation, error-free service, or the accuracy of all content and AI-generated results.\n\n"
    @"11. Limitation of Liability\n\n"
    @"To the maximum extent permitted by law, Luvet is not responsible for indirect, incidental, or consequential damages resulting from the use of the service.\n\n"
    @"12. Changes to These Terms\n\n"
    @"Luvet may update these Terms from time to time.\n\n"
    @"Continued use of the App after changes are posted indicates acceptance of the updated Terms.\n\n"
    @"13. Contact\n\n"
    @"If you have questions about these Terms, please contact us at luket666@gmail.com.";
    
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
