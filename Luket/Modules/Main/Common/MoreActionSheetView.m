//
//  MoreActionSheetView.m
//  Luket
//

#import "MoreActionSheetView.h"

@interface MoreActionSheetView ()

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIImageView *sheetBackgroundView;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UIButton *shieldButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation MoreActionSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        
        self.dimmingView = [[UIView alloc] init];
        self.dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.58];
        [self addSubview:self.dimmingView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.dimmingView addGestureRecognizer:tapGesture];
        
        self.sheetBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MoreActionSheetBackground"]];
        self.sheetBackgroundView.contentMode = UIViewContentModeScaleToFill;
        self.sheetBackgroundView.userInteractionEnabled = YES;
        [self addSubview:self.sheetBackgroundView];
        
        self.reportButton = [self imageButtonWithImageName:@"MoreActionReportButton" action:@selector(reportButtonTapped)];
        [self.sheetBackgroundView addSubview:self.reportButton];
        
        self.shieldButton = [self imageButtonWithImageName:@"MoreActionShieldButton" action:@selector(shieldButtonTapped)];
        [self.sheetBackgroundView addSubview:self.shieldButton];
        
        self.cancelButton = [self imageButtonWithImageName:@"MoreActionCancelButton" action:@selector(dismiss)];
        [self.sheetBackgroundView addSubview:self.cancelButton];
    }
    return self;
}

- (UIButton *)imageButtonWithImageName:(NSString *)imageName action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    self.dimmingView.frame = self.bounds;
    
    CGFloat sheetHeight = 254.0;
    self.sheetBackgroundView.frame = CGRectMake(0.0, height - sheetHeight, width, sheetHeight);
    
    CGFloat buttonWidth = 255.0;
    CGFloat buttonHeight = 54.0;
    CGFloat buttonX = (width - buttonWidth) / 2.0;
    self.reportButton.frame = CGRectMake(buttonX, 45.0, buttonWidth, buttonHeight);
    self.shieldButton.frame = CGRectMake(buttonX, 110.0, buttonWidth, buttonHeight);
    self.cancelButton.frame = CGRectMake(buttonX, 175.0, 252.0, 51.0);
}

- (void)showInView:(UIView *)view {
    self.frame = view.bounds;
    self.alpha = 0.0;
    [view addSubview:self];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

- (void)reportButtonTapped {
    if (self.reportHandler) {
        self.reportHandler();
    }
    [self dismiss];
}

- (void)shieldButtonTapped {
    if (self.shieldHandler) {
        self.shieldHandler();
    }
    [self dismiss];
}

@end
