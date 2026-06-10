//
//  DetailViewController.h
//  Luket
//
//  Created by Codex on 2026/6/3.
//

#import <UIKit/UIKit.h>
#import "../Data/Models/LuketModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic, strong, nullable) LuketPost *post;
@property (nonatomic, strong, nullable) LuketGlobalData *globalData;
@property (nonatomic, strong, nullable) LuketUser *author;
@property (nonatomic, copy) NSArray<LuketUser *> *users;
@property (nonatomic, copy) NSArray<LuketPostComment *> *postComments;
@property (nonatomic, assign, getter=isPostLikedByCurrentUser) BOOL postLikedByCurrentUser;
@property (nonatomic, assign, getter=isAuthorFollowedByCurrentUser) BOOL authorFollowedByCurrentUser;

@end

NS_ASSUME_NONNULL_END
