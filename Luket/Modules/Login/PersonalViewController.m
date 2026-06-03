//
//  PersonalViewController.m
//  Luket
//

#import "PersonalViewController.h"

@interface PersonalViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIView *topCardView;
@property (nonatomic, strong) UIView *formContentView;
@property (nonatomic, strong) UIImageView *formCardImageView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextView *aboutTextView;
@property (nonatomic, strong) UIButton *ageButton;
@property (nonatomic, strong) UIImageView *nextButtonImageView;
@property (nonatomic, weak) UIView *activeInputView;

@end

@implementation PersonalViewController

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
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20.0, 10.0, 32.0, 32.0);
    [backButton setImage:[UIImage imageNamed:@"AuthBackIcon"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topCardView addSubview:backButton];
    
    UILabel *titleLabel = [self titleLabelWithText:@"Personal"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0.0, 0.0, 340.0, 52.0);
    [self.topCardView addSubview:titleLabel];
    
    self.formContentView = [[UIView alloc] init];
    [self.view addSubview:self.formContentView];
    
    self.formCardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonalFormCard"]];
    self.formCardImageView.contentMode = UIViewContentModeScaleToFill;
    [self.formContentView addSubview:self.formCardImageView];
    
    [self setupFormViews];
    
    self.nextButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonalNextButton"]];
    self.nextButtonImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.nextButtonImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.nextButtonImageView];
}

- (void)setupFormViews {
    UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonalAvatarCamera"]];
    avatarImageView.frame = CGRectMake(135.0, 55.0, 70.0, 70.0);
    avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.formContentView addSubview:avatarImageView];
    
    UILabel *nameLabel = [self titleLabelWithText:@"Name"];
    nameLabel.frame = CGRectMake(21.0, 149.0, 200.0, 28.0);
    [self.formContentView addSubview:nameLabel];
    
    self.nameTextField = [self textFieldWithPlaceholder:@"Please enter"];
    self.nameTextField.frame = CGRectMake(21.0, 187.0, 308.0, 51.0);
    [self.formContentView addSubview:self.nameTextField];
    
    UILabel *aboutLabel = [self titleLabelWithText:@"About  me"];
    aboutLabel.frame = CGRectMake(26.0, 252.0, 220.0, 28.0);
    [self.formContentView addSubview:aboutLabel];
    
    self.aboutTextView = [[UITextView alloc] initWithFrame:CGRectMake(26.0, 290.0, 308.0, 92.0)];
    self.aboutTextView.backgroundColor = [UIColor colorWithRed:31.0 / 255.0 green:62.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    self.aboutTextView.layer.cornerRadius = 11.0;
    self.aboutTextView.layer.masksToBounds = YES;
    self.aboutTextView.delegate = self;
    self.aboutTextView.text = @"Please enter";
    self.aboutTextView.textColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    self.aboutTextView.font = [UIFont systemFontOfSize:16.0];
    self.aboutTextView.textContainerInset = UIEdgeInsetsMake(14.0, 12.0, 14.0, 12.0);
    [self.formContentView addSubview:self.aboutTextView];
    
    UILabel *ageLabel = [self titleLabelWithText:@"Age"];
    ageLabel.frame = CGRectMake(26.0, 406.0, 200.0, 28.0);
    [self.formContentView addSubview:ageLabel];
    
    self.ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ageButton.frame = CGRectMake(26.0, 444.0, 308.0, 41.0);
    self.ageButton.backgroundColor = [UIColor colorWithRed:31.0 / 255.0 green:62.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    self.ageButton.layer.cornerRadius = 11.0;
    self.ageButton.layer.masksToBounds = YES;
    self.ageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.ageButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 17.0, 0.0, 0.0);
    [self.ageButton setTitle:@"18" forState:UIControlStateNormal];
    [self.ageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ageButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.formContentView addSubview:self.ageButton];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonalAgeArrow"]];
    arrowImageView.frame = CGRectMake(278.0, 8.5, 24.0, 24.0);
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.ageButton addSubview:arrowImageView];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38.0, 505.0, 264.0, 44.0)];
    noticeLabel.text = @"* Access to Luket is restricted to users aged 18\nand above.";
    noticeLabel.numberOfLines = 2;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.textColor = [UIColor colorWithRed:167.0 / 255.0 green:181.0 / 255.0 blue:200.0 / 255.0 alpha:1.0];
    noticeLabel.font = [UIFont systemFontOfSize:15.0];
    [self.formContentView addSubview:noticeLabel];
}

- (void)layoutViews {
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat topCardY = self.view.safeAreaInsets.top + 5.0;
    CGFloat topCardWidth = viewWidth - 40.0;
    
    self.topCardView.frame = CGRectMake(20.0, topCardY, topCardWidth, 56.0);
    
    CGFloat cardWidth = 340.0;
    CGFloat cardHeight = 563.0;
    CGFloat cardX = (viewWidth - cardWidth) / 2.0;
    CGFloat cardY = CGRectGetMaxY(self.topCardView.frame) + 0.0;
    
    self.formContentView.frame = CGRectMake(20.0, cardY, topCardWidth, cardHeight);
    self.formCardImageView.frame = self.formContentView.bounds;
    self.nextButtonImageView.frame = CGRectMake((viewWidth - 318.0) / 2.0, CGRectGetMaxY(self.formContentView.frame) + 69.0, 318.0, 59.0);
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

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor colorWithRed:31.0 / 255.0 green:62.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
    textField.layer.cornerRadius = 11.0;
    textField.layer.masksToBounds = YES;
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
    if (!self.activeInputView) {
        return;
    }
    
    CGRect keyboardFrame = [self.view convertRect:[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    CGRect inputFrame = [self.activeInputView.superview convertRect:self.activeInputView.frame toView:self.view];
    CGFloat offset = MAX(CGRectGetMaxY(inputFrame) + 16.0 - CGRectGetMinY(keyboardFrame), 0.0);
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
        textView.textColor = [UIColor whiteColor];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = @"Please enter";
        textView.textColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
