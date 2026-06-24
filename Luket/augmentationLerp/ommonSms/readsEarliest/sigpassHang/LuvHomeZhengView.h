
#import <UIKit/UIKit.h>

@interface LuvHomeZhengView : UIView


@property(nonatomic, assign)double  dimmingSpace;
@property(nonatomic, assign)long  completion_idx;
@property(nonatomic, copy)NSArray *  genderMutualArr;
@property(nonatomic, assign)int  dataIndex;




-(UIImageView *)totalContextInsertItemPromptDirectionImageView;


- (instancetype)initWithText:(NSString *)text;
- (void)configureWithText:(NSString *)text;

@end
