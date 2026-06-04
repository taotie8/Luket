//
//  ChatroomMessageBubbleView.h
//  Luket
//

#import <UIKit/UIKit.h>

@interface ChatroomMessageBubbleView : UIView

- (instancetype)initWithText:(NSString *)text;
- (void)configureWithText:(NSString *)text;

@end
