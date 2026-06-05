//
//  ProfileUserListCell.m
//  Luket
//

#import "ProfileUserListCell.h"

@interface ProfileUserListCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation ProfileUserListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        
        self.cardView = [[UIView alloc] init];
        self.cardView.backgroundColor = UIColor.whiteColor;
        self.cardView.layer.cornerRadius = 18.0;
        self.cardView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.cardView];
        
        self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.clipsToBounds = YES;
        [self.cardView addSubview:self.avatarImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [self darkTextColor];
        self.nameLabel.font = [self titleFontWithSize:14.0];
        [self.cardView addSubview:self.nameLabel];
        
        self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cardView addSubview:self.actionButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat cardX = 20.0;
    self.cardView.frame = CGRectMake(cardX, 0.0, width - cardX * 2.0, 70.0);
    
    self.avatarImageView.frame = CGRectMake(20.0, 15.0, 40.0, 40.0);
    self.avatarImageView.layer.cornerRadius = 20.0;
    
    self.nameLabel.frame = CGRectMake(80.0, 0.0, 115.0, 70.0);
    
    self.actionButton.frame = CGRectMake(CGRectGetWidth(self.cardView.bounds) - 112.0, 11.5, 102.0, 43.0);
}

- (void)configureWithName:(NSString *)name actionImageName:(NSString *)imageName {
    self.nameLabel.text = name;
    [self.actionButton setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (UIColor *)darkTextColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
