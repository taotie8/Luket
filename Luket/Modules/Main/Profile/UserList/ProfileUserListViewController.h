//
//  ProfileUserListViewController.h
//  Luket
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ProfileUserListMode) {
    ProfileUserListModeFollow,
    ProfileUserListModeFans,
    ProfileUserListModeBlacklist
};

@interface ProfileUserListViewController : UIViewController

- (instancetype)initWithMode:(ProfileUserListMode)mode;

@end
