
#import <UIKit/UIKit.h>

#import "LuvNameView.h"


NS_ASSUME_NONNULL_BEGIN

@interface LuvBiaoChatroomView : UIView
@property (nonatomic, strong) UIButton *  lastBlackButton;
@property (nonatomic, assign) double  diamondBiaoLike;
@property (nonatomic, strong) UIView *  historyCountView;
@property (nonatomic, assign) double  generateActionContent;



-(NSDictionary *)privacySegmentBack:(NSArray *)stackSign dimmingActive:(long)dimmingActive;

@end

NS_ASSUME_NONNULL_END
