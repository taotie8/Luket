//
//  UserProfilePostCell.m
//  Luket
//

#import "UserProfilePostCell.h"

@interface UserProfilePostCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation UserProfilePostCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 162.0, 187.0)];
        self.containerView.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.containerView];
        
        UIImageView *frameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProfilePostCardFrame"]];
        frameImageView.frame = self.containerView.bounds;
        frameImageView.contentMode = UIViewContentModeScaleToFill;
        [self.containerView addSubview:frameImageView];
        
        self.photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.photoImageView.frame = CGRectMake(12.0, 10.0, 138.0, 116.0);
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.clipsToBounds = YES;
        self.photoImageView.layer.cornerRadius = 23.0;
        [self.containerView addSubview:self.photoImageView];
        
        self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.avatarImageView.frame = CGRectMake(15.0, 138.0, 24.0, 24.0);
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = 12.0;
        [self.containerView addSubview:self.avatarImageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(51.0, 136.0, 92.0, 38.0)];
        self.textLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        self.textLabel.textColor = [UIColor colorWithRed:0.27 green:0.39 blue:0.55 alpha:1.0];
        self.textLabel.numberOfLines = 2;
        [self.containerView addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat scale = CGRectGetWidth(self.contentView.bounds) / 162.0;
    self.containerView.bounds = CGRectMake(0.0, 0.0, 162.0, 187.0);
    self.containerView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));
    self.containerView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)configureWithText:(NSString *)text index:(NSUInteger)index {
    self.textLabel.text = text;
    self.photoImageView.transform = CGAffineTransformMakeScale(index % 2 == 0 ? 1.0 : -1.0, 1.0);
    self.avatarImageView.transform = CGAffineTransformMakeScale(index % 2 == 0 ? 1.0 : -1.0, 1.0);
}

@end
