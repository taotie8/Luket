//
//  ProfileUserListCell.h
//  Luket
//

#import <UIKit/UIKit.h>
#import "../../../Data/Models/LuketModels.h"

@interface ProfileUserListCell : UITableViewCell

- (void)configureWithName:(NSString *)name actionImageName:(NSString *)imageName;
- (void)configureWithUser:(LuketUser *)user actionImageName:(NSString *)imageName;
- (UIButton *)userActionButton;

@end
