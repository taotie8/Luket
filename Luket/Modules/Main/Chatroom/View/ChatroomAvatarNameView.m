//
//  ChatroomAvatarNameView.m
//  Luket
//

#import "ChatroomAvatarNameView.h"

@interface ChatroomAvatarNameView ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ChatroomAvatarNameView

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        avatarView.contentMode = UIViewContentModeScaleAspectFill;
        avatarView.clipsToBounds = YES;
        avatarView.layer.cornerRadius = 20.0;
        [self addSubview:avatarView];

        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        nameLabel.text = name;
        nameLabel.textColor = [self titleColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [self titleFontWithSize:12.0];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;

        [NSLayoutConstraint activateConstraints:@[
            [avatarView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [avatarView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [avatarView.widthAnchor constraintEqualToConstant:40.0],
            [avatarView.heightAnchor constraintEqualToConstant:40.0],

            [nameLabel.topAnchor constraintEqualToAnchor:avatarView.bottomAnchor constant:3.0],
            [nameLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [nameLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [nameLabel.heightAnchor constraintEqualToConstant:18.0]
        ]];
        [self configureWithName:name];
    }
    return self;
}

- (void)configureWithName:(NSString *)name {
    self.nameLabel.text = name;
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
