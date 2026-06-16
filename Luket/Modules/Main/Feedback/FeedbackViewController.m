//
//  FeedbackViewController.m
//  Luket
//

#import "FeedbackViewController.h"

@interface FeedbackViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIView *formContentView;
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, assign) CGFloat keyboardOffset;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self setupKeyboardHandling];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutFeedbackViews];
}

- (void)setupViews {
    [self setupTopBar];
    [self setupFormCard];
    [self setupSubmitButton];
}

- (void)setupTopBar {
    UIView *topBarView = [[UIView alloc] init];
    topBarView.tag = 1001;
    topBarView.backgroundColor = UIColor.whiteColor;
    topBarView.layer.cornerRadius = 11.0;
    topBarView.layer.masksToBounds = YES;
    [self.view addSubview:topBarView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16.0, 0.0, 44.0, 56.0);
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 1002;
    titleLabel.text = @"Feedback";
    titleLabel.textColor = [self darkTextColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [topBarView addSubview:titleLabel];
}

- (void)setupFormCard {
    self.formContentView = [[UIView alloc] init];
    [self.view addSubview:self.formContentView];
    
    UIImageView *formCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FeedbackFormCard"]];
    formCardView.tag = 1001;
    formCardView.contentMode = UIViewContentModeScaleToFill;
    [self.formContentView addSubview:formCardView];
    
    self.feedbackTextView = [[UITextView alloc] init];
    self.feedbackTextView.backgroundColor = [self inputColor];
    self.feedbackTextView.layer.cornerRadius = 11.0;
    self.feedbackTextView.layer.masksToBounds = YES;
    self.feedbackTextView.textColor = UIColor.whiteColor;
    self.feedbackTextView.font = [UIFont systemFontOfSize:14.0];
    self.feedbackTextView.delegate = self;
    self.feedbackTextView.returnKeyType = UIReturnKeyDone;
    self.feedbackTextView.textContainerInset = UIEdgeInsetsMake(15.0, 14.0, 15.0, 14.0);
    [self.formContentView addSubview:self.feedbackTextView];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = @"Looking forward to your feedback....";
    self.placeholderLabel.textColor = [UIColor colorWithRed:132.0 / 255.0 green:150.0 / 255.0 blue:174.0 / 255.0 alpha:1.0];
    self.placeholderLabel.font = [UIFont systemFontOfSize:14.0];
    [self.formContentView addSubview:self.placeholderLabel];
}

- (void)setupSubmitButton {
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setBackgroundImage:[[UIImage imageNamed:@"ReportSubmitButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
}

- (void)layoutFeedbackViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat safeTop = self.view.safeAreaInsets.top;
    CGFloat safeBottom = self.view.safeAreaInsets.bottom;
    CGFloat contentWidth = width - 40.0;
    
    UIView *topBarView = [self.view viewWithTag:1001];
    topBarView.frame = CGRectMake(20.0, safeTop + 5.0, contentWidth, 56.0);
    
    UILabel *titleLabel = [topBarView viewWithTag:1002];
    titleLabel.frame = CGRectMake(77.0, 0.0, 180.0, 56.0);
    
    CGFloat formHeight = contentWidth * 262.0 / 340.0;
    self.formContentView.frame = CGRectMake(20.0, CGRectGetMaxY(topBarView.frame) + 40.0, contentWidth, formHeight);
    
    UIImageView *formCardView = [self.formContentView viewWithTag:1001];
    formCardView.frame = self.formContentView.bounds;
    
    self.feedbackTextView.frame = CGRectMake(20.0, 55.0, contentWidth - 40.0, 166.0);
    self.placeholderLabel.frame = CGRectMake(35.0, 70.0, contentWidth - 70.0, 20.0);
    
    CGFloat submitWidth = 250.0;
    CGFloat submitHeight = 59.0;
    self.submitButton.frame = CGRectMake((width - submitWidth) / 2.0,
                                         height - safeBottom - submitHeight - 30.0,
                                         submitWidth,
                                         submitHeight);
    
    self.formContentView.transform = CGAffineTransformMakeTranslation(0.0, -self.keyboardOffset);
    self.submitButton.transform = CGAffineTransformMakeTranslation(0.0, -self.keyboardOffset);
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
    CGRect inputFrame = [self.feedbackTextView convertRect:self.feedbackTextView.bounds toView:self.view];
    CGFloat overlap = CGRectGetMaxY(inputFrame) + 20.0 - CGRectGetMinY(keyboardFrame);
    self.keyboardOffset = MAX(overlap, 0.0);
    [self animateWithKeyboardNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardOffset = 0.0;
    [self animateWithKeyboardNotification:notification];
}

- (void)animateWithKeyboardNotification:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutFeedbackViews];
    } completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitButtonTapped {
    [self.view endEditing:YES];

    NSString *feedback = [self.feedbackTextView.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (feedback.length == 0) {
        [self showAlertWithMessage:@"Please enter your feedback."];
        return;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Feedback submitted successfully."
                                                                             message:@"Thank you for helping us improve."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)darkTextColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIColor *)inputColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
