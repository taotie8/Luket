//
//  ChatroomMessageCell.h
//  Luket
//

#import <UIKit/UIKit.h>

@interface ChatroomMessageCell : UITableViewCell

+ (NSString *)reuseIdentifier;
- (void)configureWithName:(NSString *)name
                    text:(NSString *)text
                outgoing:(BOOL)outgoing
             bubbleWidth:(CGFloat)bubbleWidth
            bubbleHeight:(CGFloat)bubbleHeight;

@end
