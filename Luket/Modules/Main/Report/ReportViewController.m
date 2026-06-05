//
//  ReportViewController.m
//  Luket
//

#import "ReportViewController.h"

@interface ReportViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) NSArray<UIButton *> *typeButtons;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) BOOL keyboardVisible;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = 0;
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self setupKeyboardHandling];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutReportViews];
}

- (void)setupViews {
    [self setupTopBar];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = UIColor.clearColor;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = UIColor.clearColor;
    [self.scrollView addSubview:self.contentView];
    
    UILabel *typeTitleLabel = [[UILabel alloc] init];
    typeTitleLabel.tag = 1001;
    typeTitleLabel.text = @"Report Type";
    typeTitleLabel.textColor = [self darkTextColor];
    typeTitleLabel.font = [self titleFontWithSize:20.0];
    [self.contentView addSubview:typeTitleLabel];
    
    NSMutableArray<UIButton *> *buttons = [NSMutableArray array];
    for (NSInteger index = 0; index < 5; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1100 + index;
        [button addTarget:self action:@selector(typeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [buttons addObject:button];
    }
    self.typeButtons = buttons;
    [self updateTypeButtons];
    
    UIImageView *formCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReportDescriptionCard"]];
    formCardView.tag = 1002;
    formCardView.contentMode = UIViewContentModeScaleToFill;
    formCardView.userInteractionEnabled = YES;
    [self.contentView addSubview:formCardView];
    
    self.descriptionTextView = [[UITextView alloc] init];
    self.descriptionTextView.backgroundColor = UIColor.clearColor;
    self.descriptionTextView.textColor = UIColor.whiteColor;
    self.descriptionTextView.font = [UIFont systemFontOfSize:14.0];
    self.descriptionTextView.delegate = self;
    self.descriptionTextView.textContainerInset = UIEdgeInsetsMake(15.0, 14.0, 15.0, 14.0);
    [formCardView addSubview:self.descriptionTextView];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = @"Supplementary description (optional)";
    self.placeholderLabel.textColor = [UIColor colorWithRed:132.0 / 255.0 green:150.0 / 255.0 blue:174.0 / 255.0 alpha:1.0];
    self.placeholderLabel.font = [UIFont systemFontOfSize:14.0];
    [formCardView addSubview:self.placeholderLabel];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.tag = 1003;
    [submitButton setBackgroundImage:[[UIImage imageNamed:@"ReportSubmitButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitButton];
}

- (void)setupTopBar {
    UIView *topBarView = [[UIView alloc] init];
    topBarView.tag = 2001;
    topBarView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topBarView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = 2002;
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 2003;
    titleLabel.text = @"Report";
    titleLabel.textColor = [self darkTextColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [topBarView addSubview:titleLabel];
}

- (void)layoutReportViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat safeTop = self.view.safeAreaInsets.top;
    
    UIView *topBarView = [self.view viewWithTag:2001];
    topBarView.frame = CGRectMake(20.0, safeTop + 5.0, width - 40.0, 56.0);
    topBarView.layer.cornerRadius = 12.0;
    
    UIButton *backButton = [topBarView viewWithTag:2002];
    backButton.frame = CGRectMake(16.0, 0.0, 44.0, 56.0);
    
    UILabel *titleLabel = [topBarView viewWithTag:2003];
    titleLabel.frame = CGRectMake(86.0, 15.0, 180.0, 26.0);
    
    CGFloat scrollTop = CGRectGetMaxY(topBarView.frame);
    self.scrollView.frame = CGRectMake(0.0, scrollTop, width, height - scrollTop);
    self.contentView.frame = CGRectMake(0.0, 0.0, width, 780.0);
    
    UILabel *typeTitleLabel = [self.contentView viewWithTag:1001];
    typeTitleLabel.frame = CGRectMake(20.0, 40.0, width - 40.0, 28.0);
    
    CGFloat itemGap = 16.0;
    CGFloat itemWidth = (width - 40.0 - itemGap) / 2.0;
    CGFloat itemHeight = 84.0;
    CGFloat firstY = 100.0;
    for (NSInteger index = 0; index < self.typeButtons.count; index++) {
        NSInteger row = index / 2;
        NSInteger column = index % 2;
        CGFloat x = 20.0 + (itemWidth + itemGap) * column;
        CGFloat y = firstY + 92.0 * row;
        self.typeButtons[index].frame = CGRectMake(x, y, itemWidth, itemHeight);
    }
    
    UIImageView *formCardView = [self.contentView viewWithTag:1002];
    CGFloat formCardWidth = width - 40.0;
    CGFloat formCardHeight = formCardWidth * 242.0 / 340.0;
    CGFloat lastButtonBottom = 0.0;
    for (UIButton *button in self.typeButtons) {
        lastButtonBottom = MAX(lastButtonBottom, CGRectGetMaxY(button.frame));
    }
    formCardView.frame = CGRectMake(20.0, lastButtonBottom + 5.0, formCardWidth, formCardHeight);
    
    self.descriptionTextView.frame = CGRectMake(16.0, 77.0, CGRectGetWidth(formCardView.bounds) - 32.0, 153.0);
    self.placeholderLabel.frame = CGRectMake(32.0, 90.0, CGRectGetWidth(formCardView.bounds) - 64.0, 20.0);
    
    UIButton *submitButton = [self.contentView viewWithTag:1003];
    submitButton.frame = CGRectMake((width - 250.0) / 2.0, CGRectGetMaxY(formCardView.frame) + 30.0, 250.0, 59.0);
    
    CGFloat contentHeight = CGRectGetMaxY(submitButton.frame) + 40.0;
    self.contentView.frame = CGRectMake(0.0, 0.0, width, contentHeight);
    self.scrollView.contentSize = CGSizeMake(width, contentHeight);
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.keyboardHeight + self.view.safeAreaInsets.bottom, 0.0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    
    if (self.keyboardVisible) {
        [self scrollDescriptionTextViewIntoViewAnimated:NO];
    }
}

- (void)typeButtonTapped:(UIButton *)sender {
    self.selectedIndex = sender.tag - 1100;
    [self updateTypeButtons];
}

- (void)updateTypeButtons {
    for (NSInteger index = 0; index < self.typeButtons.count; index++) {
        UIButton *button = self.typeButtons[index];
        BOOL selected = index == self.selectedIndex;
        NSString *imageName = selected ? [self selectedTypeImageNameAtIndex:index] : [self normalTypeImageNameAtIndex:index];
        [button setBackgroundImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}

- (NSString *)normalTypeImageNameAtIndex:(NSInteger)index {
    NSArray<NSString *> *imageNames = @[
        @"ReportHarassmentNormal",
        @"ReportMaliciousFraudNormal",
        @"ReportPornographyNormal",
        @"ReportMaliciousInsultsNormal",
        @"ReportFalseInformationNormal"
    ];
    return imageNames[index];
}

- (NSString *)selectedTypeImageNameAtIndex:(NSInteger)index {
    NSArray<NSString *> *imageNames = @[
        @"ReportHarassmentSelected",
        @"ReportMaliciousFraudSelected",
        @"ReportPornographySelected",
        @"ReportMaliciousInsultsSelected",
        @"ReportFalseInformationSelected"
    ];
    return imageNames[index];
}

- (void)submitButtonTapped {
    [self.view endEditing:YES];
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
    CGRect keyboardFrame = [self.view convertRect:[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    self.keyboardHeight = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(keyboardFrame);
    self.keyboardVisible = YES;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutReportViews];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardHeight = 0.0;
    self.keyboardVisible = NO;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutReportViews];
    } completion:nil];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self scrollDescriptionTextViewIntoViewAnimated:YES];
    return YES;
}

- (void)scrollDescriptionTextViewIntoViewAnimated:(BOOL)animated {
    UIView *formCardView = [self.contentView viewWithTag:1002];
    CGRect targetRect = [self.contentView convertRect:self.descriptionTextView.frame fromView:formCardView];
    CGFloat visibleHeight = CGRectGetHeight(self.scrollView.bounds) - self.scrollView.contentInset.bottom;
    CGFloat targetOffsetY = CGRectGetMaxY(targetRect) - visibleHeight + 20.0;
    targetOffsetY = MAX(0.0, MIN(targetOffsetY, self.scrollView.contentSize.height - visibleHeight));
    
    [self.scrollView setContentOffset:CGPointMake(0.0, targetOffsetY) animated:animated];
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)darkTextColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIColor *)darkInputColor {
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
