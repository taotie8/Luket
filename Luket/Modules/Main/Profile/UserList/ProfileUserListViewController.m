//
//  ProfileUserListViewController.m
//  Luket
//

#import "ProfileUserListViewController.h"
#import "Cell/ProfileUserListCell.h"
#import "../UserProfileViewController.h"
#import "../../Data/Service/LuketDataService.h"

@interface ProfileUserListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) ProfileUserListMode mode;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *emptyStateImageView;
@property (nonatomic, strong) LuketGlobalData *globalData;
@property (nonatomic, copy) NSArray<LuketUser *> *users;

@end

@implementation ProfileUserListViewController

- (instancetype)initWithMode:(ProfileUserListMode)mode {
    self = [super init];
    if (self) {
        _mode = mode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.users = @[];
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupTopBar];
    [self setupTableView];
    [self loadUsers];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(blockedUsersDidChange)
                                                 name:@"LuketBlockedUsersDidChangeNotification"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadUsers];
}

- (void)blockedUsersDidChange {
    [self loadUsers];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutUserListViews];
}

- (void)setupTopBar {
    UIView *topBarView = [[UIView alloc] init];
    topBarView.tag = 1001;
    topBarView.backgroundColor = UIColor.whiteColor;
    topBarView.layer.cornerRadius = 11.0;
    topBarView.layer.masksToBounds = YES;
    [self.view addSubview:topBarView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = 1002;
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 1003;
    titleLabel.text = [self pageTitle];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [self darkTextColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [topBarView addSubview:titleLabel];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 84.0;
    [self.tableView registerClass:ProfileUserListCell.class forCellReuseIdentifier:@"ProfileUserListCell"];
    [self.view addSubview:self.tableView];

    self.emptyStateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CommonEmptyState"]];
    self.emptyStateImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.emptyStateImageView.hidden = YES;
    [self.view addSubview:self.emptyStateImageView];
}

- (void)layoutUserListViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat safeTop = self.view.safeAreaInsets.top;
    
    UIView *topBarView = [self.view viewWithTag:1001];
    topBarView.frame = CGRectMake(20.0, safeTop + 5.0, width - 40.0, 56.0);
    
    UIButton *backButton = [topBarView viewWithTag:1002];
    backButton.frame = CGRectMake(16.0, 0.0, 44.0, 56.0);
    
    UILabel *titleLabel = [topBarView viewWithTag:1003];
    titleLabel.frame = topBarView.bounds;
    
    CGFloat tableY = CGRectGetMaxY(topBarView.frame) + 40.0;
    self.tableView.frame = CGRectMake(0.0, tableY, width, height - tableY);
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.view.safeAreaInsets.bottom + 20.0, 0.0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    CGFloat emptyWidth = 121.0;
    CGFloat emptyHeight = 142.0;
    CGFloat emptyY = CGRectGetMinY(self.tableView.frame) + (CGRectGetHeight(self.tableView.frame) - emptyHeight) * 0.36;
    self.emptyStateImageView.frame = CGRectMake((width - emptyWidth) / 2.0, emptyY, emptyWidth, emptyHeight);
    [self.view bringSubviewToFront:self.emptyStateImageView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileUserListCell" forIndexPath:indexPath];
    [cell configureWithUser:self.users[indexPath.row] actionImageName:[self actionImageName]];
    cell.userActionButton.tag = indexPath.row;
    [cell.userActionButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cell.userActionButton addTarget:self action:@selector(actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LuketUser *user = self.users[indexPath.row];
    if (self.mode != ProfileUserListModeBlacklist && [self currentUserBlockedUserId:user.userId]) {
        return;
    }

    UserProfileViewController *viewController = [[UserProfileViewController alloc] init];
    viewController.profileUser = user;
    viewController.globalData = self.globalData;
    viewController.profilePosts = [self postsForUserId:user.userId];
    viewController.followedByCurrentUser = [self currentUserFollowsUserId:user.userId];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadUsers {
    [[LuketDataService sharedService] loadGlobalDataIfNeededWithCompletion:^(LuketGlobalData * _Nullable globalData, NSError * _Nullable error) {
        if (error || !globalData) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.globalData = globalData;
            [self rebuildUsers];
        });
    }];
}

- (void)rebuildUsers {
    NSString *currentUserId = [self currentUserId];
    NSMutableArray<LuketUser *> *users = [NSMutableArray array];
    if (currentUserId.length == 0) {
        self.users = @[];
        [self.tableView reloadData];
        [self updateEmptyStateVisibility];
        return;
    }

    if (self.mode == ProfileUserListModeFollow) {
        for (LuketFollowRelation *relation in self.globalData.followList) {
            if ([relation.userId isEqualToString:currentUserId] && ![self currentUserBlockedUserId:relation.targetUserId]) {
                [users addObject:[self userForUserId:relation.targetUserId]];
            }
        }
    } else if (self.mode == ProfileUserListModeFans) {
        for (LuketFollowRelation *relation in self.globalData.followList) {
            if ([relation.targetUserId isEqualToString:currentUserId] && ![self currentUserBlockedUserId:relation.userId]) {
                [users addObject:[self userForUserId:relation.userId]];
            }
        }
    } else {
        for (LuketBlackRelation *relation in self.globalData.blackList) {
            if ([relation.blockUserId isEqualToString:currentUserId]) {
                [users addObject:[self userForUserId:relation.targetUserId]];
            }
        }
    }

    self.users = [self uniqueUsersFromUsers:users];
    [self.tableView reloadData];
    [self updateEmptyStateVisibility];
}

- (void)updateEmptyStateVisibility {
    self.emptyStateImageView.hidden = self.users.count > 0;
}

- (void)actionButtonTapped:(UIButton *)sender {
    if (sender.tag < 0 || sender.tag >= self.users.count || !self.globalData) {
        return;
    }

    LuketUser *user = self.users[sender.tag];
    NSString *currentUserId = [self currentUserId];
    if (currentUserId.length == 0 || user.userId.length == 0) {
        return;
    }

    NSArray<LuketFollowRelation *> *previousFollowList = self.globalData.followList.copy ?: @[];
    NSArray<LuketBlackRelation *> *previousBlackList = self.globalData.blackList.copy ?: @[];
    sender.enabled = NO;
    if (self.mode == ProfileUserListModeBlacklist) {
        [self removeBlockedUserId:user.userId currentUserId:currentUserId];
    } else if (self.mode == ProfileUserListModeFans) {
        if ([self currentUserFollowsUserId:user.userId]) {
            sender.enabled = YES;
            return;
        }
        [self updateFollowForUserId:user.userId currentUserId:currentUserId followed:YES];
    } else {
        [self updateFollowForUserId:user.userId currentUserId:currentUserId followed:NO];
    }

    [[LuketDataService sharedService] saveGlobalData:self.globalData completion:^(BOOL success, NSString *message, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
            if (!success || error) {
                self.globalData.followList = previousFollowList;
                self.globalData.blackList = previousBlackList;
                [[LuketDataService sharedService] updateCachedGlobalData:self.globalData];
                NSLog(@"[Luket] Save user list update failed: %@", error.localizedDescription ?: message);
            }
            [self rebuildUsers];
        });
    }];
}

- (void)updateFollowForUserId:(NSString *)targetUserId currentUserId:(NSString *)currentUserId followed:(BOOL)followed {
    NSMutableArray<LuketFollowRelation *> *followList = self.globalData.followList.mutableCopy ?: [NSMutableArray array];
    NSIndexSet *matchingIndexes = [followList indexesOfObjectsPassingTest:^BOOL(LuketFollowRelation *relation, NSUInteger index, BOOL *stop) {
        return [relation.userId isEqualToString:currentUserId] && [relation.targetUserId isEqualToString:targetUserId];
    }];

    if (followed) {
        if (matchingIndexes.count == 0) {
            LuketFollowRelation *relation = [LuketFollowRelation modelWithDictionary:@{
                @"userId": currentUserId,
                @"targetUserId": targetUserId,
                @"followTime": [self currentRelationTimeString]
            }];
            [followList addObject:relation];
        }
    } else if (matchingIndexes.count > 0) {
        [followList removeObjectsAtIndexes:matchingIndexes];
    }

    self.globalData.followList = followList.copy;
}

- (void)removeBlockedUserId:(NSString *)targetUserId currentUserId:(NSString *)currentUserId {
    NSMutableArray<LuketBlackRelation *> *blackList = self.globalData.blackList.mutableCopy ?: [NSMutableArray array];
    NSIndexSet *matchingIndexes = [blackList indexesOfObjectsPassingTest:^BOOL(LuketBlackRelation *relation, NSUInteger index, BOOL *stop) {
        return [relation.blockUserId isEqualToString:currentUserId] && [relation.targetUserId isEqualToString:targetUserId];
    }];
    if (matchingIndexes.count > 0) {
        [blackList removeObjectsAtIndexes:matchingIndexes];
    }
    self.globalData.blackList = blackList.copy;
}

- (NSArray<LuketUser *> *)uniqueUsersFromUsers:(NSArray<LuketUser *> *)users {
    NSMutableArray<LuketUser *> *uniqueUsers = [NSMutableArray array];
    NSMutableSet<NSString *> *seenUserIds = [NSMutableSet set];
    for (LuketUser *user in users) {
        NSString *userId = user.userId ?: @"";
        if (userId.length == 0 || [seenUserIds containsObject:userId]) {
            continue;
        }
        [seenUserIds addObject:userId];
        [uniqueUsers addObject:user];
    }
    return uniqueUsers.copy;
}

- (LuketUser *)userForUserId:(NSString *)userId {
    for (LuketUser *user in self.globalData.userList) {
        if ([user.userId isEqualToString:userId]) {
            return user;
        }
    }

    return [LuketUser modelWithDictionary:@{
        @"userId": userId ?: @"",
        @"nickname": userId.length > 0 ? userId : @"User"
    }];
}

- (NSArray<LuketPost *> *)postsForUserId:(NSString *)userId {
    if (userId.length == 0) {
        return @[];
    }

    NSMutableArray<LuketPost *> *posts = [NSMutableArray array];
    for (LuketPost *post in self.globalData.postList) {
        if ([post.publishUserId isEqualToString:userId]) {
            [posts addObject:post];
        }
    }
    return posts.copy;
}

- (BOOL)currentUserFollowsUserId:(NSString *)targetUserId {
    NSString *currentUserId = [self currentUserId];
    if (currentUserId.length == 0 || targetUserId.length == 0) {
        return NO;
    }

    for (LuketFollowRelation *relation in self.globalData.followList) {
        if ([relation.userId isEqualToString:currentUserId] && [relation.targetUserId isEqualToString:targetUserId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)currentUserBlockedUserId:(NSString *)targetUserId {
    NSString *currentUserId = [self currentUserId];
    if (currentUserId.length == 0 || targetUserId.length == 0) {
        return NO;
    }

    for (LuketBlackRelation *relation in self.globalData.blackList) {
        if ([relation.blockUserId isEqualToString:currentUserId] && [relation.targetUserId isEqualToString:targetUserId]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)currentUserId {
    LuketDataService *service = LuketDataService.sharedService;
    if (service.currentLoginUserId.length > 0) {
        return service.currentLoginUserId;
    }
    return service.currentUser.userId ?: @"";
}

- (NSString *)currentRelationTimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)pageTitle {
    if (self.mode == ProfileUserListModeFans) {
        return @"Fans";
    }
    if (self.mode == ProfileUserListModeBlacklist) {
        return @"Blacklist";
    }
    return @"Follow";
}

- (NSString *)actionImageName {
    if (self.mode == ProfileUserListModeFans) {
        return @"UserListBackButton";
    }
    if (self.mode == ProfileUserListModeBlacklist) {
        return @"UserListCancelButton";
    }
    return @"UserListUnfollowButton";
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)darkTextColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
