//
//  ChatroomMemberView.m
//  Luket
//

#import "ChatroomMemberView.h"
#import "../../Common/LuketMediaResource.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ChatroomMemberView ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *creatorBadgeView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ChatroomMemberView

- (instancetype)initWithName:(NSString *)name showCreatorBadge:(BOOL)showCreatorBadge {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        self.avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarView.clipsToBounds = YES;
        self.avatarView.layer.cornerRadius = 30.0;
        [self addSubview:self.avatarView];

        self.creatorBadgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomCreatorBadge"]];
        self.creatorBadgeView.translatesAutoresizingMaskIntoConstraints = NO;
        self.creatorBadgeView.contentMode = UIViewContentModeScaleAspectFit;
        self.creatorBadgeView.hidden = !showCreatorBadge;
        [self addSubview:self.creatorBadgeView];

        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.nameLabel.text = name;
        self.nameLabel.textColor = [self titleColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [self titleFontWithSize:14.0];
        [self addSubview:self.nameLabel];

        [NSLayoutConstraint activateConstraints:@[
            [self.avatarView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.avatarView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.avatarView.widthAnchor constraintEqualToConstant:60.0],
            [self.avatarView.heightAnchor constraintEqualToConstant:60.0],

            [self.creatorBadgeView.centerXAnchor constraintEqualToAnchor:self.avatarView.centerXAnchor],
            [self.creatorBadgeView.bottomAnchor constraintEqualToAnchor:self.avatarView.bottomAnchor constant:15.0],
            [self.creatorBadgeView.widthAnchor constraintEqualToConstant:78.0],
            [self.creatorBadgeView.heightAnchor constraintEqualToConstant:32.0],

            [self.nameLabel.topAnchor constraintEqualToAnchor:self.creatorBadgeView.bottomAnchor constant:1.0],
            [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.nameLabel.heightAnchor constraintEqualToConstant:20.0]
        ]];
    }
    return self;
}

- (void)configureWithName:(NSString *)name avatarIdentifier:(NSString *)avatarIdentifier showCreatorBadge:(BOOL)showCreatorBadge {
    self.nameLabel.text = name ?: @"";
    self.creatorBadgeView.hidden = !showCreatorBadge;
    [self setAvatarWithIdentifier:avatarIdentifier];
}

- (void)setAvatarWithIdentifier:(NSString *)identifier {
    UIImage *placeholderImage = [UIImage imageNamed:@"HomeHeroImage"];
    UIImage *localImage = [UIImage imageNamed:identifier];
    if (localImage) {
        [self.avatarView sd_cancelCurrentImageLoad];
        self.avatarView.image = localImage;
        return;
    }

    NSURL *imageURL = [LuketMediaResource imageURLWithIdentifier:identifier];
    if (!imageURL) {
        [self.avatarView sd_cancelCurrentImageLoad];
        self.avatarView.image = placeholderImage;
        return;
    }

    [self.avatarView sd_setImageWithURL:imageURL placeholderImage:placeholderImage];
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
