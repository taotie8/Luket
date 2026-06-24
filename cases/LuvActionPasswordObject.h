
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LuvDiamondClientObject.h"
#import "LuvDetailObject.h"


NS_ASSUME_NONNULL_BEGIN

@interface LuvActionPasswordObject : NSObject
@property (nonatomic, strong) LuvDetailObject *  segmentTopModel;
@property (nonatomic, strong) LuvDiamondClientObject *  idsUrlsModel;
@property (nonatomic, assign) double  dialogGroup;
@property (nonatomic, assign) long  reportPurchasing;
@property (nonatomic, assign) BOOL  customSavingHistory;
@property (nonatomic, copy) NSString *  historyField;

@end

NS_ASSUME_NONNULL_END
