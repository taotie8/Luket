//
//  AccountConfirmDialogView.h
//  Luket
//

#import <UIKit/UIKit.h>

@interface AccountConfirmDialogView : UIView

@property (nonatomic, copy) void (^confirmHandler)(void);

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message confirmImageName:(NSString *)confirmImageName;
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
