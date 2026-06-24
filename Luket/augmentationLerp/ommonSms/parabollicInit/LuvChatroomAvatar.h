
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LuvChatroomAvatar : NSObject


@property(nonatomic, assign)float  loginSize;
@property(nonatomic, copy)NSArray *  window_ajSize_cFollow_Array;




+(NSArray *)refreshFinishGreen:(double)prepareSelected;


+ (nullable UIImage *)localImageWithIdentifier:(nullable NSString *)identifier;
+ (nullable NSURL *)resourceURLWithIdentifier:(nullable NSString *)identifier;
+ (nullable NSURL *)imageURLWithIdentifier:(nullable NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
