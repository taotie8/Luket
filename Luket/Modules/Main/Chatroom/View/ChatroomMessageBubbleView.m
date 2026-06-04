//
//  ChatroomMessageBubbleView.m
//  Luket
//

#import "ChatroomMessageBubbleView.h"

@interface ChatroomMessageBubbleView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ChatroomMessageBubbleView

- (instancetype)initWithText:(NSString *)text {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [self titleColor];
        self.layer.cornerRadius = 8.0;

        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = text;
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:14.0];
        label.numberOfLines = 0;
        [self addSubview:label];
        self.label = label;

        [NSLayoutConstraint activateConstraints:@[
            [label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:18.0],
            [label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-14.0],
            [label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];
        [self configureWithText:text];
    }
    return self;
}

- (void)configureWithText:(NSString *)text {
    self.label.text = text;
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

@end
