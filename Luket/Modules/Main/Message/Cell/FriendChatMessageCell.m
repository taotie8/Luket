//
//  FriendChatMessageCell.m
//  Luket
//

#import "FriendChatMessageCell.h"

static UIEdgeInsets ChatBubbleInsets(void) {
    return UIEdgeInsetsMake(12.0, 20.0, 12.0, 20.0);
}

static UIColor *FriendChatTitleColor(void) {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

static UIColor *FriendChatBubbleColor(void) {
    return [UIColor colorWithRed:31.0 / 255.0 green:62.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
}

static UIFont *FriendChatTitleFont(CGFloat size) {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@interface ChatBubbleLabel : UILabel

@end

@implementation ChatBubbleLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = ChatBubbleInsets();
    CGRect insetBounds = UIEdgeInsetsInsetRect(bounds, insets);
    CGRect textRect = [super textRectForBounds:insetBounds limitedToNumberOfLines:numberOfLines];
    
    textRect.origin.x -= insets.left;
    textRect.origin.y -= insets.top;
    textRect.size.width += insets.left + insets.right;
    textRect.size.height += insets.top + insets.bottom;
    return textRect;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, ChatBubbleInsets())];
}

@end

@interface FriendChatMessageCell ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ChatBubbleLabel *bubbleLabel;
@property (nonatomic, assign) BOOL incoming;

@end

@implementation FriendChatMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarView.clipsToBounds = YES;
        [self.contentView addSubview:self.avatarView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = FriendChatTitleColor();
        self.nameLabel.font = FriendChatTitleFont(14.0);
        [self.contentView addSubview:self.nameLabel];
        
        self.bubbleLabel = [[ChatBubbleLabel alloc] init];
        self.bubbleLabel.backgroundColor = FriendChatBubbleColor();
        self.bubbleLabel.layer.cornerRadius = 11.0;
        self.bubbleLabel.layer.masksToBounds = YES;
        self.bubbleLabel.textColor = UIColor.whiteColor;
        self.bubbleLabel.font = [UIFont systemFontOfSize:14.0];
        self.bubbleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.bubbleLabel];
    }
    return self;
}

- (void)configureWithText:(NSString *)text name:(NSString *)name incoming:(BOOL)incoming {
    self.incoming = incoming;
    self.nameLabel.text = name;
    self.bubbleLabel.text = text;
    self.bubbleLabel.textAlignment = incoming ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    self.avatarView.transform = incoming ? CGAffineTransformIdentity : CGAffineTransformMakeScale(-1.0, 1.0);
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat avatarX = self.incoming ? 20.0 : width - 60.0;
    self.avatarView.frame = CGRectMake(avatarX, 0.0, 40.0, 40.0);
    self.avatarView.layer.cornerRadius = 20.0;
    self.nameLabel.frame = CGRectMake(avatarX, 56.0, 80.0, 20.0);
    
    CGSize bubbleSize = [self.class bubbleSizeWithText:self.bubbleLabel.text
                                                  font:self.bubbleLabel.font
                                              maxWidth:width - 96.0];
    if (!self.incoming) {
        bubbleSize.width = MAX(bubbleSize.width, 210.0);
    }
    
    CGFloat bubbleX = self.incoming ? 76.0 : avatarX - 16.0 - bubbleSize.width;
    CGFloat bubbleY = self.incoming ? 0.0 : 2.0;
    self.bubbleLabel.frame = CGRectMake(bubbleX, bubbleY, bubbleSize.width, bubbleSize.height);
}

+ (CGFloat)heightForText:(NSString *)text incoming:(BOOL)incoming width:(CGFloat)width {
    CGSize bubbleSize = [self bubbleSizeWithText:text font:[UIFont systemFontOfSize:14.0] maxWidth:width - 96.0];
    if (!incoming) {
        bubbleSize.width = MAX(bubbleSize.width, 210.0);
    }
    
    return MAX(82.0, bubbleSize.height + 24.0);
}

+ (CGSize)bubbleSizeWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    UIEdgeInsets insets = ChatBubbleInsets();
    CGFloat maxTextWidth = maxWidth - insets.left - insets.right;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maxTextWidth, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil];
    
    return CGSizeMake(ceil(rect.size.width) + insets.left + insets.right,
                      ceil(rect.size.height) + insets.top + insets.bottom);
}

@end
