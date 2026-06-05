//
//  AgreementViewController.m
//  Luket
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutAgreementViews];
}

- (void)setupViews {
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
    titleLabel.text = @"Privacy&User Agreement";
    titleLabel.textColor = [self darkTextColor];
    titleLabel.font = [self titleFontWithSize:18.0];
    [topBarView addSubview:titleLabel];
    
    UIView *cardView = [[UIView alloc] init];
    cardView.tag = 1003;
    cardView.backgroundColor = UIColor.whiteColor;
    cardView.layer.cornerRadius = 11.0;
    cardView.layer.masksToBounds = YES;
    [self.view addSubview:cardView];
    
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = UIColor.clearColor;
    self.textView.editable = NO;
    self.textView.textColor = [self darkTextColor];
    self.textView.font = [UIFont systemFontOfSize:15.0];
    self.textView.textContainerInset = UIEdgeInsetsMake(18.0, 16.0, 18.0, 16.0);
    self.textView.text = [self loadAgreementText];
    [cardView addSubview:self.textView];
}

- (void)layoutAgreementViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat safeTop = self.view.safeAreaInsets.top;
    CGFloat safeBottom = self.view.safeAreaInsets.bottom;
    CGFloat contentWidth = width - 40.0;
    
    UIView *topBarView = [self.view viewWithTag:1001];
    topBarView.frame = CGRectMake(20.0, safeTop + 5.0, contentWidth, 56.0);
    
    UILabel *titleLabel = [topBarView viewWithTag:1002];
    titleLabel.frame = CGRectMake(77.0, 0.0, contentWidth - 92.0, 56.0);
    
    UIView *cardView = [self.view viewWithTag:1003];
    cardView.frame = CGRectMake(20.0, CGRectGetMaxY(topBarView.frame) + 24.0, contentWidth, height - CGRectGetMaxY(topBarView.frame) - safeBottom - 44.0);
    
    self.textView.frame = cardView.bounds;
}

- (NSString *)loadAgreementText {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PrivacyUserAgreement" ofType:@"txt"];
    if (path.length == 0) {
        return @"";
    }
    
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return text ?: @"";
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)darkTextColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
