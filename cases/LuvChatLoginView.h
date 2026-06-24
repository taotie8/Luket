
#import <UIKit/UIKit.h>

#import "LuvReportView.h"
#import "LuvDetailObject.h"
#import "LuvMessageDelegateObject.h"
#import "LuvZhengMainView.h"


NS_ASSUME_NONNULL_BEGIN

@interface LuvChatLoginView : UIView
@property (nonatomic, assign) double  followingDisplayedMessages;
@property (nonatomic, assign) NSInteger  stringLast;
@property (nonatomic, strong) UIButton *  zhengFavoriteButton;



-(NSDictionary *)storeDismissDisappear;

-(UITableView *)refreshMessage;

-(double)currentKeyboard:(int)resourceShield coverBar:(NSArray *)coverBar;

-(double)segmentAnimate:(NSInteger)stringAmount editColor:(NSInteger)editColor;

@end

NS_ASSUME_NONNULL_END
