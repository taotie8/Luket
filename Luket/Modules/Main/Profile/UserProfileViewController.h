//
//  UserProfileViewController.h
//  Luket
//

#import <UIKit/UIKit.h>
#import "../Data/Models/LuketModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserProfileViewController : UIViewController

@property (nonatomic, strong, nullable) LuketUser *profileUser;
@property (nonatomic, strong, nullable) LuketGlobalData *globalData;
@property (nonatomic, copy) NSArray<LuketPost *> *profilePosts;
@property (nonatomic, assign, getter=isFollowedByCurrentUser) BOOL followedByCurrentUser;

@end

NS_ASSUME_NONNULL_END
