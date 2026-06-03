//
//  MainTabBarController.m
//  Luket
//
//  Created by Codex on 2026/6/3.
//

#import "MainTabBarController.h"
#import "../Home/HomeViewController.h"

@interface MainTabBarController ()

@property (nonatomic, strong) UIView *customTabBarView;
@property (nonatomic, strong) NSArray<UIButton *> *tabButtons;
@property (nonatomic, strong) UIButton *createButton;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBar.hidden = YES;
    self.view.backgroundColor = [self mainBackgroundColor];
    [self configureViewControllers];
    [self configureTabBar];
    [self updateSelectedTabAtIndex:0];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat safeBottom = self.view.safeAreaInsets.bottom;
    CGFloat tabHeight = 68.0 + safeBottom;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);

    self.customTabBarView.frame = CGRectMake(0.0, height - tabHeight, width, tabHeight);

    CGFloat centerGap = 82.0;
    CGFloat itemWidth = (width - centerGap) / 4.0;
    CGFloat buttonSize = 48.0;
    CGFloat buttonY = 8.0;

    for (NSUInteger index = 0; index < self.tabButtons.count; index++) {
        CGFloat slotX = index < 2 ? itemWidth * index : itemWidth * index + centerGap;
        UIButton *button = self.tabButtons[index];
        button.frame = CGRectMake(slotX + (itemWidth - buttonSize) / 2.0, buttonY, buttonSize, buttonSize);
    }

    CGFloat createSize = 62.0;
    self.createButton.frame = CGRectMake((width - createSize) / 2.0, -17.0, createSize, createSize);
}

- (void)configureViewControllers {
    UIViewController *swimming = [[HomeViewController alloc] init];
    UIViewController *discover = [self placeholderControllerWithBackgroundColor:[UIColor colorWithRed:0.95 green:0.98 blue:1.0 alpha:1.0]];
    UIViewController *notifications = [self placeholderControllerWithBackgroundColor:[UIColor colorWithRed:0.95 green:0.98 blue:1.0 alpha:1.0]];
    UIViewController *profile = [self placeholderControllerWithBackgroundColor:[UIColor colorWithRed:0.95 green:0.98 blue:1.0 alpha:1.0]];

    self.viewControllers = @[swimming, discover, notifications, profile];
}

- (UIColor *)mainBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIViewController *)placeholderControllerWithBackgroundColor:(UIColor *)backgroundColor {
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = backgroundColor;
    return viewController;
}

- (void)configureTabBar {
    self.customTabBarView = [[UIView alloc] initWithFrame:CGRectZero];
    self.customTabBarView.backgroundColor = UIColor.whiteColor;
    self.customTabBarView.layer.cornerRadius = 22.0;
    self.customTabBarView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.customTabBarView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.08].CGColor;
    self.customTabBarView.layer.shadowOpacity = 1.0;
    self.customTabBarView.layer.shadowRadius = 14.0;
    self.customTabBarView.layer.shadowOffset = CGSizeMake(0.0, -4.0);
    [self.view addSubview:self.customTabBarView];

    NSArray<NSString *> *normalImages = @[
        @"TabSwimmingNormal",
        @"TabDiscoverNormal",
        @"TabNotificationsNormal",
        @"TabProfileNormal"
    ];
    NSArray<NSString *> *selectedImages = @[
        @"TabSwimmingSelected",
        @"TabDiscoverSelected",
        @"TabNotificationsSelected",
        @"TabProfileSelected"
    ];

    NSMutableArray<UIButton *> *buttons = [NSMutableArray arrayWithCapacity:normalImages.count];
    for (NSUInteger index = 0; index < normalImages.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        [button setImage:[[UIImage imageNamed:normalImages[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [button setImage:[[UIImage imageNamed:selectedImages[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(tabButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.customTabBarView addSubview:button];
        [buttons addObject:button];
    }

    self.tabButtons = buttons;

    self.createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.createButton setImage:[[UIImage imageNamed:@"TabCreateIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.createButton setImage:[[UIImage imageNamed:@"TabCreateIconHighlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [self.createButton addTarget:self action:@selector(createButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTabBarView addSubview:self.createButton];
}

- (void)tabButtonTapped:(UIButton *)sender {
    [self updateSelectedTabAtIndex:sender.tag];
}

- (void)createButtonTapped:(UIButton *)sender {
    sender.highlighted = NO;
}

- (void)updateSelectedTabAtIndex:(NSUInteger)index {
    if (index >= self.viewControllers.count) {
        return;
    }

    self.selectedIndex = index;
    [self.tabButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger buttonIndex, BOOL *stop) {
        button.selected = buttonIndex == index;
    }];
}

@end
