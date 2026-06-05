//
//  SettingViewController.m
//  Luket
//

#import "SettingViewController.h"
#import "../Agreement/AgreementViewController.h"
#import "../Common/AccountConfirmDialogView.h"
#import "../Feedback/FeedbackViewController.h"
#import "../Profile/UserList/ProfileUserListViewController.h"

typedef NS_ENUM(NSInteger, SettingViewTag) {
    SettingViewTagTopBar = 1001,
    SettingViewTagBackButton = 1002,
    SettingViewTagTitleLabel = 1003,
    SettingViewTagPrivacyRow = 1004,
    SettingViewTagFeedbackRow = 1005,
    SettingViewTagBlacklistRow = 1006,
    SettingViewTagDeleteButton = 1007,
    SettingViewTagLogoutButton = 1008
};

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutSettingViews];
}

- (void)setupViews {
    UIView *topBarView = [[UIView alloc] init];
    topBarView.tag = SettingViewTagTopBar;
    topBarView.backgroundColor = UIColor.whiteColor;
    topBarView.layer.cornerRadius = 12.0;
    topBarView.layer.masksToBounds = YES;
    [self.view addSubview:topBarView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.tag = SettingViewTagBackButton;
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = SettingViewTagTitleLabel;
    titleLabel.text = @"Setting";
    titleLabel.textColor = [self darkTextColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [topBarView addSubview:titleLabel];
    
    UIView *privacyRow = [self rowViewWithText:@"Privacy&User Agreement" tag:SettingViewTagPrivacyRow];
    UITapGestureRecognizer *privacyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(privacyRowTapped)];
    [privacyRow addGestureRecognizer:privacyTap];
    [self.view addSubview:privacyRow];
    
    UIView *feedbackRow = [self rowViewWithText:@"Feedback" tag:SettingViewTagFeedbackRow];
    UITapGestureRecognizer *feedbackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedbackRowTapped)];
    [feedbackRow addGestureRecognizer:feedbackTap];
    [self.view addSubview:feedbackRow];
    
    UIView *blacklistRow = [self rowViewWithText:@"Blacklist" tag:SettingViewTagBlacklistRow];
    UITapGestureRecognizer *blacklistTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blacklistRowTapped)];
    [blacklistRow addGestureRecognizer:blacklistTap];
    [self.view addSubview:blacklistRow];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.tag = SettingViewTagDeleteButton;
    [deleteButton setImage:[[UIImage imageNamed:@"SettingsDeleteAccountButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.tag = SettingViewTagLogoutButton;
    [logoutButton setImage:[[UIImage imageNamed:@"SettingsLogoutButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
}

- (UIView *)rowViewWithText:(NSString *)text tag:(NSInteger)tag {
    UIView *rowView = [[UIView alloc] init];
    rowView.tag = tag;
    rowView.backgroundColor = UIColor.whiteColor;
    rowView.layer.cornerRadius = 12.0;
    rowView.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc] init];
    label.tag = 1;
    label.text = text;
    label.textColor = [self darkTextColor];
    label.font = [UIFont systemFontOfSize:17.0];
    [rowView addSubview:label];
    
    return rowView;
}

- (void)layoutSettingViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat safeTop = self.view.safeAreaInsets.top;
    CGFloat safeBottom = self.view.safeAreaInsets.bottom;
    CGFloat contentWidth = width - 40.0;
    
    UIView *topBarView = [self.view viewWithTag:SettingViewTagTopBar];
    topBarView.frame = CGRectMake(20.0, safeTop + 5.0, contentWidth, 56.0);
    
    UIButton *backButton = [topBarView viewWithTag:SettingViewTagBackButton];
    backButton.frame = CGRectMake(16.0, 0.0, 44.0, 56.0);
    
    UILabel *titleLabel = [topBarView viewWithTag:SettingViewTagTitleLabel];
    titleLabel.frame = CGRectMake(79.0, 0.0, 180.0, 56.0);
    
    CGFloat rowY = CGRectGetMaxY(topBarView.frame) + 28.0;
    NSArray<NSNumber *> *rowTags = @[
        @(SettingViewTagPrivacyRow),
        @(SettingViewTagFeedbackRow),
        @(SettingViewTagBlacklistRow)
    ];
    
    for (NSNumber *tagNumber in rowTags) {
        UIView *rowView = [self.view viewWithTag:tagNumber.integerValue];
        rowView.frame = CGRectMake(20.0, rowY, contentWidth, 52.0);
        
        UILabel *label = [rowView viewWithTag:1];
        label.frame = CGRectMake(20.0, 0.0, CGRectGetWidth(rowView.bounds) - 40.0, 52.0);
        
        rowY = CGRectGetMaxY(rowView.frame) + 8.0;
    }
    
    CGFloat buttonWidth = 255.0;
    CGFloat buttonHeight = 54.0;
    CGFloat buttonX = (width - buttonWidth) / 2.0;
    CGFloat logoutY = height - safeBottom - 128.0;
    
    UIButton *deleteButton = [self.view viewWithTag:SettingViewTagDeleteButton];
    deleteButton.frame = CGRectMake(buttonX, logoutY - buttonHeight - 8.0, buttonWidth, buttonHeight);
    
    UIButton *logoutButton = [self.view viewWithTag:SettingViewTagLogoutButton];
    logoutButton.frame = CGRectMake(buttonX, logoutY, buttonWidth, buttonHeight);
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)blacklistRowTapped {
    ProfileUserListViewController *viewController = [[ProfileUserListViewController alloc] initWithMode:ProfileUserListModeBlacklist];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)deleteButtonTapped {
    AccountConfirmDialogView *dialogView = [[AccountConfirmDialogView alloc] initWithTitle:@"Delete account?"
                                                                                   message:@"This action cannot be undone."
                                                                          confirmImageName:@"SettingsDeleteAccountButton"];
    [dialogView showInView:self.view];
}

- (void)feedbackRowTapped {
    FeedbackViewController *viewController = [[FeedbackViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)privacyRowTapped {
    AgreementViewController *viewController = [[AgreementViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)logoutButtonTapped {
    AccountConfirmDialogView *dialogView = [[AccountConfirmDialogView alloc] initWithTitle:@"Log out?"
                                                                                   message:@"You can log in again anytime."
                                                                          confirmImageName:@"SettingsLogoutButton"];
    [dialogView showInView:self.view];
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
