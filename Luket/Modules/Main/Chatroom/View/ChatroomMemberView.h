//
//  ChatroomMemberView.h
//  Luket
//

#import <UIKit/UIKit.h>

@interface ChatroomMemberView : UIView

- (instancetype)initWithName:(NSString *)name showCreatorBadge:(BOOL)showCreatorBadge;
- (void)configureWithName:(NSString *)name avatarIdentifier:(NSString *)avatarIdentifier showCreatorBadge:(BOOL)showCreatorBadge;

@end
