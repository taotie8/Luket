//
//  EditProfileViewController.m
//  Luket
//

#import "EditProfileViewController.h"

@interface EditProfileViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIView *formContentView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextView *aboutTextView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, weak) UIView *activeInputView;
@property (nonatomic, assign) CGFloat keyboardOffset;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self setupKeyboardHandling];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutEditViews];
}

- (void)setupViews {
    [self setupTopCard];
    [self setupFormCard];
    [self setupSaveButton];
}

- (void)setupTopCard {
    UIView *topCardView = [[UIView alloc] init];
    topCardView.tag = 1001;
    topCardView.backgroundColor = UIColor.whiteColor;
    topCardView.layer.cornerRadius = 11.0;
    topCardView.layer.masksToBounds = YES;
    [self.view addSubview:topCardView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16.0, 0.0, 44.0, 56.0);
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topCardView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 1002;
    titleLabel.text = @"Edit";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [topCardView addSubview:titleLabel];
}

- (void)setupFormCard {
    self.formContentView = [[UIView alloc] init];
    [self.view addSubview:self.formContentView];
    
    UIImageView *formCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EditProfileFormCard"]];
    formCardView.tag = 1001;
    formCardView.contentMode = UIViewContentModeScaleToFill;
    [self.formContentView addSubview:formCardView];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonalAvatarCamera"]];
    avatarView.tag = 1002;
    avatarView.contentMode = UIViewContentModeScaleAspectFit;
    [self.formContentView addSubview:avatarView];
    
    UILabel *nameLabel = [self formTitleLabelWithText:@"Name"];
    nameLabel.tag = 1003;
    [self.formContentView addSubview:nameLabel];
    
    self.nameTextField = [self textFieldWithPlaceholder:@"Please enter"];
    [self.formContentView addSubview:self.nameTextField];
    
    UILabel *aboutLabel = [self formTitleLabelWithText:@"About  me"];
    aboutLabel.tag = 1004;
    [self.formContentView addSubview:aboutLabel];
    
    self.aboutTextView = [[UITextView alloc] init];
    self.aboutTextView.backgroundColor = [self inputColor];
    self.aboutTextView.layer.cornerRadius = 11.0;
    self.aboutTextView.layer.masksToBounds = YES;
    self.aboutTextView.delegate = self;
    self.aboutTextView.returnKeyType = UIReturnKeyDone;
    self.aboutTextView.text = @"Please enter";
    self.aboutTextView.textColor = [self placeholderColor];
    self.aboutTextView.font = [UIFont systemFontOfSize:14.0];
    self.aboutTextView.textContainerInset = UIEdgeInsetsMake(14.0, 16.0, 14.0, 16.0);
    [self.formContentView addSubview:self.aboutTextView];
}

- (void)setupSaveButton {
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setImage:[[UIImage imageNamed:@"EditProfileSaveButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
}

- (void)layoutEditViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat safeTop = self.view.safeAreaInsets.top;
    CGFloat safeBottom = self.view.safeAreaInsets.bottom;
    CGFloat contentWidth = width - 40.0;
    
    UIView *topCardView = [self.view viewWithTag:1001];
    topCardView.frame = CGRectMake(20.0, safeTop + 5.0, contentWidth, 56.0);
    
    UILabel *titleLabel = [topCardView viewWithTag:1002];
    titleLabel.frame = topCardView.bounds;
    
    CGFloat formHeight = contentWidth * 398.0 / 340.0;
    self.formContentView.frame = CGRectMake(20.0, CGRectGetMaxY(topCardView.frame) + 39.0, contentWidth, formHeight);
    
    UIImageView *formCardView = [self.formContentView viewWithTag:1001];
    formCardView.frame = self.formContentView.bounds;
    
    UIImageView *avatarView = [self.formContentView viewWithTag:1002];
    avatarView.frame = CGRectMake((contentWidth - 70.0) / 2.0, 36.0, 70.0, 70.0);
    
    UILabel *nameLabel = [self.formContentView viewWithTag:1003];
    nameLabel.frame = CGRectMake(20.0, 145.0, contentWidth - 40.0, 28.0);
    
    self.nameTextField.frame = CGRectMake(20.0, 184.0, contentWidth - 40.0, 41.0);
    
    UILabel *aboutLabel = [self.formContentView viewWithTag:1004];
    aboutLabel.frame = CGRectMake(20.0, 253.0, contentWidth - 40.0, 28.0);
    
    self.aboutTextView.frame = CGRectMake(20.0, 292.0, contentWidth - 40.0, 100.0);
    
    CGFloat saveWidth = 250.0;
    CGFloat saveHeight = 59.0;
    self.saveButton.frame = CGRectMake((width - saveWidth) / 2.0,
                                       height - safeBottom - saveHeight - 20.0,
                                       saveWidth,
                                       saveHeight);
    
    self.formContentView.transform = CGAffineTransformMakeTranslation(0.0, -self.keyboardOffset);
    self.saveButton.transform = CGAffineTransformMakeTranslation(0.0, -self.keyboardOffset);
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [self inputColor];
    textField.layer.cornerRadius = 11.0;
    textField.layer.masksToBounds = YES;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.textColor = UIColor.whiteColor;
    textField.font = [UIFont systemFontOfSize:14.0];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16.0, 1.0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                       attributes:@{NSForegroundColorAttributeName: [self placeholderColor]}];
    return textField;
}

- (UILabel *)formTitleLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [self titleColor];
    label.font = [self titleFontWithSize:20.0];
    return label;
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
    CGRect inputFrame = [self.activeInputView convertRect:self.activeInputView.bounds toView:self.view];
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
        [self layoutEditViews];
    } completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeInputView = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.activeInputView = textView;
    if ([textView.text isEqualToString:@"Please enter"]) {
        textView.text = @"";
        textView.textColor = UIColor.whiteColor;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = @"Please enter";
        textView.textColor = [self placeholderColor];
    }
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

- (void)saveButtonTapped {
    [self.view endEditing:YES];
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

- (UIColor *)inputColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIColor *)placeholderColor {
    return [UIColor colorWithRed:132.0 / 255.0 green:150.0 / 255.0 blue:174.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
