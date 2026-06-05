//
//  MoreActionSheetView.h
//  Luket
//

#import <UIKit/UIKit.h>

@interface MoreActionSheetView : UIView

@property (nonatomic, copy) void (^reportHandler)(void);
@property (nonatomic, copy) void (^shieldHandler)(void);

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
