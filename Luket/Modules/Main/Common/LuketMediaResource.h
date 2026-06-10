//
//  LuketMediaResource.h
//  Luket
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LuketMediaResource : NSObject

+ (nullable UIImage *)localImageWithIdentifier:(nullable NSString *)identifier;
+ (nullable NSURL *)resourceURLWithIdentifier:(nullable NSString *)identifier;
+ (nullable NSURL *)imageURLWithIdentifier:(nullable NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
