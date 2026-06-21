//
//  EditProfileViewController.h
//  Luket
//

#import <UIKit/UIKit.h>
#import "../../Data/Models/LuketModels.h"

@interface EditProfileViewController : UIViewController

@property (nonatomic, strong) LuketUser *profileUser;
@property (nonatomic, strong) LuketGlobalData *globalData;
@property (nonatomic, copy) NSString *profileAboutText;

@end
