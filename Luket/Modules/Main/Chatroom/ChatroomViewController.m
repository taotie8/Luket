//
//  ChatroomViewController.m
//  Luket
//

#import "ChatroomViewController.h"

typedef NS_ENUM(NSUInteger, ChatroomSegment) {
    ChatroomSegmentForYou,
    ChatroomSegmentTrending,
    ChatroomSegmentFollowing
};

@interface ChatroomRoomView : UIView

- (void)configureWithIndex:(NSInteger)index;

@end

@interface ChatroomRoomView ()

@property (nonatomic, strong) CAShapeLayer *cardLayer;
@property (nonatomic, strong) UIImageView *photoImageView;

@end

@implementation ChatroomRoomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        
        self.cardLayer = [CAShapeLayer layer];
        self.cardLayer.fillColor = [UIColor colorWithWhite:1.0 alpha:0.86].CGColor;
        self.cardLayer.strokeColor = UIColor.whiteColor.CGColor;
        self.cardLayer.lineWidth = 2.0;
        [self.layer addSublayer:self.cardLayer];
        
        UIImageView *backgroundPhotoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        backgroundPhotoView.tag = 1001;
        backgroundPhotoView.contentMode = UIViewContentModeScaleAspectFill;
        backgroundPhotoView.clipsToBounds = YES;
        backgroundPhotoView.alpha = 0.14;
        [self addSubview:backgroundPhotoView];
        
        self.photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.clipsToBounds = YES;
        [self addSubview:self.photoImageView];
        
        UIView *fadeView = [[UIView alloc] init];
        fadeView.tag = 1002;
        fadeView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.72];
        [self addSubview:fadeView];
        
        UILabel *titleLabel = [self labelWithText:@"MotoChat" fontSize:20.0 weight:UIFontWeightBold];
        titleLabel.tag = 1003;
        [self addSubview:titleLabel];
        
        UILabel *subtitleLabel = [self labelWithText:@"A cozy chat room fo..." fontSize:14.0 weight:UIFontWeightRegular];
        subtitleLabel.tag = 1004;
        [self addSubview:subtitleLabel];
        
        UIImageView *fireView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomFireIcon"]];
        fireView.tag = 1005;
        fireView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:fireView];
        
        UILabel *heatLabel = [self labelWithText:@"3.3w" fontSize:13.0 weight:UIFontWeightBold];
        heatLabel.tag = 1006;
        heatLabel.textColor = [UIColor colorWithRed:1.0 green:105.0 / 255.0 blue:103.0 / 255.0 alpha:1.0];
        [self addSubview:heatLabel];
        
        for (NSInteger index = 0; index < 3; index++) {
            UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
            avatarView.tag = 1010 + index;
            avatarView.contentMode = UIViewContentModeScaleAspectFill;
            avatarView.clipsToBounds = YES;
            [self addSubview:avatarView];
        }
        
        UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomPlusBubble"]];
        bubbleView.tag = 1020;
        bubbleView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:bubbleView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat scale = width / 335.0;
    
    self.cardLayer.frame = self.bounds;
    self.cardLayer.path = [self cardPathWithWidth:width height:height scale:scale].CGPath;
    
    UIImageView *backgroundPhotoView = [self viewWithTag:1001];
    backgroundPhotoView.frame = CGRectMake(119.0 * scale, 5.0 * scale, width - 134.0 * scale, height - 10.0 * scale);
    backgroundPhotoView.layer.cornerRadius = 10.0 * scale;
    
    self.photoImageView.frame = CGRectMake(8.0 * scale, 6.0 * scale, 112.0 * scale, height - 12.0 * scale);
    self.photoImageView.layer.cornerRadius = 12.0 * scale;
    
    UIView *fadeView = [self viewWithTag:1002];
    fadeView.frame = CGRectMake(120.0 * scale, 6.0 * scale, width - 135.0 * scale, height - 12.0 * scale);
    
    UILabel *titleLabel = [self viewWithTag:1003];
    titleLabel.frame = CGRectMake(134.0 * scale, 27.0 * scale, 128.0 * scale, 24.0 * scale);
    
    UILabel *subtitleLabel = [self viewWithTag:1004];
    subtitleLabel.frame = CGRectMake(134.0 * scale, 67.0 * scale, 150.0 * scale, 18.0 * scale);
    
    UIImageView *fireView = [self viewWithTag:1005];
    fireView.frame = CGRectMake(256.0 * scale, 24.0 * scale, 32.0 * scale, 32.0 * scale);
    
    UILabel *heatLabel = [self viewWithTag:1006];
    heatLabel.frame = CGRectMake(292.0 * scale, 31.0 * scale, 42.0 * scale, 18.0 * scale);
    
    for (NSInteger index = 0; index < 3; index++) {
        UIImageView *avatarView = [self viewWithTag:1010 + index];
        avatarView.frame = CGRectMake((135.0 + 31.0 * index) * scale, 95.0 * scale, 26.0 * scale, 26.0 * scale);
        avatarView.layer.cornerRadius = 13.0 * scale;
        avatarView.transform = CGAffineTransformMakeScale(index % 2 == 0 ? 1.0 : -1.0, 1.0);
    }
    
    UIImageView *bubbleView = [self viewWithTag:1020];
    bubbleView.frame = CGRectMake(228.0 * scale, 90.0 * scale, 51.0 * scale, 34.0 * scale);
}

- (void)configureWithIndex:(NSInteger)index {
    CGFloat shift = (index % 4) * 0.16;
    self.photoImageView.transform = CGAffineTransformMakeTranslation(-80.0 * shift, 0.0);
}

- (UIBezierPath *)cardPathWithWidth:(CGFloat)width height:(CGFloat)height scale:(CGFloat)scale {
    CGFloat inset = 3.0 * scale;
    CGFloat leftTop = 20.0 * scale;
    CGFloat side = 13.0 * scale;
    CGFloat radius = 18.0 * scale;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftTop, inset)];
    [path addLineToPoint:CGPointMake(width - leftTop - side, inset)];
    [path addQuadCurveToPoint:CGPointMake(width - side, radius) controlPoint:CGPointMake(width - side, inset)];
    [path addLineToPoint:CGPointMake(width - inset, height / 2.0)];
    [path addLineToPoint:CGPointMake(width - side, height - radius)];
    [path addQuadCurveToPoint:CGPointMake(width - leftTop - side, height - inset) controlPoint:CGPointMake(width - side, height - inset)];
    [path addLineToPoint:CGPointMake(leftTop, height - inset)];
    [path addQuadCurveToPoint:CGPointMake(side, height - radius) controlPoint:CGPointMake(side, height - inset)];
    [path addLineToPoint:CGPointMake(inset, height / 2.0)];
    [path addLineToPoint:CGPointMake(side, radius)];
    [path addQuadCurveToPoint:CGPointMake(leftTop, inset) controlPoint:CGPointMake(side, inset)];
    [path closePath];
    return path;
}

- (UILabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize weight:(UIFontWeight)weight {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    UIFont *titleFont = [UIFont fontWithName:@"PangMenZhengDao" size:fontSize];
    label.font = weight == UIFontWeightBold && titleFont ? titleFont : [UIFont systemFontOfSize:fontSize weight:weight];
    return label;
}

@end

@interface ChatroomRoomCell : UITableViewCell

- (void)configureWithIndex:(NSInteger)index;

@end

@interface ChatroomRoomCell ()

@property (nonatomic, strong) ChatroomRoomView *roomView;

@end

@implementation ChatroomRoomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.roomView = [[ChatroomRoomView alloc] init];
        [self.contentView addSubview:self.roomView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat scale = width / 375.0;
    CGFloat roomWidth = MIN(335.0 * scale, width - 40.0 * scale);
    CGFloat roomHeight = 123.0 * scale;
    self.roomView.frame = CGRectMake((width - roomWidth) / 2.0, 0.0, roomWidth, roomHeight);
}

- (void)configureWithIndex:(NSInteger)index {
    [self.roomView configureWithIndex:index];
}

@end

@interface ChatroomViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<UIButton *> *segmentButtons;
@property (nonatomic, assign) ChatroomSegment segment;

@end

@implementation ChatroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segment = ChatroomSegmentForYou;
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self updateSegmentButtons];
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
    [self.tableView registerClass:ChatroomRoomCell.class forCellReuseIdentifier:@"ChatroomRoomCell"];
    [self.view addSubview:self.tableView];
    
    UIImageView *headerWaveView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomHeaderWave"]];
    headerWaveView.tag = 1001;
    headerWaveView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:headerWaveView];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatroomTitle"]];
    titleView.tag = 1002;
    titleView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:titleView];
    
    NSArray<NSNumber *> *tags = @[@(ChatroomSegmentForYou), @(ChatroomSegmentTrending), @(ChatroomSegmentFollowing)];
    NSMutableArray<UIButton *> *buttons = [NSMutableArray arrayWithCapacity:tags.count];
    for (NSNumber *tagNumber in tags) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = tagNumber.integerValue;
        [button addTarget:self action:@selector(segmentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [buttons addObject:button];
    }
    self.segmentButtons = buttons;
    
    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createButton.tag = 1003;
    createButton.backgroundColor = [UIColor colorWithRed:0.0 green:139.0 / 255.0 blue:238.0 / 255.0 alpha:1.0];
    createButton.layer.cornerRadius = 31.0;
    createButton.layer.masksToBounds = YES;
    UIImage *createImage = [UIImage systemImageNamed:@"plus.rectangle.fill"];
    UIImageView *createIconView = [[UIImageView alloc] initWithImage:[createImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    createIconView.tag = 2001;
    createIconView.tintColor = UIColor.whiteColor;
    createIconView.contentMode = UIViewContentModeScaleAspectFit;
    [createButton addSubview:createIconView];
    
    UILabel *createLabel = [[UILabel alloc] init];
    createLabel.tag = 2002;
    createLabel.text = @"Create";
    createLabel.textColor = UIColor.whiteColor;
    createLabel.font = [UIFont fontWithName:@"PangMenZhengDao" size:16.0] ?: [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
    [createButton addSubview:createLabel];
    [self.view addSubview:createButton];
}

- (void)layoutViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat scale = width / 375.0;
    
    UIImageView *headerWaveView = [self.view viewWithTag:1001];
    headerWaveView.frame = CGRectMake(0.0, 0.0, width, 228.0 * scale);
    
    UIImageView *titleView = [self.view viewWithTag:1002];
    titleView.frame = CGRectMake(24.0 * scale, 80.0 * scale, 93.0 * scale, 22.0 * scale);
    
    NSArray<NSValue *> *buttonFrames = @[
        [NSValue valueWithCGRect:CGRectMake(25.0 * scale, 127.0 * scale, 96.0 * scale, 42.0 * scale)],
        [NSValue valueWithCGRect:CGRectMake(126.0 * scale, 127.0 * scale, 106.0 * scale, 40.0 * scale)],
        [NSValue valueWithCGRect:CGRectMake(244.0 * scale, 127.0 * scale, 111.0 * scale, 40.0 * scale)]
    ];
    for (NSInteger index = 0; index < self.segmentButtons.count; index++) {
        self.segmentButtons[index].frame = buttonFrames[index].CGRectValue;
    }
    
    CGFloat listY = 239.0 * scale;
    self.tableView.frame = CGRectMake(0.0, listY, width, height - listY);
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.view.safeAreaInsets.bottom + 112.0, 0.0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    UIButton *createButton = [self.view viewWithTag:1003];
    createButton.frame = CGRectMake(width - 136.0 * scale, height - self.view.safeAreaInsets.bottom - 145.0 * scale, 120.0 * scale, 62.0 * scale);
    createButton.layer.cornerRadius = CGRectGetHeight(createButton.bounds) / 2.0;
    
    UIImageView *createIconView = [createButton viewWithTag:2001];
    createIconView.frame = CGRectMake(24.0 * scale, 21.0 * scale, 24.0 * scale, 20.0 * scale);
    
    UILabel *createLabel = [createButton viewWithTag:2002];
    createLabel.frame = CGRectMake(58.0 * scale, 0.0, 58.0 * scale, CGRectGetHeight(createButton.bounds));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatroomRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatroomRoomCell" forIndexPath:indexPath];
    [cell configureWithIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat scale = CGRectGetWidth(tableView.bounds) / 375.0;
    return 136.0 * scale;
}

- (void)segmentButtonTapped:(UIButton *)sender {
    self.segment = sender.tag;
    [self updateSegmentButtons];
}

- (void)updateSegmentButtons {
    NSArray<NSString *> *normalImages = @[
        @"ChatroomForYouNormal",
        @"ChatroomTrendingNormal",
        @"ChatroomFollowingNormal"
    ];
    NSArray<NSString *> *selectedImages = @[
        @"ChatroomForYouSelected",
        @"ChatroomTrendingSelected",
        @"ChatroomFollowingSelected"
    ];
    
    for (NSInteger index = 0; index < self.segmentButtons.count; index++) {
        UIButton *button = self.segmentButtons[index];
        NSArray<NSString *> *images = button.tag == self.segment ? selectedImages : normalImages;
        [button setImage:[[UIImage imageNamed:images[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

@end
