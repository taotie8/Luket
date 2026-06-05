//
//  AccountConfirmDialogView.m
//  Luket
//

#import "AccountConfirmDialogView.h"

@interface AccountConfirmDialogView ()

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, copy) NSString *confirmImageName;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation AccountConfirmDialogView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message confirmImageName:(NSString *)confirmImageName {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.titleText = title;
        self.messageText = message;
        self.confirmImageName = confirmImageName;
        self.backgroundColor = UIColor.clearColor;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.dimmingView = [[UIView alloc] init];
    self.dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.58];
    [self addSubview:self.dimmingView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.dimmingView addGestureRecognizer:tapGesture];
    
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = UIColor.whiteColor;
    self.cardView.layer.cornerRadius = 20.0;
    self.cardView.layer.masksToBounds = YES;
    [self addSubview:self.cardView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.titleText;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [self darkTextColor];
    self.titleLabel.font = [self titleFontWithSize:22.0];
    [self.cardView addSubview:self.titleLabel];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = self.messageText;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = [self mutedTextColor];
    self.messageLabel.font = [UIFont systemFontOfSize:14.0];
    self.messageLabel.numberOfLines = 0;
    [self.cardView addSubview:self.messageLabel];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setImage:[[UIImage imageNamed:self.confirmImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.confirmButton];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[[UIImage imageNamed:@"MoreActionCancelButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.cancelButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    self.dimmingView.frame = self.bounds;
    
    CGFloat cardWidth = MIN(335.0, width - 40.0);
    CGFloat cardHeight = 258.0;
    self.cardView.frame = CGRectMake((width - cardWidth) / 2.0, (height - cardHeight) / 2.0 - 18.0, cardWidth, cardHeight);
    
    self.titleLabel.frame = CGRectMake(20.0, 32.0, cardWidth - 40.0, 30.0);
    self.messageLabel.frame = CGRectMake(28.0, 75.0, cardWidth - 56.0, 42.0);
    
    CGFloat confirmWidth = 255.0;
    CGFloat confirmHeight = 54.0;
    CGFloat confirmX = (cardWidth - confirmWidth) / 2.0;
    self.confirmButton.frame = CGRectMake(confirmX, 132.0, confirmWidth, confirmHeight);
    
    CGFloat cancelWidth = 252.0;
    CGFloat cancelHeight = 51.0;
    CGFloat cancelX = (cardWidth - cancelWidth) / 2.0;
    self.cancelButton.frame = CGRectMake(cancelX, 193.0, cancelWidth, cancelHeight);
}

- (void)showInView:(UIView *)view {
    self.frame = view.bounds;
    self.alpha = 0.0;
    [view addSubview:self];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.cardView.transform = CGAffineTransformMakeScale(0.96, 0.96);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        self.cardView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.18 animations:^{
        self.alpha = 0.0;
        self.cardView.transform = CGAffineTransformMakeScale(0.98, 0.98);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

- (void)confirmButtonTapped {
    [self dismissWithCompletion:^{
        if (self.confirmHandler) {
            self.confirmHandler();
        }
    }];
}

- (UIColor *)darkTextColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIColor *)mutedTextColor {
    return [UIColor colorWithRed:91.0 / 255.0 green:118.0 / 255.0 blue:147.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
