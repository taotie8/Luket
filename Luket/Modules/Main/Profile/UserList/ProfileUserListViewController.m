//
//  ProfileUserListViewController.m
//  Luket
//

#import "ProfileUserListViewController.h"
#import "Cell/ProfileUserListCell.h"

@interface ProfileUserListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) ProfileUserListMode mode;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *names;

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
    
    self.names = @[@"Emrys", @"Finley", @"Elowen"];
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupTopBar];
    [self setupTableView];
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileUserListCell" forIndexPath:indexPath];
    [cell configureWithName:self.names[indexPath.row] actionImageName:[self actionImageName]];
    return cell;
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
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
