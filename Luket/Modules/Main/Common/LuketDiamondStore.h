//
//  LuketDiamondStore.h
//  Luket
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSInteger const LuketAIDiamondCost;

@interface LuketDiamondStore : NSObject

+ (NSInteger)currentDiamonds;
+ (void)setCurrentDiamonds:(NSInteger)diamonds;
+ (BOOL)hasEnoughDiamondsForAI;
+ (BOOL)consumeDiamondsForAI;

@end

NS_ASSUME_NONNULL_END
