//
//  AISwimmingViewController.m
//  Luket
//

#import "AISwimmingViewController.h"
#import "AISwimmingResultViewController.h"
#import "AISwimmingHistoryViewController.h"
#import "DeepSeekService.h"

static NSString * const AISwimmingPlaceholderText = @"Please describe your expectations for an\nideal cycling outfit....";
static NSString * const AISwimmingHistoryStorageKey = @"AISwimmingHistoryItems";

@interface AISwimmingViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIView *topCardView;
@property (nonatomic, strong) UIView *formContentView;
@property (nonatomic, strong) UITextView *requirementTextView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;
@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation AISwimmingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self setupLoadingView];
    [self setupKeyboardHandling];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}

- (void)setupViews {
    [self setupTopCard];
    [self setupFormCard];
    
    UIImageView *creditButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AISwimmingCreditButton"]];
    creditButtonView.tag = 1008;
    creditButtonView.contentMode = UIViewContentModeScaleAspectFit;
    creditButtonView.userInteractionEnabled = YES;
    UITapGestureRecognizer *creditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creditButtonTapped)];
    [creditButtonView addGestureRecognizer:creditTap];
    [self.view addSubview:creditButtonView];
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.0, 0.0, 230.0, 56.0)];
    titleLabel.text = @"AI Swimming";
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [self.topCardView addSubview:titleLabel];
    
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    historyButton.tag = 1001;
    [historyButton setImage:[[UIImage imageNamed:@"AISwimmingHistoryIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [historyButton addTarget:self action:@selector(historyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topCardView addSubview:historyButton];
}

- (void)setupFormCard {
    self.formContentView = [[UIView alloc] init];
    [self.view addSubview:self.formContentView];
    
    UIImageView *formCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AISwimmingFormCard"]];
    formCardView.tag = 1002;
    formCardView.contentMode = UIViewContentModeScaleToFill;
    [self.formContentView addSubview:formCardView];
    
    UILabel *requirementTitleLabel = [self titleLabelWithText:@"Enter your requirements"];
    requirementTitleLabel.tag = 1003;
    requirementTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.formContentView addSubview:requirementTitleLabel];
    
    self.requirementTextView = [[UITextView alloc] init];
    self.requirementTextView.backgroundColor = UIColor.clearColor;
    self.requirementTextView.layer.cornerRadius = 11.0;
    self.requirementTextView.layer.masksToBounds = YES;
    self.requirementTextView.delegate = self;
    self.requirementTextView.text = AISwimmingPlaceholderText;
    self.requirementTextView.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.requirementTextView.font = [UIFont systemFontOfSize:16.0];
    self.requirementTextView.textContainerInset = UIEdgeInsetsMake(15.0, 19.0, 15.0, 96.0);
    [self.formContentView addSubview:self.requirementTextView];
    
    UIImageView *decorationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AISwimmingInputDecoration"]];
    decorationView.tag = 1004;
    decorationView.contentMode = UIViewContentModeScaleAspectFit;
    [self.formContentView insertSubview:decorationView belowSubview:self.requirementTextView];
    
    UILabel *priceTitleLabel = [self titleLabelWithText:@"Price range"];
    priceTitleLabel.tag = 1005;
    [self.formContentView addSubview:priceTitleLabel];
    
    UILabel *styleTitleLabel = [self titleLabelWithText:@"Style Preference"];
    styleTitleLabel.tag = 1006;
    [self.formContentView addSubview:styleTitleLabel];
    
    [self addOptionButtonWithTitle:@"Low budget" tag:1100 selected:YES];
    [self addOptionButtonWithTitle:@"High end" tag:1101 selected:NO];
    [self addOptionButtonWithTitle:@"Medium range" tag:1102 selected:NO];
    [self addOptionButtonWithTitle:@"Fashionable" tag:1103 selected:YES];
    [self addOptionButtonWithTitle:@"Practical" tag:1104 selected:NO];
    [self addOptionButtonWithTitle:@"Sporty" tag:1105 selected:NO];
    [self addOptionButtonWithTitle:@"Vintage" tag:1106 selected:NO];
}

- (UILabel *)titleLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [self titleColor];
    label.font = [self titleFontWithSize:20.0];
    return label;
}

- (void)addOptionButtonWithTitle:(NSString *)title tag:(NSInteger)tag selected:(BOOL)selected {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    button.backgroundColor = selected ? UIColor.clearColor : [self inputColor];
    button.layer.cornerRadius = 22.0;
    button.layer.masksToBounds = YES;
    button.selected = selected;
    button.userInteractionEnabled = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [self titleFontWithSize:16.0];
    [button addTarget:self action:@selector(optionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.formContentView addSubview:button];
}

- (void)layoutViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat topY = self.view.safeAreaInsets.top + 5.0;
    CGFloat inputOffset = self.keyboardHeight > 0.0 ? -self.keyboardHeight * 0.25 : 0.0;
    
    self.topCardView.frame = CGRectMake(20.0, topY, width - 40.0, 56.0);
    UIButton *historyButton = [self.topCardView viewWithTag:1001];
    historyButton.frame = CGRectMake(CGRectGetWidth(self.topCardView.bounds) - 50.0, 12.0, 32.0, 32.0);
    
    CGFloat cardWidth = width - 40.0;
    CGFloat cardHeight = 522.0;
    CGFloat cardX = (width - cardWidth) / 2.0;
    CGFloat cardY = CGRectGetMaxY(self.topCardView.frame) + 5.0 + inputOffset;
    self.formContentView.frame = CGRectMake(20, cardY, cardWidth, cardHeight);
    
    UIImageView *formCardView = [self.formContentView viewWithTag:1002];
    formCardView.frame = self.formContentView.bounds;
    
    UILabel *requirementTitleLabel = [self.formContentView viewWithTag:1003];
    requirementTitleLabel.frame = CGRectMake(0.0, 47.0, cardWidth, 22.0);
    self.requirementTextView.frame = CGRectMake(16.0, 81.0, width - 72.0, 125.0);
    
    UIImageView *decorationView = [self.formContentView viewWithTag:1004];
    decorationView.frame = CGRectMake(16.0, 81.0, width - 72.0, 125.0);
    
    UILabel *priceTitleLabel = [self.formContentView viewWithTag:1005];
    priceTitleLabel.frame = CGRectMake(16.0, 219.0, 260.0, 22.0);
    
    UIButton *lowButton = [self.formContentView viewWithTag:1100];
    UIButton *highButton = [self.formContentView viewWithTag:1101];
    UIButton *mediumButton = [self.formContentView viewWithTag:1102];
    lowButton.frame = CGRectMake(22.0, 258.0, 140.0, 44.0);
    highButton.frame = CGRectMake(CGRectGetMaxX(lowButton.frame) + 8.0, 258.0, 136.0, 44.0);
    mediumButton.frame = CGRectMake(22.0, CGRectGetMaxY(lowButton.frame) + 8.0, 156.0, 44.0);
    
    UILabel *styleTitleLabel = [self.formContentView viewWithTag:1006];
    styleTitleLabel.frame = CGRectMake(26.0, 365.0, 280.0, 22.0);
    
    UIButton *fashionableButton = [self.formContentView viewWithTag:1103];
    UIButton *practicalButton = [self.formContentView viewWithTag:1104];
    UIButton *sportyButton = [self.formContentView viewWithTag:1105];
    UIButton *vintageButton = [self.formContentView viewWithTag:1106];
    fashionableButton.frame = CGRectMake(22.0, 399.0, 140.0, 44.0);
    practicalButton.frame = CGRectMake(CGRectGetMaxX(fashionableButton.frame) + 8.0, 399.0, 136.0, 44.0);
    sportyButton.frame = CGRectMake(22.0, CGRectGetMaxY(fashionableButton.frame) + 8.0, 116.0, 44.0);
    vintageButton.frame = CGRectMake(CGRectGetMaxX(sportyButton.frame) + 8.0, CGRectGetMinY(sportyButton.frame), 126.0, 44.0);
    
    NSArray<UIButton *> *optionButtons = @[lowButton, highButton, mediumButton, fashionableButton, practicalButton, sportyButton, vintageButton];
    for (UIButton *button in optionButtons) {
        button.layer.cornerRadius = CGRectGetHeight(button.bounds) / 2.0;
        [self updateOptionButtonStyle:button];
    }
    
    UIImageView *creditButtonView = [self.view viewWithTag:1008];
    creditButtonView.frame = CGRectMake((width - 318.0) / 2.0, CGRectGetHeight(self.view.bounds) - self.view.safeAreaInsets.bottom - 56.0, 318.0, 51.0);

    self.loadingView.frame = self.view.bounds;
    self.loadingIndicatorView.center = self.loadingView.center;
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)creditButtonTapped {
    [self.view endEditing:YES];
    if ([self currentPromptText].length == 0) {
        [self showAlertWithMessage:@"Please enter your requirements."];
        return;
    }
    [self showDiamondDialogWithEnoughDiamonds:[self hasEnoughDiamondsForAI]];
}

- (void)historyButtonTapped {
    AISwimmingHistoryViewController *viewController = [[AISwimmingHistoryViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)showDiamondDialogWithEnoughDiamonds:(BOOL)enoughDiamonds {
    [[self.view viewWithTag:1200] removeFromSuperview];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat cardWidth = MIN(335.0, width - 40.0);
    CGFloat cardHeight = cardWidth * 406.0 / 335.0;
    CGFloat cardX = (width - cardWidth) / 2.0;
    CGFloat cardY = (height - cardHeight) / 2.0 - 22.0;
    
    UIView *dialogView = [[UIView alloc] initWithFrame:self.view.bounds];
    dialogView.tag = 1200;
    dialogView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.58];
    [self.view addSubview:dialogView];
    
    NSString *cardImageName = enoughDiamonds ? @"AISwimmingDiamondConfirmCard" : @"AISwimmingInsufficientDiamondCard";
    UIImageView *cardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:cardImageName]];
    cardImageView.frame = CGRectMake(cardX, cardY, cardWidth, cardHeight);
    cardImageView.contentMode = UIViewContentModeScaleToFill;
    cardImageView.userInteractionEnabled = YES;
    [dialogView addSubview:cardImageView];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake((cardWidth - 318.0) / 2.0, cardHeight - 84.0, 318.0, 51.0);
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"AISwimmingDiamondConfirmButton"] forState:UIControlStateNormal];
    confirmButton.tag = enoughDiamonds ? 1201 : 1202;
    [confirmButton addTarget:self action:@selector(diamondConfirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cardImageView addSubview:confirmButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake((width - 48.0) / 2.0, CGRectGetMaxY(cardImageView.frame) + 22.0, 48.0, 48.0);
    [closeButton setImage:[UIImage imageNamed:@"LoginEULACloseButton"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeDiamondDialog) forControlEvents:UIControlEventTouchUpInside];
    [dialogView addSubview:closeButton];
}

- (void)diamondConfirmButtonTapped:(UIButton *)sender {
    BOOL enoughDiamonds = sender.tag == 1201;
    [self closeDiamondDialog];
    if (enoughDiamonds) {
        [self requestDeepSeekResult];
    }
}

- (void)closeDiamondDialog {
    [[self.view viewWithTag:1200] removeFromSuperview];
}

- (BOOL)hasEnoughDiamondsForAI {
    return YES;
}

- (void)requestDeepSeekResult {
    NSString *prompt = [self currentPromptText];
    if (prompt.length == 0) {
        [self showAlertWithMessage:@"Please enter your requirements."];
        return;
    }

    if (!DeepSeekService.sharedService.hasAPIKey) {
        [self showAlertWithMessage:@"DeepSeek API key is not configured."];
        return;
    }

    NSString *priceRange = [self selectedTitleForTags:@[@1100, @1101, @1102]];
    NSString *stylePreference = [self selectedTitleForTags:@[@1103, @1104, @1105, @1106]];
    [self showLoadingView];

    __weak typeof(self) weakSelf = self;
    [DeepSeekService.sharedService generateSwimmingRecommendationWithPrompt:prompt
                                                                 priceRange:priceRange
                                                            stylePreference:stylePreference
                                                                 completion:^(NSString * _Nullable responseText, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        [strongSelf hideLoadingView];
        if (error || responseText.length == 0) {
            [strongSelf showAlertWithMessage:error.localizedDescription ?: @"DeepSeek request failed."];
            return;
        }

        [strongSelf saveHistoryPrompt:prompt response:responseText];
        [strongSelf showResultPageWithPrompt:prompt response:responseText];
    }];
}

- (void)showResultPageWithPrompt:(NSString *)prompt response:(NSString *)response {
    AISwimmingResultViewController *viewController = [[AISwimmingResultViewController alloc] init];
    viewController.promptText = prompt;
    viewController.responseText = response;
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (NSString *)currentPromptText {
    NSString *text = [self.requirementTextView.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (text.length == 0 || [text hasPrefix:@"Please describe"]) {
        return @"";
    }
    return text;
}

- (NSString *)selectedTitleForTags:(NSArray<NSNumber *> *)tags {
    for (NSNumber *tagNumber in tags) {
        UIButton *button = [self.formContentView viewWithTag:tagNumber.integerValue];
        if (button.selected) {
            return [button titleForState:UIControlStateNormal] ?: @"";
        }
    }
    return @"";
}

- (void)saveHistoryPrompt:(NSString *)prompt response:(NSString *)response {
    NSMutableArray<NSDictionary<NSString *, NSString *> *> *historyItems = [[NSUserDefaults.standardUserDefaults arrayForKey:AISwimmingHistoryStorageKey] mutableCopy] ?: [NSMutableArray array];
    NSDictionary<NSString *, NSString *> *item = @{
        @"date": [self currentDateText] ?: @"",
        @"prompt": prompt ?: @"",
        @"text": response ?: @""
    };
    [historyItems insertObject:item atIndex:0];
    [NSUserDefaults.standardUserDefaults setObject:historyItems.copy forKey:AISwimmingHistoryStorageKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)currentDateText {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:NSDate.date];
}

- (void)setupLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:CGRectZero];
    self.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.45];
    self.loadingView.hidden = YES;
    [self.view addSubview:self.loadingView];

    if (@available(iOS 13.0, *)) {
        self.loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    } else {
        self.loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    self.loadingIndicatorView.color = UIColor.whiteColor;
    self.loadingIndicatorView.hidesWhenStopped = YES;
    [self.loadingView addSubview:self.loadingIndicatorView];
}

- (void)showLoadingView {
    self.loadingView.hidden = NO;
    [self.view bringSubviewToFront:self.loadingView];
    [self.loadingIndicatorView startAnimating];
}

- (void)hideLoadingView {
    [self.loadingIndicatorView stopAnimating];
    self.loadingView.hidden = YES;
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)optionButtonTapped:(UIButton *)sender {
    NSArray<NSNumber *> *optionTags = nil;
    if (sender.tag >= 1100 && sender.tag <= 1102) {
        optionTags = @[@1100, @1101, @1102];
    } else if (sender.tag >= 1103 && sender.tag <= 1106) {
        optionTags = @[@1103, @1104, @1105, @1106];
    }
    
    for (NSNumber *tagNumber in optionTags) {
        UIButton *button = [self.formContentView viewWithTag:tagNumber.integerValue];
        button.selected = button == sender;
        [self updateOptionButtonStyle:button];
    }
}

- (void)updateOptionButtonStyle:(UIButton *)button {
    CAGradientLayer *oldLayer = (CAGradientLayer *)[button.layer.sublayers firstObject];
    if ([oldLayer isKindOfClass:CAGradientLayer.class]) {
        [oldLayer removeFromSuperlayer];
    }
    
    if (!button.selected) {
        button.backgroundColor = [self inputColor];
        return;
    }
    
    button.backgroundColor = UIColor.clearColor;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = button.bounds;
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    gradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:0.0 green:207.0 / 255.0 blue:235.0 / 255.0 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.0 green:94.0 / 255.0 blue:235.0 / 255.0 alpha:1.0].CGColor
    ];
    [button.layer insertSublayer:gradientLayer atIndex:0];
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
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutViews];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardHeight = 0.0;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutViews];
    } completion:nil];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text hasPrefix:@"Please describe"]) {
        textView.text = @"";
        textView.textColor = UIColor.whiteColor;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = AISwimmingPlaceholderText;
        textView.textColor = [UIColor colorWithWhite:1.0 alpha:0.35];
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
