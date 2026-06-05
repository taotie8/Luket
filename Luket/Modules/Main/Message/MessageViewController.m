//
//  MessageViewController.m
//  Luket
//

#import "MessageViewController.h"
#import "FriendChatViewController.h"

@interface MessageCell : UITableViewCell

- (void)configureWithIndex:(NSInteger)index;

@end

@interface MessageCell ()

@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *moreLabel;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageListCellBackground"]];
        self.cardImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.cardImageView];
        
        self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"MotoChat";
        self.titleLabel.textColor = [self titleColor];
        self.titleLabel.font = [self titleFontWithSize:20.0];
        [self.contentView addSubview:self.titleLabel];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.text = @"hello what are you doing?";
        self.messageLabel.textColor = [self titleColor];
        self.messageLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.messageLabel];
        
        self.moreLabel = [[UILabel alloc] init];
        self.moreLabel.text = @"⋮";
        self.moreLabel.textColor = [self titleColor];
        self.moreLabel.textAlignment = NSTextAlignmentCenter;
        self.moreLabel.font = [UIFont systemFontOfSize:34.0 weight:UIFontWeightBold];
        [self.contentView addSubview:self.moreLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat cardWidth = width - 40.0;
    
    self.cardImageView.frame = CGRectMake(20.0, 0.0, cardWidth, 73.0);
    self.avatarImageView.frame = CGRectMake(40.0, 17.0, 40.0, 40.0);
    self.avatarImageView.layer.cornerRadius = 20.0;
    self.titleLabel.frame = CGRectMake(100.0, 16.0, 170.0, 24.0);
    self.messageLabel.frame = CGRectMake(100.0, 43.0, 220.0, 22.0);
    self.moreLabel.frame = CGRectMake(width - 86.0, 12.0, 28.0, 50.0);
}

- (void)configureWithIndex:(NSInteger)index {
    self.avatarImageView.transform = CGAffineTransformMakeScale(index % 2 == 0 ? 1.0 : -1.0, 1.0);
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end

@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}

- (void)setupViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [self pageBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:MessageCell.class forCellReuseIdentifier:@"MessageCell"];
    [self.view addSubview:self.tableView];
    
    UIImageView *headerWaveView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageHeaderWave"]];
    headerWaveView.tag = 1001;
    headerWaveView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:headerWaveView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 1002;
    titleLabel.text = @"Message";
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [self.view addSubview:titleLabel];
}

- (void)layoutViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    
    UIImageView *headerWaveView = [self.view viewWithTag:1001];
    headerWaveView.frame = CGRectMake(0.0, 0.0, width, 128.0);
    
    UILabel *titleLabel = [self.view viewWithTag:1002];
    titleLabel.frame = CGRectMake(20.0, 56.0, 220.0, 34.0);
    
    self.tableView.frame = CGRectMake(0.0, 154.0, width, height - 154.0);
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.view.safeAreaInsets.bottom + 100.0, 0.0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    [cell configureWithIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 91.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendChatViewController *viewController = [[FriendChatViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
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
