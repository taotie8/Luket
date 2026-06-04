//
//  DetailViewController.m
//  Luket
//
//  Created by Codex on 2026/6/3.
//

#import "DetailViewController.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIView *imageFrameView;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIImageView *likeIconView;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *commentsTitleLabel;
@property (nonatomic, strong) UIView *commentInputView;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIImageView *sendButtonImageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, copy) NSArray<NSString *> *comments;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) BOOL following;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) NSInteger likeCount;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.following = YES;
    self.liked = NO;
    self.likeCount = 333;
    self.comments = @[
        @"Every time I swim, I feel ...",
        @"The water looks so peaceful.",
        @"This place is beautiful.",
        @"I want to try this next weekend."
    ];
    self.view.backgroundColor = [UIColor colorWithRed:0.19 green:0.31 blue:0.34 alpha:1.0];
    [self configureBackground];
    [self configureTableView];
    [self configureTopBar];
    [self configureImageArea];
    [self configureTextArea];
    [self configureCommentInput];
    [self configureKeyboardHandling];
    [self updateFollowButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutDetailViews];
}

- (void)layoutDetailViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat scale = width / 375.0;
    CGFloat safeTop = self.view.safeAreaInsets.top;

    CGFloat inputHeight = 56.0;
    self.tableView.frame = self.view.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, inputHeight + 41.0, 0.0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    self.topBarView.frame = CGRectMake(20.0, safeTop + 5, width - 40.0, 56.0);
    self.topBarView.layer.cornerRadius = 12.0 * scale;
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(112.0, 15.0, CGRectGetWidth(self.nameLabel.bounds), 26.0);
    self.followButton.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10.0, 16.0, 36.0, 24.0);
    self.moreButton.frame = CGRectMake(CGRectGetWidth(self.topBarView.bounds) - 12.0 - 32.0, 13.0, 32.0, 32.0);

    self.headerContentView.frame = CGRectMake(0.0, 0.0, width, 700.0 * scale);

    CGFloat imageY = safeTop + 85;
    self.imageFrameView.frame = CGRectMake(20.0 * scale, imageY, width - 40, 470.0 * scale);
    self.imageFrameView.layer.cornerRadius = 32.0 * scale;
    self.mainImageView.frame = CGRectInset(self.imageFrameView.bounds, 7.0 * scale, 7.0 * scale);
    self.mainImageView.layer.cornerRadius = 25.0 * scale;

    CGFloat likeWidth = 144.0 * scale;
    CGFloat likeHeight = 59.0 * scale;
    self.likeButton.bounds = CGRectMake(0.0, 0.0, likeWidth, likeHeight);
    self.likeButton.center = CGPointMake(CGRectGetMidX(self.imageFrameView.frame), CGRectGetMaxY(self.imageFrameView.frame) - 4.0 * scale);
    CGFloat pageWidth = 73.0 * scale;
    CGFloat pageHeight = 24.0 * scale;
    self.pageLabel.frame = CGRectMake(CGRectGetMidX(self.likeButton.frame) - pageWidth / 2.0, CGRectGetMinY(self.likeButton.frame) - 10.0 - pageHeight, pageWidth, pageHeight);
    self.pageLabel.layer.cornerRadius = 12.0 * scale;
    self.likeCountLabel.frame = CGRectMake(CGRectGetWidth(self.likeButton.bounds) - 15.0 * scale - 50.0 * scale, 17.0 * scale, 50.0 * scale, 24.0 * scale);

    self.contentLabel.frame = CGRectMake(20.0 * scale, 636.0 * scale, 300.0 * scale, 22.0 * scale);
    self.commentsTitleLabel.frame = CGRectMake(20.0 * scale, 670.0 * scale, 170.0 * scale, 24.0 * scale);
    self.tableView.tableHeaderView = self.headerContentView;

    CGFloat inputBottom = self.keyboardHeight > 0.0 ? self.keyboardHeight + 10.0 : 29.0;
    self.commentInputView.frame = CGRectMake(20.0, CGRectGetHeight(self.view.bounds) - inputHeight - inputBottom, width - 40.0, inputHeight);
    self.commentInputView.layer.cornerRadius = inputHeight / 2.0;
    self.sendButtonImageView.frame = CGRectMake(CGRectGetWidth(self.commentInputView.bounds) - 86.0, 0.0, 86.0, inputHeight);
    self.commentTextField.frame = CGRectMake(20.0, 0.0, CGRectGetMinX(self.sendButtonImageView.frame) - 30.0, inputHeight);
    self.backgroundImageView.frame = self.view.bounds;
}

- (void)configureBackground {
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailBackground"]];
    self.backgroundImageView.frame = self.view.bounds;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    [self.view addSubview:self.backgroundImageView];
}

- (void)configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"CommentCell"];
    [self.view addSubview:self.tableView];

    self.headerContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.headerContentView.backgroundColor = UIColor.clearColor;
    self.tableView.tableHeaderView = self.headerContentView;
}

- (void)configureTopBar {
    self.topBarView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topBarView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.topBarView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16.0, 0.0, 32, 56);
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:backButton];

    UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    avatarImageView.frame = CGRectMake(60.0, 8.0, 40.0, 40.0);
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.clipsToBounds = YES;
    avatarImageView.layer.cornerRadius = 20;
    [self.topBarView addSubview:avatarImageView];

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.text = @"Freya";
    self.nameLabel.textColor = [self darkTextColor];
    self.nameLabel.font = [self titleFontWithSize:20.0];
    [self.topBarView addSubview:self.nameLabel];

    self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.followButton addTarget:self action:@selector(followButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:self.followButton];

    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton setImage:[[UIImage imageNamed:@"DetailMoreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:self.moreButton];
}

- (void)configureImageArea {
    self.imageFrameView = [[UIView alloc] initWithFrame:CGRectZero];
    self.imageFrameView.backgroundColor = UIColor.whiteColor;
    self.imageFrameView.clipsToBounds = YES;
    [self.headerContentView addSubview:self.imageFrameView];

    self.mainImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.clipsToBounds = YES;
    [self.imageFrameView addSubview:self.mainImageView];

    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pageLabel.backgroundColor = UIColor.whiteColor;
    self.pageLabel.text = @"1/4";
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.textColor = [UIColor colorWithRed:0.0 green:0.63 blue:0.93 alpha:1.0];
    self.pageLabel.font = [self titleFontWithSize:21.0];
    self.pageLabel.clipsToBounds = YES;
    [self.headerContentView addSubview:self.pageLabel];

    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton.backgroundColor = UIColor.clearColor;
    [self.likeButton addTarget:self action:@selector(likeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.headerContentView addSubview:self.likeButton];

    UIImageView *likeBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailLikeBarBackground"]];
    likeBackgroundView.frame = CGRectMake(0.0, 0.0, 144.0, 59.0);
    likeBackgroundView.contentMode = UIViewContentModeScaleToFill;
    [self.likeButton addSubview:likeBackgroundView];

    self.likeIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailLikeIcon"]];
    self.likeIconView.frame = CGRectMake(24.0, 10.0, 40.0, 40.0);
    self.likeIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.likeButton addSubview:self.likeIconView];

    self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.likeCountLabel.textColor = UIColor.whiteColor;
    self.likeCountLabel.font = [self titleFontWithSize:22.0];
    [self.likeButton addSubview:self.likeCountLabel];
    [self updateLikeState];
}

- (void)configureTextArea {
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.text = @"Every time I swim, I feel passionate";
    self.contentLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.78];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    [self.headerContentView addSubview:self.contentLabel];

    self.commentsTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.commentsTitleLabel.text = @"comments";
    self.commentsTitleLabel.textColor = UIColor.whiteColor;
    self.commentsTitleLabel.font = [self titleFontWithSize:19.0];
    [self.headerContentView addSubview:self.commentsTitleLabel];
}

- (void)configureCommentInput {
    self.commentInputView = [[UIView alloc] initWithFrame:CGRectZero];
    self.commentInputView.backgroundColor = UIColor.whiteColor;
    self.commentInputView.layer.borderColor = [UIColor colorWithRed:0.86 green:0.9 blue:0.94 alpha:1.0].CGColor;
    self.commentInputView.layer.borderWidth = 1.0;
    [self.view addSubview:self.commentInputView];

    self.commentTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.commentTextField.borderStyle = UITextBorderStyleNone;
    self.commentTextField.backgroundColor = UIColor.clearColor;
    self.commentTextField.textColor = [self darkTextColor];
    self.commentTextField.font = [UIFont systemFontOfSize:13.0];
    self.commentTextField.delegate = self;
    self.commentTextField.returnKeyType = UIReturnKeyDone;
    self.commentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Every time I swim, I feel ..."
                                                                                  attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.69 green:0.75 blue:0.83 alpha:1.0]}];
    [self.commentInputView addSubview:self.commentTextField];

    self.sendButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailSendButtonBackground"]];
    self.sendButtonImageView.contentMode = UIViewContentModeScaleToFill;
    self.sendButtonImageView.userInteractionEnabled = YES;
    [self.commentInputView addSubview:self.sendButtonImageView];
}

- (void)configureKeyboardHandling {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)followButtonTapped {
    self.following = !self.following;
    [self updateFollowButton];
}

- (void)likeButtonTapped {
    self.liked = !self.liked;
    self.likeCount += self.liked ? 1 : -1;
    [self updateLikeState];
}

- (void)updateLikeState {
    NSString *imageName = self.liked ? @"DetailLikeIcon" : @"DetailSendIcon";
    self.likeIconView.image = [UIImage imageNamed:imageName];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.likeCount];
    self.likeCountLabel.alpha = self.liked ? 1.0 : 0.75;
}

- (void)updateFollowButton {
    NSString *imageName = self.following ? @"DetailFollowAddButton" : @"DetailFollowRemoveButton";
    [self.followButton setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moreButtonTapped {
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [self.view convertRect:[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    self.keyboardHeight = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(keyboardFrame);
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutDetailViews];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardHeight = 0.0;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutDetailViews];
    } completion:nil];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.clearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *avatarView = [cell.contentView viewWithTag:1001];
    if (!avatarView) {
        avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        avatarView.tag = 1001;
        avatarView.contentMode = UIViewContentModeScaleAspectFill;
        avatarView.clipsToBounds = YES;
        [cell.contentView addSubview:avatarView];
    }
    
    UILabel *commentLabel = [cell.contentView viewWithTag:1002];
    if (!commentLabel) {
        commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        commentLabel.tag = 1002;
        commentLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        commentLabel.font = [UIFont systemFontOfSize:13.0];
        [cell.contentView addSubview:commentLabel];
    }
    
    CGFloat width = CGRectGetWidth(tableView.bounds);
    CGFloat scale = width / 375.0;
    avatarView.frame = CGRectMake(20.0 * scale, 4.0, 24.0 * scale, 24.0 * scale);
    avatarView.layer.cornerRadius = 12.0 * scale;
    commentLabel.frame = CGRectMake(57.0 * scale, 6.0, width - 77.0 * scale, 20.0);
    commentLabel.text = self.comments[indexPath.row];
    
    return cell;
}

- (UIColor *)darkTextColor {
    return [UIColor colorWithRed:0.08 green:0.2 blue:0.35 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
