//
//  DiamondRechargeCell.m
//  Luket
//

#import "DiamondRechargeCell.h"

@interface DiamondRechargeCell ()

@property (nonatomic, strong) UIImageView *diamondImageView;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIImageView *priceButtonView;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation DiamondRechargeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.contentView.layer.cornerRadius = 11.0;
        self.contentView.layer.masksToBounds = YES;
        
        self.diamondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiamondRechargeSmallIcon"]];
        self.diamondImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.diamondImageView];
        
        self.amountLabel = [[UILabel alloc] init];
        self.amountLabel.textColor = [self darkTextColor];
        self.amountLabel.font = [self titleFontWithSize:21.0];
        self.amountLabel.adjustsFontSizeToFitWidth = YES;
        self.amountLabel.minimumScaleFactor = 0.75;
        self.amountLabel.lineBreakMode = NSLineBreakByClipping;
        [self.contentView addSubview:self.amountLabel];
        
        self.priceButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiamondRechargePriceButton"]];
        self.priceButtonView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.priceButtonView];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.textColor = UIColor.whiteColor;
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.font = [self titleFontWithSize:22.0];
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.diamondImageView.frame = CGRectMake(20.0, 6.0, 46.0, 44.0);
    self.amountLabel.frame = CGRectMake(70.0, 9.0, 77.0, 34.0);
    self.priceButtonView.frame = CGRectMake(0.0, 56.0, 147.0, 42.0);
    self.priceLabel.frame = self.priceButtonView.frame;
}

- (void)configureWithAmount:(NSString *)amount price:(NSString *)price {
    self.amountLabel.text = amount;
    self.priceLabel.text = price;
}

- (UIColor *)darkTextColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
