//
//  ChatroomMessageCell.m
//  Luket
//

#import "ChatroomMessageCell.h"
#import "ChatroomAvatarNameView.h"
#import "ChatroomMessageBubbleView.h"

@interface ChatroomMessageCell ()

@property (nonatomic, strong) ChatroomAvatarNameView *avatarNameView;
@property (nonatomic, strong) ChatroomMessageBubbleView *bubbleView;
@property (nonatomic, strong) NSLayoutConstraint *avatarLeadingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *avatarTrailingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bubbleTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bubbleCenterYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bubbleLeadingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bubbleTrailingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bubbleTrailingToAvatarConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bubbleWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bubbleHeightConstraint;

@end

@implementation ChatroomMessageCell

+ (NSString *)reuseIdentifier {
    return @"ChatroomMessageCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.avatarNameView = [[ChatroomAvatarNameView alloc] initWithName:@""];
        [self.contentView addSubview:self.avatarNameView];

        self.bubbleView = [[ChatroomMessageBubbleView alloc] initWithText:@""];
        [self.contentView addSubview:self.bubbleView];

        self.avatarLeadingConstraint = [self.avatarNameView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20.0];
        self.avatarTrailingConstraint = [self.avatarNameView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20.0];
        self.bubbleTopConstraint = [self.bubbleView.topAnchor constraintEqualToAnchor:self.avatarNameView.topAnchor];
        self.bubbleCenterYConstraint = [self.bubbleView.centerYAnchor constraintEqualToAnchor:self.avatarNameView.centerYAnchor constant:-10.0];
        self.bubbleLeadingConstraint = [self.bubbleView.leadingAnchor constraintEqualToAnchor:self.avatarNameView.trailingAnchor constant:13.0];
        self.bubbleTrailingConstraint = [self.bubbleView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-39.0];
        self.bubbleTrailingToAvatarConstraint = [self.bubbleView.trailingAnchor constraintEqualToAnchor:self.avatarNameView.leadingAnchor constant:-12.0];
        self.bubbleWidthConstraint = [self.bubbleView.widthAnchor constraintEqualToConstant:166.0];
        self.bubbleHeightConstraint = [self.bubbleView.heightAnchor constraintEqualToConstant:56.0];

        [NSLayoutConstraint activateConstraints:@[
            [self.avatarNameView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [self.avatarNameView.widthAnchor constraintEqualToConstant:46.0],
            [self.avatarNameView.heightAnchor constraintEqualToConstant:66.0],
            self.bubbleHeightConstraint
        ]];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.avatarNameView.transform = CGAffineTransformIdentity;
}

- (void)configureWithName:(NSString *)name
                    text:(NSString *)text
                outgoing:(BOOL)outgoing
             bubbleWidth:(CGFloat)bubbleWidth
            bubbleHeight:(CGFloat)bubbleHeight {
    [self.avatarNameView configureWithName:name];
    [self.bubbleView configureWithText:text];
    self.bubbleHeightConstraint.constant = bubbleHeight;
    self.bubbleWidthConstraint.constant = bubbleWidth;

    self.avatarLeadingConstraint.active = !outgoing;
    self.avatarTrailingConstraint.active = outgoing;
    self.bubbleTopConstraint.active = !outgoing;
    self.bubbleCenterYConstraint.active = outgoing;
    self.bubbleLeadingConstraint.active = !outgoing;
    self.bubbleTrailingConstraint.active = !outgoing;
    self.bubbleTrailingToAvatarConstraint.active = outgoing;
    self.bubbleWidthConstraint.active = outgoing;
}

@end
