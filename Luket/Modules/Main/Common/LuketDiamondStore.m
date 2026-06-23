//
//  LuketDiamondStore.m
//  Luket
//

#import "LuketDiamondStore.h"

NSInteger const LuketAIDiamondCost = 300;

static NSString * const LuketDiamondBalanceStorageKey = @"LuketDiamondBalance";
static NSInteger const LuketDefaultDiamondBalance = 300;

@implementation LuketDiamondStore

+ (NSInteger)currentDiamonds {
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    if ([defaults objectForKey:LuketDiamondBalanceStorageKey] == nil) {
        return LuketDefaultDiamondBalance;
    }
    return MAX(0, [defaults integerForKey:LuketDiamondBalanceStorageKey]);
}

+ (void)setCurrentDiamonds:(NSInteger)diamonds {
    [NSUserDefaults.standardUserDefaults setInteger:MAX(0, diamonds) forKey:LuketDiamondBalanceStorageKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+ (BOOL)hasEnoughDiamondsForAI {
    return [self currentDiamonds] >= LuketAIDiamondCost;
}

+ (BOOL)consumeDiamondsForAI {
    NSInteger currentDiamonds = [self currentDiamonds];
    if (currentDiamonds < LuketAIDiamondCost) {
        return NO;
    }

    [self setCurrentDiamonds:currentDiamonds - LuketAIDiamondCost];
    return YES;
}

@end
