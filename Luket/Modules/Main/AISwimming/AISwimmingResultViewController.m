//
//  AISwimmingResultViewController.m
//  Luket
//

#import "AISwimmingResultViewController.h"

@interface AISwimmingResultViewController ()

@property (nonatomic, strong) UIView *topCardView;
@property (nonatomic, strong) UIView *resultContentView;
@property (nonatomic, strong) UITextView *resultTextView;

@end

@implementation AISwimmingResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}

- (void)setupViews {
    [self setupTopCard];
    [self setupResultCard];
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
}

- (void)setupResultCard {
    self.resultContentView = [[UIView alloc] init];
    [self.view addSubview:self.resultContentView];
    
    UIImageView *resultCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AISwimmingResultCard"]];
    resultCardView.tag = 1001;
    resultCardView.contentMode = UIViewContentModeScaleToFill;
    [self.resultContentView addSubview:resultCardView];
    
    self.resultTextView = [[UITextView alloc] init];
    self.resultTextView.backgroundColor = UIColor.clearColor;
    self.resultTextView.editable = NO;
    self.resultTextView.showsVerticalScrollIndicator = NO;
    self.resultTextView.textColor = [self titleColor];
    self.resultTextView.font = [UIFont systemFontOfSize:14.0];
    self.resultTextView.textContainerInset = UIEdgeInsetsZero;
    self.resultTextView.textContainer.lineFragmentPadding = 0.0;
    self.resultTextView.text = [self resultText];
    [self.resultContentView addSubview:self.resultTextView];
}

- (void)layoutViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat topY = self.view.safeAreaInsets.top + 5.0;
    CGFloat topCardWidth = MIN(340.0, width - 40.0);
    
    self.topCardView.frame = CGRectMake((width - topCardWidth) / 2.0, topY, topCardWidth, 56.0);
    
    CGFloat resultWidth = MIN(340.0, width - 40.0);
    CGFloat resultHeight = resultWidth * 674.0 / 340.0;
    CGFloat resultY = CGRectGetMaxY(self.topCardView.frame) + 5.0;
    self.resultContentView.frame = CGRectMake((width - resultWidth) / 2.0, resultY, resultWidth, MIN(resultHeight, CGRectGetHeight(self.view.bounds) - resultY));
    
    UIImageView *resultCardView = [self.resultContentView viewWithTag:1001];
    resultCardView.frame = CGRectMake(0.0, 0.0, resultWidth, resultHeight);
    
    CGFloat scale = resultWidth / 340.0;
    CGFloat textX = 38.0 * scale;
    CGFloat textY = 146.0 * scale;
    CGFloat textWidth = 266.0 * scale;
    CGFloat textHeight = CGRectGetHeight(self.resultContentView.bounds) - textY - 18.0;
    self.resultTextView.frame = CGRectMake(textX, 96, textWidth, textHeight);
    self.resultTextView.font = [UIFont systemFontOfSize:16.0 * scale];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)resultText {
    return @"Alpinestars ANDES V3 Swimming Suit:\nAlpinestars is a well-known Italian brand. This swimming suit is waterproof and thermal, made from wear-resistant and tear-resistant fabric. It follows an ergonomic design, offering adequate protection for critical areas while ensuring comfort and safety. With prices ranging from 1000-3000 yuan, it's a high-quality option for long-distance swimmers looking for durability and performance.\n\nCraft Adv Endur Swimming Suit:\nCraft's swimming suit offers some unique features. Its fabric dries quickly and wicks away moisture, while the breathable mesh design helps keep you cool. Multiple back pockets allow for convenient storage of small items, and the ergonomic design reduces water resistance. Priced between 500-1500 yuan, it's ideal for long-distance swimmers who prioritize comfort.\n\nDecathlon Long-Distance Swimming Gear:\nDecathlon's long-distance swimming gear is designed for durability and performance. It's crafted from materials that offer excellent flexibility and comfort during extended swims, making it suitable for daily training and outdoor swimming.";
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
