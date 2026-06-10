//
//  UserProfilePostCell.h
//  Luket
//

#import <UIKit/UIKit.h>
#import "../../Data/Models/LuketModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserProfilePostCell : UICollectionViewCell

- (void)configureWithText:(NSString *)text index:(NSUInteger)index;
- (void)configureWithPost:(LuketPost *)post author:(nullable LuketUser *)author index:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
