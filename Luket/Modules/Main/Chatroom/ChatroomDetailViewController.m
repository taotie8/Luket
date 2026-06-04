//
//  ChatroomDetailViewController.m
//  Luket
//

#import "ChatroomDetailViewController.h"
#import "ChatroomMemberView.h"
#import "ChatroomMessageCell.h"

@interface ChatroomDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *messagesTableView;
@property (nonatomic, strong) UIView *inputBarView;
@property (nonatomic, strong) UIButton *heartButton;
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, id> *> *messages;
@property (nonatomic, assign) BOOL liked;

@end

@implementation ChatroomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.liked = YES;
    self.messages = @[
        @{
            @"name": @"Harlan",
            @"text": @"Hey guys! Just came back from an\namazing long-distance swim.",
            @"outgoing": @NO,
            @"rowHeight": @84.0,
            @"bubbleHeight": @56.0
        },
        @{
            @"name": @"Thea",
            @"text": @"That sounds exciting! Where\ndid you go?",
            @"outgoing": @NO,
            @"rowHeight": @76.0,
            @"bubbleHeight": @58.0
        },
        @{
            @"name": @"Thea",
            @"text": @"Tell us about it now!",
            @"outgoing": @YES,
            @"rowHeight": @72.0,
            @"bubbleWidth": @166.0,
            @"bubbleHeight": @42.0
        }
    ];
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupHeader];
    [self setupInputBar];
    [self setupMessages];
    [self updateHeartButton];
}

- (void)setupHeader {
    self.headerView = [[UIView alloc] init];
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.headerView];

    UIImageView *headerBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomHeaderWave"]];
    headerBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    headerBackgroundView.contentMode = UIViewContentModeScaleToFill;
    [self.headerView addSubview:headerBackgroundView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:backButton];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = @"Journey Shares";
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [self.headerView addSubview:titleLabel];

    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.translatesAutoresizingMaskIntoConstraints = NO;
    [moreButton setImage:[[UIImage imageNamed:@"DetailMoreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.headerView addSubview:moreButton];

    UIStackView *memberStackView = [[UIStackView alloc] init];
    memberStackView.translatesAutoresizingMaskIntoConstraints = NO;
    memberStackView.axis = UILayoutConstraintAxisHorizontal;
    memberStackView.alignment = UIStackViewAlignmentTop;
    memberStackView.distribution = UIStackViewDistributionFill;
    memberStackView.spacing = 8.0;
    [self.headerView addSubview:memberStackView];

    NSArray<NSString *> *names = @[@"Harlan", @"", @"", @"", @"", @""];
    for (NSInteger index = 0; index < names.count; index++) {
        ChatroomMemberView *memberView = [[ChatroomMemberView alloc] initWithName:names[index] showCreatorBadge:index == 0];
        [memberStackView addArrangedSubview:memberView];
        [NSLayoutConstraint activateConstraints:@[
            [memberView.widthAnchor constraintEqualToConstant:60.0],
            [memberView.heightAnchor constraintEqualToConstant:index == 0 ? 95.0 : 60.0]
        ]];
        memberView.transform = index % 2 == 0 ? CGAffineTransformIdentity : CGAffineTransformMakeScale(-1.0, 1.0);
    }

    [NSLayoutConstraint activateConstraints:@[
        [self.headerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.headerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.headerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.headerView.heightAnchor constraintEqualToConstant:247],

        [headerBackgroundView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [headerBackgroundView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [headerBackgroundView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [headerBackgroundView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],

        [backButton.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:20.0],
        [backButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:6.0],
        [backButton.widthAnchor constraintEqualToConstant:44],
        [backButton.heightAnchor constraintEqualToConstant:44],

        [titleLabel.leadingAnchor constraintEqualToAnchor:backButton.trailingAnchor constant:6.0],
        [titleLabel.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor],
        [titleLabel.heightAnchor constraintEqualToConstant:27.0],

        [moreButton.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor constant:-20],
        [moreButton.centerYAnchor constraintEqualToAnchor:backButton.centerYAnchor],
        [moreButton.widthAnchor constraintEqualToConstant:32.0],
        [moreButton.heightAnchor constraintEqualToConstant:32.0],

        [memberStackView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor constant:20.0],
        [memberStackView.topAnchor constraintEqualToAnchor:backButton.bottomAnchor constant:18.0],
        [memberStackView.heightAnchor constraintEqualToConstant:100.0]
    ]];
}

- (void)setupMessages {
    self.messagesTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.messagesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.messagesTableView.backgroundColor = [self pageBackgroundColor];
    self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messagesTableView.showsVerticalScrollIndicator = NO;
    self.messagesTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.messagesTableView.contentInset = UIEdgeInsetsZero;
    self.messagesTableView.scrollIndicatorInsets = self.messagesTableView.contentInset;
    self.messagesTableView.estimatedRowHeight = 0.0;
    self.messagesTableView.estimatedSectionHeaderHeight = 0.0;
    self.messagesTableView.estimatedSectionFooterHeight = 0.0;
    if (@available(iOS 15.0, *)) {
        self.messagesTableView.sectionHeaderTopPadding = 0.0;
    }
    UIView *topSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 22.0)];
    topSpacerView.backgroundColor = [self pageBackgroundColor];
    self.messagesTableView.tableHeaderView = topSpacerView;
    self.messagesTableView.dataSource = self;
    self.messagesTableView.delegate = self;
    [self.messagesTableView registerClass:ChatroomMessageCell.class forCellReuseIdentifier:[ChatroomMessageCell reuseIdentifier]];
    [self.view addSubview:self.messagesTableView];

    [NSLayoutConstraint activateConstraints:@[
        [self.messagesTableView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        [self.messagesTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.messagesTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.messagesTableView.bottomAnchor constraintEqualToAnchor:self.inputBarView.topAnchor]
    ]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatroomMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChatroomMessageCell reuseIdentifier] forIndexPath:indexPath];
    NSDictionary<NSString *, id> *message = self.messages[indexPath.row];
    [cell configureWithName:message[@"name"]
                      text:message[@"text"]
                  outgoing:[message[@"outgoing"] boolValue]
               bubbleWidth:[message[@"bubbleWidth"] doubleValue]
              bubbleHeight:[message[@"bubbleHeight"] doubleValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messages[indexPath.row][@"rowHeight"] doubleValue];
}

- (void)setupInputBar {
    self.inputBarView = [[UIView alloc] init];
    self.inputBarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputBarView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.inputBarView];

    UIView *inputBackgroundView = [[UIView alloc] init];
    inputBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    inputBackgroundView.backgroundColor = [UIColor colorWithRed:241.0 / 255.0 green:243.0 / 255.0 blue:246.0 / 255.0 alpha:1.0];
    inputBackgroundView.layer.cornerRadius = 28.0;
    [self.inputBarView addSubview:inputBackgroundView];

    UITextField *textField = [[UITextField alloc] init];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:14.0];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Say something....."
                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.66 green:0.7 blue:0.78 alpha:1.0]}];
    [inputBackgroundView addSubview:textField];

    UIImageView *sendButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailSendButtonBackground"]];
    sendButtonView.translatesAutoresizingMaskIntoConstraints = NO;
    sendButtonView.contentMode = UIViewContentModeScaleToFill;
    [self.inputBarView addSubview:sendButtonView];

    self.heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.heartButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.heartButton addTarget:self action:@selector(heartButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.inputBarView addSubview:self.heartButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.inputBarView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.inputBarView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.inputBarView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.inputBarView.heightAnchor constraintEqualToConstant:88.0],

        [inputBackgroundView.leadingAnchor constraintEqualToAnchor:self.inputBarView.leadingAnchor constant:20.0],
        [inputBackgroundView.topAnchor constraintEqualToAnchor:self.inputBarView.topAnchor constant:8.0],
        [inputBackgroundView.trailingAnchor constraintEqualToAnchor:sendButtonView.trailingAnchor],
        [inputBackgroundView.heightAnchor constraintEqualToConstant:56.0],

        [textField.leadingAnchor constraintEqualToAnchor:inputBackgroundView.leadingAnchor constant:14.0],
        [textField.trailingAnchor constraintEqualToAnchor:sendButtonView.leadingAnchor constant:-8.0],
        [textField.topAnchor constraintEqualToAnchor:inputBackgroundView.topAnchor],
        [textField.bottomAnchor constraintEqualToAnchor:inputBackgroundView.bottomAnchor],

        [sendButtonView.trailingAnchor constraintEqualToAnchor:self.heartButton.leadingAnchor constant:-8.0],
        [sendButtonView.centerYAnchor constraintEqualToAnchor:inputBackgroundView.centerYAnchor],
        [sendButtonView.widthAnchor constraintEqualToConstant:86.0],
        [sendButtonView.heightAnchor constraintEqualToConstant:52.0],

        [self.heartButton.trailingAnchor constraintEqualToAnchor:self.inputBarView.trailingAnchor constant:-20.0],
        [self.heartButton.centerYAnchor constraintEqualToAnchor:inputBackgroundView.centerYAnchor],
        [self.heartButton.widthAnchor constraintEqualToConstant:60.0],
        [self.heartButton.heightAnchor constraintEqualToConstant:52.0]
    ]];
}

- (void)heartButtonTapped {
    self.liked = !self.liked;
    [self updateHeartButton];
}

- (void)updateHeartButton {
    NSString *imageName = self.liked ? @"ChatroomHeartSelected" : @"ChatroomHeartNormal";
    [self.heartButton setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
