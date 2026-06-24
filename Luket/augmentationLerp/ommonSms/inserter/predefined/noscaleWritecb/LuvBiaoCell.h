
#import <UIKit/UIKit.h>

@interface LuvBiaoCell : UICollectionViewCell


@property(nonatomic, assign)long  collection_flag;
@property(nonatomic, assign)NSInteger  q_products;




-(UIView *)plainFlexibleFeedContextView;


- (void)configureWithAmount:(NSString *)amount price:(NSString *)price;

@end
