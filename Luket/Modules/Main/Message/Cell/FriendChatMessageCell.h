//
//  FriendChatMessageCell.h
//  Luket
//

#import <UIKit/UIKit.h>

@interface FriendChatMessageCell : UITableViewCell

- (void)configureWithText:(NSString *)text name:(NSString *)name incoming:(BOOL)incoming;
+ (CGFloat)heightForText:(NSString *)text incoming:(BOOL)incoming width:(CGFloat)width;

@end
