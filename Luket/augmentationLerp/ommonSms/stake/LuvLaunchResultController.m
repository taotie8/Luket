#import "LuvReportCenterController.h"
#import "LuvBiaoChatroomView.h"

#import "LuvLaunchResultController.h"
#import "LuvNewsProfileController.h"


static NSString * const AISwimmingHistoryStorageKey = @"AISwimmingHistoryItems";

@interface LuvSignBiaoCell : UICollectionViewCell

- (void)configureWithDate:(NSString *)date text:(NSString *)text;

@end

@interface LuvSignBiaoCell ()


@property(nonatomic, assign)long  report_idx;
@property(nonatomic, assign)double  source_max;
@property(nonatomic, copy)NSArray *  passwordPersistPlayer_arr;
@property(nonatomic, assign)NSInteger  backSum;

@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation LuvSignBiaoCell


- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat query = CGRectGetWidth(self.contentView.bounds) / 340.0;
    self.dateLabel.frame = CGRectMake(76.0 * query, 43.0 * query, 188.0 * query, 28.0 * query);
    self.deleteButton.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 38.0 * query, 43.0 * query, 24.0 * query, 24.0 * query);
    self.contentLabel.frame = CGRectMake(25.0 * query, 82.0 * query, CGRectGetWidth(self.contentView.bounds) - 50.0 * query, 62.0 * query);
}


- (instancetype)initWithFrame:(CGRect)frame {
       long pendings = 3;
    BOOL frame_7a_ = NO;
   if (frame_7a_ && 3 > (pendings * 3)) {
      frame_7a_ = pendings >= 7;
   }

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;

        self.cardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insultsUnfollowMode"]];
       int modityD = 4;
       double modityQ = 2.0f;
          BOOL f_widthe = YES;
         volatile  BOOL displayedX = NO;
          NSArray * chatt = @[@(786), @(785)];
         modityQ += chatt.count / (MAX(3, 3));
         f_widthe = [chatt containsObject:@(modityQ)];
         modityD += (int)modityQ + 3;
         modityQ += (int)modityQ / 3;
         modityD |= 3 / (MAX(modityD, 7));
      do {
         volatile  char cachedZCopy[] = {35,80,(char)-16,(char)-49,74,(char)-69};
          char* cachedZ = (char*)cachedZCopy;
          char t_badgeG[] = {(char)-52,(char)-42,(char)-10,106,118,75};
          unsigned char messagesV[] = {166,125,10,162,94,161,193,234,59,163};
         modityQ += (int)modityQ;
         int agreements = sizeof(cachedZ) / sizeof(cachedZ[0]);
         cachedZ[1] /= MAX(3, agreements);
         NSInteger icon2 = sizeof(t_badgeG) / sizeof(t_badgeG[0]);
         t_badgeG[4] += icon2;
         messagesV[7] &= (int)modityQ | 3;
         if (modityQ == 1159390.f) {
            break;
         }
      } while ((modityQ == 1159390.f) && (1 < (modityD << (MIN(labs(3), 1))) && (3 ^ modityD) < 5));
         modityQ += modityD % 1;
      frame_7a_ = 88.24f >= modityQ;
        self.cardImageView.frame = self.contentView.bounds;
        self.cardImageView.contentMode = UIViewContentModeScaleToFill;
        self.cardImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.cardImageView];

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [self titleColor];
        self.dateLabel.font = [self titleFontWithSize:21.0];
        [self.contentView addSubview:self.dateLabel];

        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.contentLabel.textColor = [self titleColor];
        self.contentLabel.font = [UIFont systemFontOfSize:16.0];
        self.contentLabel.numberOfLines = 3;
        [self.contentView addSubview:self.contentLabel];

        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[[UIImage imageNamed:@"genderKeyboard"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

-(NSArray *)willSelectLineSessionBlue:(NSDictionary *)editLeading cameraBlack:(int)cameraBlack areaLogging:(NSDictionary *)areaLogging {
    NSInteger bottom5 = 2;
   volatile  long detail5 = 3;
    NSArray * areaT = @[@(592), @(924)];
      detail5 /= MAX(1 * detail5, 1);
   if (areaT.count < detail5) {
      detail5 &= areaT.count;
   }
      detail5 ^= 2 + areaT.count;
      volatile  unsigned char avatarlOld[] = {188,233,120,61,221,18,51,8,156,193};
       unsigned char* avatarl = (unsigned char*)avatarlOld;
          int pricesK = 3;
         NSInteger keyboardw = sizeof(avatarl) / sizeof(avatarl[0]);
         avatarl[MAX(5, pricesK % 10)] |= keyboardw;
       int postsx = 4;
      volatile  int baset = 0;
         postsx += baset;
      bottom5 >>= MIN(labs(3 * bottom5), 1);
   return areaT;

}






- (UIFont *)titleFontWithSize:(CGFloat)size {

         {
NSArray * thresNoindexCopy = [self willSelectLineSessionBlue:@{[NSString stringWithUTF8String:(char []){49,0}]:[NSString stringWithUTF8String:(char []){66,0}], [NSString stringWithUTF8String:(char []){71,0}]:[NSString stringWithUTF8String:(char []){72,0}]} cameraBlack:48 areaLogging:@{[NSString stringWithUTF8String:(char []){109,111,110,116,104,115,0}]:[NSString stringWithUTF8String:(char []){114,101,113,117,101,115,116,101,114,0}]}];
NSArray * thresNoindex = (NSArray *)thresNoindexCopy;

      [thresNoindex enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          if (idx == 70) {
              NSLog(@"default_7:%@", obj);
        }
      }];
      int thresNoindex_len = thresNoindex.count;


}

       NSInteger delegate_8nU = 5;
      delegate_8nU /= MAX(3, 5);

    UIFont *delegate_xk = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return delegate_xk ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

-(int)emptyReceiveLimitedTaskVertical:(NSInteger)drawAvatar requestType_ve:(BOOL)requestType_ve customModity:(NSDictionary *)customModity {
    NSString * commentsx = [NSString stringWithUTF8String:(char []){97,97,114,99,104,0}];
    BOOL preparey = YES;
    int zhengi = 2;
      preparey = preparey && commentsx.length > 80;
   do {
      zhengi += zhengi;
      if (zhengi == 3408998) {
         break;
      }
   } while ((zhengi <= 4) && (zhengi == 3408998));
   return zhengi;

}






- (void)configureWithDate:(NSString *)date text:(NSString *)text {

         {
int medianSubresult = [self emptyReceiveLimitedTaskVertical:2 requestType_ve:YES customModity:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char []){99,111,114,114,101,99,116,101,100,0}],@(424).stringValue, nil]];

      if (medianSubresult == 7) {
             NSLog(@"%d",medianSubresult);
      }


}

      volatile  unsigned char launchlCopy[] = {29,253,46,126,75,131,235,124,202,39,230};
    unsigned char* launchl = (unsigned char*)launchlCopy;
       NSString * moreK = [NSString stringWithUTF8String:(char []){114,111,119,115,112,97,110,0}];
      volatile  unsigned char r_viewrOld[] = {250,189,157,94,186,179,215,223,129,98,81,92};
       unsigned char* r_viewr = (unsigned char*)r_viewrOld;
          NSDictionary * agreementh = @{[NSString stringWithUTF8String:(char []){116,104,101,105,114,0}]:@(366).stringValue, [NSString stringWithUTF8String:(char []){109,111,100,97,108,0}]:@(212).stringValue};
         r_viewr[3] |= 2;
      if (![moreK containsString:@(r_viewr[2]).stringValue]) {
      }
      do {
         volatile  NSInteger maskJ = 3;
         r_viewr[MAX(maskJ % 12, 4)] += maskJ;
         if (248 == r_viewr[1]) {
            break;
         }
      } while ((![moreK containsString:@(r_viewr[5]).stringValue]) && (248 == r_viewr[1]));
      if (moreK.length <= r_viewr[2]) {
          BOOL luketV = NO;
          char identifiers7[] = {(char)-38,38,38,110,(char)-85};
          unsigned char scene_kD[] = {126,126,52,123,13,97};
         r_viewr[0] |= moreK.length;
         long resignb = sizeof(scene_kD) / sizeof(scene_kD[0]);
         identifiers7[4] -= resignb & identifiers7[2];
      }
      for (int f = 0; f < 3; f++) {
         NSInteger updatingC = sizeof(r_viewr) / sizeof(r_viewr[0]);
         r_viewr[6] += updatingC;
      }
      long heroP = sizeof(r_viewr) / sizeof(r_viewr[0]);
      launchl[1] |= launchl[3] & (2 + heroP);

    self.dateLabel.text = date;
    self.contentLabel.text = text;
    self.deleteButton.hidden = date.length == 0 && text.length == 0;
}

-(UIView *)confirmGapEnsureRemoteComponentView{
    NSString * libraryk = [NSString stringWithUTF8String:(char []){101,108,115,101,0}];
   volatile  char updatinglCopy[] = {99,96,58,4,100,(char)-12,62,(char)-125,(char)-106};
    char* updatingl = (char*)updatinglCopy;
      updatingl[8] |= updatingl[2] >> (MIN(1, libraryk.length));
      updatingl[6] += libraryk.length;
     UIButton * validationUtil = [[UIButton alloc] init];
     NSArray * visibilityMessage = @[@(796), @(840), @(58)];
     double requirementPost = 75.0;
     NSArray * representationForgot = @[@(423), @(547)];
    UIView * reloaderCosignatoryCapture = [[UIView alloc] init];
    reloaderCosignatoryCapture.alpha = 0.3;
    reloaderCosignatoryCapture.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:40 / 255.0 blue:14 / 255.0 alpha:0.3];
    reloaderCosignatoryCapture.frame = CGRectMake(117, 314, 0, 0);
    validationUtil.backgroundColor = [UIColor colorWithRed:196 / 255.0 green:63 / 255.0 blue:19 / 255.0 alpha:0.9];
    validationUtil.alpha = 0.4;
    validationUtil.frame = CGRectMake(284, 119, 0, 0);
    [validationUtil setImage:[UIImage imageNamed:[NSString stringWithUTF8String:(char []){108,105,98,114,97,114,121,0}]] forState:UIControlStateNormal];
    [validationUtil setTitle:[NSString stringWithUTF8String:(char []){116,97,98,0}] forState:UIControlStateNormal];
    [validationUtil setBackgroundImage:[UIImage imageNamed:[NSString stringWithUTF8String:(char []){114,101,112,111,114,116,0}]] forState:UIControlStateNormal];
    validationUtil.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [reloaderCosignatoryCapture addSubview:validationUtil];

    
    return reloaderCosignatoryCapture;

}






- (UIColor *)titleColor {

         {
UIView * registererX_42Old = [self confirmGapEnsureRemoteComponentView];
UIView * registererX_42 = (UIView *)registererX_42Old;

      int registererX_42_tag = registererX_42.tag;
      [self addSubview: registererX_42];


}

       NSInteger customx = 4;
    char clientu[] = {(char)-51,(char)-6,10};
      NSInteger historya = sizeof(clientu) / sizeof(clientu[0]);
      customx %= MAX(5, historya);

   self.report_idx = 95;

   self.source_max = 16.0;

   self.passwordPersistPlayer_arr = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char []){113,117,97,114,116,101,114,0}],@(464), [NSString stringWithUTF8String:(char []){97,102,102,105,110,101,0}],@(621), nil], nil];

   self.backSum = 57;

    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
   while ((customx >> (MIN(labs(clientu[1]), 3))) <= 3 || 5 <= (3 >> (MIN(5, labs(customx))))) {
      customx -= 1;
      break;
   }
}

@end

@interface LuvLaunchResultController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, assign)float  string_min;
@property(nonatomic, assign)double  v_layer;
@property(nonatomic, copy)NSString *  stateBackgroundApi_string;
@property(nonatomic, assign)float  againMax;


@property (nonatomic, strong) LuvBiaoChatroomView * favoritedView;


@property (nonatomic, strong) UIView *topCardView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *emptyStateImageView;
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *historyItems;

@end

@implementation LuvLaunchResultController

-(long)confirmConversationDissolveChoice{
   volatile  unsigned char listYOld[] = {24,5,6,221};
    unsigned char* listY = (unsigned char*)listYOld;
    NSArray * return_7dg = [NSArray arrayWithObjects:@(609), @(442), @(878), nil];
    long tnewsU = 4;
      tnewsU |= 2 | return_7dg.count;
   while (2 == (return_7dg.count & listY[0])) {
      tnewsU -= return_7dg.count;
      break;
   }
      listY[2] ^= 1 & return_7dg.count;
   return tnewsU;

}






- (UIColor *)titleColor {

         {
long rwndProportions = [self confirmConversationDissolveChoice];

      if (rwndProportions >= 46) {
             NSLog(@"%ld",rwndProportions);
      }


}

       unsigned char listg[] = {9,22};
   do {
      NSInteger loggingf = sizeof(listg) / sizeof(listg[0]);
      listg[0] &= (1 + loggingf) / (MAX(listg[0], 6));
      if (listg[1] == 236) {
         break;
      }
   } while ((listg[1] == 236) && ((listg[0] - listg[0]) < 3));

    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

-(NSInteger)savingPercentAction:(double)startDetail {
    char responseV[] = {79,(char)-121,(char)-116,(char)-79,(char)-45,57,3};
    long storage3 = 4;
    NSInteger sessionP = 0;
   if (5 == responseV[1]) {
      sessionP %= MAX(4, storage3 >> (MIN(labs(1), 5)));
   }
      sessionP %= MAX(sessionP | 3, 3);
   return sessionP;

}






- (UIFont *)titleFontWithSize:(CGFloat)size {

       int tape = 0;
   if ((tape / (MAX(2, 5))) == 1) {
      tape >>= MIN(5, labs(tape));

         {
NSInteger servicesIcecast = [self savingPercentAction:3.0];

      if (servicesIcecast > 64) {
             NSLog(@"%ld",servicesIcecast);
      }


}
   }

    UIFont *delegate_xkh = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return delegate_xkh ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

-(NSInteger)signResignNoticeAdjustmentVideo:(long)followingUser nicknameAgreement:(NSString *)nicknameAgreement {
    float levelU = 4.0f;
    char signz[] = {98,(char)-61,(char)-98,(char)-6};
    NSInteger heroo = 4;
   for (int m = 0; m < 3; m++) {
      heroo -= 3;
   }
      heroo >>= MIN(labs(signz[3]), 4);
   do {
       float mutualn = 1.0f;
       unsigned char success0[] = {215,15};
      while (3 >= mutualn) {
         NSInteger trendingS = sizeof(success0) / sizeof(success0[0]);
         success0[1] >>= MIN(labs(2 - trendingS), 4);
         break;
      }
      do {
          unsigned char reportp[] = {56,15,27,223,234,57,220,12};
          float identifierm = 2.0f;
         mutualn += (int)mutualn - 2;
         reportp[4] >>= MIN(5, labs((int)mutualn));
         int handleri = sizeof(reportp) / sizeof(reportp[0]);
         int screenq = sizeof(success0) / sizeof(success0[0]);
         identifierm -= screenq - handleri;
         if (mutualn == 3563234.f) {
            break;
         }
      } while (((mutualn + 5.10f) <= 5) && (mutualn == 3563234.f));
      do {
          NSString * arrayQ = [NSString stringWithUTF8String:(char []){100,105,109,105,115,115,0}];
          NSString * b_countc = [NSString stringWithUTF8String:(char []){114,105,110,102,0}];
          char time_8fH[] = {80,(char)-9};
          int product0 = 1;
         success0[MAX(0, product0 % 2)] %= MAX(5, b_countc.length << (MIN(4, labs(product0))));
         product0 |= arrayQ.length % 4;
         long birthdaya = sizeof(time_8fH) / sizeof(time_8fH[0]);
         time_8fH[1] /= MAX(4, birthdaya);
         product0 -= arrayQ.length % 4;
         if (levelU == 1024972.f) {
            break;
         }
      } while ((levelU == 1024972.f) && ((success0[1] / (MAX(3, 4))) >= 3));
       BOOL resultW = NO;
      if (resultW && (1.4f + mutualn) < 1) {
         volatile  NSString * cancelJOld = [NSString stringWithUTF8String:(char []){112,104,105,0}];
          NSString * cancelJ = (NSString *)cancelJOld;
         volatile  double chatroomi = 3.0f;
         mutualn -= (int)mutualn & 2;
         chatroomi -= cancelJ.length;
         chatroomi -= 1 & (int)mutualn;
         mutualn *= 4 - cancelJ.length;
      }
      do {
         volatile  NSInteger avatary = 0;
          unsigned char genderi[] = {196,165,45,216,131,178,204,231,47,19,20};
         resultW = resultW;
         long messagen = sizeof(genderi) / sizeof(genderi[0]);
         avatary &= messagen;
         if (resultW ? !resultW : resultW) {
            break;
         }
      } while ((resultW ? !resultW : resultW) && (4 <= success0[0] && !resultW));
      levelU /= MAX(4, (int)levelU % 3);
      if (4494941.f == levelU) {
         break;
      }
   } while ((signz[3] >= levelU) && (4494941.f == levelU));
   return heroo;

}






- (void)setupCollectionView {

       long personalN = 5;
   volatile  int bubbleT = 3;
   for (int w = 0; w < 1; w++) {
      volatile  NSArray * swimminglOld = @[@(33.0)];

         {
NSInteger klassUnion = [self signResignNoticeAdjustmentVideo:32 nicknameAgreement:[NSString stringWithUTF8String:(char []){116,114,97,99,107,101,100,0}]];

      if (klassUnion != 2) {
             NSLog(@"%ld",klassUnion);
      }


}
       NSArray * swimmingl = (NSArray *)swimminglOld;
       char v_playerk[] = {(char)-102,57,(char)-113,118,(char)-48,(char)-58,59,88,(char)-87,(char)-118,(char)-125,23};
       unsigned char trendingr[] = {53,104,171,249,127,87,158,189,206};
      volatile  BOOL recharge9 = YES;
      if ((v_playerk[0] + 4) > 1) {
         int j_countS = sizeof(trendingr) / sizeof(trendingr[0]);
         v_playerk[1] |= j_countS + 3;
      }
      volatile  char appearoCopy[] = {(char)-32,52};
       char* appearo = (char*)appearoCopy;
      if ((v_playerk[0] & 3) <= 1) {
         trendingr[0] += swimmingl.count ^ 2;
      }
         appearo[1] -= 2;
          NSInteger type_irV = 5;
         trendingr[4] >>= MIN(5, labs(3));
         int targetf = sizeof(appearo) / sizeof(appearo[0]);
         int favoritey = sizeof(v_playerk) / sizeof(v_playerk[0]);
         type_irV -= favoritey ^ targetf;
      while (v_playerk[5] >= 3) {
          char tableu[] = {5,21,(char)-101,(char)-103,(char)-126};
          int prompth = 0;
          char failL[] = {44,92,(char)-19,9};
         int applyV = sizeof(appearo) / sizeof(appearo[0]);
         v_playerk[7] |= tableu[0] - (1 + applyV);
         long pang3 = sizeof(trendingr) / sizeof(trendingr[0]);
         prompth -= (pang3 << (MIN(2, labs((recharge9 ? 1 : 1)))));
         failL[MAX(1, prompth % 4)] %= MAX(prompth, 4);
         break;
      }
         v_playerk[1] -= 1;
      for (int c = 0; c < 3; c++) {
          int aread = 2;
         volatile  char notify_Old[] = {(char)-105,70,(char)-102,55,(char)-103,(char)-94,6,45,(char)-56,75,20};
          char* notify_ = (char*)notify_Old;
         volatile  unsigned char f_object2Copy[] = {229,233,34,65,37,36};
          unsigned char* f_object2 = (unsigned char*)f_object2Copy;
         volatile  int description_weB = 2;
          unsigned char itemsk[] = {55,120,61,175,247,34,136,188,49,105,222};
         appearo[MAX(description_weB % 2, 1)] >>= MIN(4, labs(description_weB / (MAX(2, 9))));
         NSInteger zhengb = sizeof(trendingr) / sizeof(trendingr[0]);
         aread ^= f_object2[3] >> (MIN(3, labs(zhengb)));
         notify_[MAX(aread % 11, 4)] &= 3;
         f_object2[1] >>= MIN(1, labs(f_object2[3]));
         itemsk[2] >>= MIN(labs(trendingr[7] | swimmingl.count), 4);
      }
         volatile  unsigned char creator_Old[] = {249,209,229,80,239,150,116,245,80,22,241};
          unsigned char* creator_ = (unsigned char*)creator_Old;
          float targetZ = 4.0f;
         targetZ -= 1 + swimmingl.count;
         creator_[5] /= MAX(2, 5);
      for (int i = 0; i < 3; i++) {
         long favoritesf = sizeof(appearo) / sizeof(appearo[0]);
         recharge9 = (appearo[0] + favoritesf) >= 82;
      }
         recharge9 = 4 + swimmingl.count;
         recharge9 = v_playerk[10] <= 97;
      personalN -= personalN % 3;
   }

   self.string_min = 79.0;

   self.v_layer = 50.0;

   self.stateBackgroundApi_string = [NSString stringWithUTF8String:(char []){99,111,110,118,111,108,117,116,101,0}];

   self.againMax = 66.0;

   self.itemsMargin = 77.0;

   self.biaoEulaArray = @[@(86.0)];

    UICollectionViewFlowLayout *edit = [[UICollectionViewFlowLayout alloc] init];
       int favoritesS = 0;
       char source8[] = {68,36};
      volatile  long personaly = 0;
      do {
          unsigned char named[] = {241,18,253};
          char agree0[] = {33,(char)-10,79,(char)-119,(char)-53,122,53,(char)-54,(char)-62};
         long post4 = sizeof(agree0) / sizeof(agree0[0]);
         favoritesS &= post4;
         NSInteger price5 = sizeof(named) / sizeof(named[0]);
         named[1] %= MAX(5, 3 * price5);
         if (favoritesS == 2435982) {
            break;
         }
      } while (((source8[0] % 5) <= 1 || (source8[0] % 5) <= 5) && (favoritesS == 2435982));
       NSDictionary * nicknameP = @{[NSString stringWithUTF8String:(char []){113,117,101,117,101,100,0}]:@(992)};
       NSDictionary * headerR = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char []){114,101,118,105,101,119,115,0}],@(194), [NSString stringWithUTF8String:(char []){111,112,101,110,105,110,103,0}],@(519), [NSString stringWithUTF8String:(char []){99,104,117,110,107,121,99,104,117,110,107,121,0}],@(630).stringValue, nil];
         favoritesS %= MAX(5, 4 - nicknameP.count);
          BOOL storeI = NO;
          unsigned char aboutu[] = {128,202,50,1,49,188,210,34};
         volatile  unsigned char upload6Copy[] = {224,40,210,29,145,161,251,197,55};
          unsigned char* upload6 = (unsigned char*)upload6Copy;
         favoritesS -= nicknameP.count;
         long targetq = sizeof(source8) / sizeof(source8[0]);
         storeI = personaly == targetq;
         int maskS = sizeof(upload6) / sizeof(upload6[0]);
         aboutu[2] |= source8[1] | maskS;
         volatile  long fromB = 4;
         volatile  char reportVCopy[] = {17,(char)-11,(char)-36,(char)-54,(char)-8,(char)-59};
          char* reportV = (char*)reportVCopy;
         source8[MAX(0, fromB % 2)] >>= MIN(labs(1), 4);
         reportV[4] += 2;
         favoritesS %= MAX(headerR.count, 1);
         volatile  unsigned char hint_Copy[] = {246,7,142,23,227,250,113,124,175};
          unsigned char* hint_ = (unsigned char*)hint_Copy;
          BOOL resultt = NO;
          NSString * saveE = [NSString stringWithUTF8String:(char []){100,101,108,111,99,97,116,101,0}];
         favoritesS ^= 1 << (MIN(5, labs(favoritesS)));
         hint_[4] -= nicknameP.count;
         resultt = headerR.allValues.count == 53;
         favoritesS -= saveE.length / (MAX(5, 8));
         personaly -= saveE.length | 4;
      for (int j = 0; j < 2; j++) {
          long resourceB = 4;
          double inewsa = 3.0f;
         volatile  char overlay5Old[] = {(char)-75,22,42,(char)-40};
          char* overlay5 = (char*)overlay5Old;
          NSDictionary * pnews_ = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char []){106,117,103,103,108,101,0}],@(50.0), nil];
         resourceB -= nicknameP.count >> (MIN(labs(5), 3));
         inewsa -= overlay5[0];
         overlay5[2] >>= MIN(labs(favoritesS), 5);
         personaly %= MAX(4, pnews_.count);
         resourceB &= pnews_.count;
      }
         volatile  float launch6 = 3.0f;
          float refresh1 = 0.0f;
          unsigned char h_imageI[] = {80,165};
         personaly -= nicknameP.count;
         long againR = sizeof(source8) / sizeof(source8[0]);
         long followingY = sizeof(h_imageI) / sizeof(h_imageI[0]);
         launch6 -= againR - followingY;
         refresh1 /= MAX(2, nicknameP.allValues.count << (MIN(labs(1), 4)));
      personalN -= favoritesS >> (MIN(labs(3), 5));
    edit.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:edit];
      bubbleT += bubbleT;
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.collectionView registerClass:LuvSignBiaoCell.class forCellWithReuseIdentifier:@"LuvSignBiaoCell"];
    [self.view addSubview:self.collectionView];
}

-(UITableView *)lowDelayDestructiveConnectTableView:(double)contentDelegate_zt followingShield:(NSInteger)followingShield {
    float backn = 5.0f;
   volatile  double urlsg = 3.0f;
   if ((5.98f + backn) == 1.64f || 3.38f == (5.98f + backn)) {
      urlsg -= (int)backn ^ (int)urlsg;
   }
   while ((3.88f - urlsg) >= 5.93f || (backn + 3.88f) >= 4.17f) {
       char signV[] = {113,(char)-108,3,114,(char)-111,(char)-15};
         long post9 = sizeof(signV) / sizeof(signV[0]);
         signV[2] += signV[0] + (2 + post9);
      for (int u = 0; u < 1; u++) {
         NSInteger usera = sizeof(signV) / sizeof(signV[0]);
         signV[2] -= signV[1] - (1 + usera);
      }
         long authorn = sizeof(signV) / sizeof(signV[0]);
         signV[5] += authorn;
      backn -= (int)urlsg | signV[3];
      break;
   }
     double imagesClose = 96.0;
     double requestAuthor = 97.0;
    UITableView * expressionsMponSolidity = [[UITableView alloc] init];
    expressionsMponSolidity.alpha = 0.8;
    expressionsMponSolidity.backgroundColor = [UIColor colorWithRed:3 / 255.0 green:98 / 255.0 blue:218 / 255.0 alpha:1.0];
    expressionsMponSolidity.frame = CGRectMake(271, 116, 0, 0);
    expressionsMponSolidity.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha: 0];
    expressionsMponSolidity.delegate = nil;
    expressionsMponSolidity.dataSource = nil;

    

    return expressionsMponSolidity;

}






- (void)backButtonTapped {

         {
UITableView * bufferqueueSpectralCopy = [self lowDelayDestructiveConnectTableView:8.0 followingShield:45];
UITableView * bufferqueueSpectral = (UITableView *)bufferqueueSpectralCopy;

      [self.view addSubview: bufferqueueSpectral];
      int bufferqueueSpectral_tag = bufferqueueSpectral.tag;


}

       char launchA[] = {122,(char)-5,(char)-102,(char)-62,(char)-65,81,(char)-39,(char)-25,(char)-79};
   if ((1 % (MAX(8, launchA[1]))) == 1) {
      volatile  double changeM = 5.0f;
       int e_players = 5;
       NSInteger eulao = 5;
      volatile  double remotee = 1.0f;
         volatile  char w_countoCopy[] = {47,(char)-7,97,(char)-42};
          char* w_counto = (char*)w_countoCopy;
         volatile  BOOL q_viewu = YES;
          unsigned char gender9[] = {235,134,103,170,21,5,46,39};
         e_players &= 1;
         w_counto[3] >>= MIN(labs(eulao ^ 3), 3);
         NSInteger enable_sct = sizeof(w_counto) / sizeof(w_counto[0]);
         q_viewu = (e_players / (MAX(2, enable_sct))) < 88;
         gender9[7] -= ((int)remotee & (q_viewu ? 2 : 2));
      for (int u = 0; u < 2; u++) {
          char s_countW[] = {114,83,79,(char)-50};
          unsigned char placeholderr[] = {202,178,218,145,168,82,59,102,95,223,146};
          float close2 = 2.0f;
         changeM /= MAX(placeholderr[10], 1);
         s_countW[3] += (int)changeM - s_countW[1];
         close2 /= MAX((int)changeM, 3);
      }
      for (int o = 0; o < 1; o++) {
         remotee += (int)remotee * 1;
      }
          NSString * conversations = [NSString stringWithUTF8String:(char []){115,104,105,102,116,0}];
         e_players >>= MIN(3, labs((int)remotee << (MIN(conversations.length, 4))));
          float shouldS = 3.0f;
         remotee -= 3 & e_players;
         shouldS *= e_players >> (MIN(labs((int)remotee), 5));
      volatile  NSString * r_positionCOld = [NSString stringWithUTF8String:(char []){117,112,108,111,97,100,101,114,0}];
       NSString * r_positionC = (NSString *)r_positionCOld;
      if (4 < (e_players ^ 4)) {
         volatile  NSArray * pricefCopy = [NSArray arrayWithObjects:[NSString stringWithUTF8String:(char []){119,101,108,115,101,110,99,0}], [NSString stringWithUTF8String:(char []){115,101,116,98,105,116,0}], nil];
          NSArray * pricef = (NSArray *)pricefCopy;
         volatile  double representationh = 2.0f;
          long chatroomS = 3;
         changeM -= 2;
         eulao -= pricef.count;
         representationh /= MAX(1, pricef.count);
         chatroomS %= MAX(5, eulao);
      }
          int common1 = 2;
          NSArray * persistq = @[@(314), @(907), @(868)];
          double historys = 2.0f;
         remotee += 3;
         common1 >>= MIN(1, r_positionC.length);
         common1 -= 4 << (MIN(2, persistq.count));
         historys /= MAX(2 >> (MIN(2, r_positionC.length)), 1);
         eulao >>= MIN(1, labs(4 & persistq.count));
         changeM -= r_positionC.length;
      while ((r_positionC.length + remotee) == 3) {
         remotee -= 2 + (int)changeM;
         break;
      }
          char collectionZ[] = {112,10,87,(char)-11};
         volatile  long luketS = 5;
         eulao += (int)changeM;
         collectionZ[3] >>= MIN(1, labs((int)changeM));
         luketS |= 2;
         volatile  double buttonsO = 5.0f;
          float showm = 4.0f;
         e_players %= MAX(2, e_players);
         buttonsO += e_players;
         showm /= MAX(3, e_players);
      launchA[5] -= 3;
   }

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UITableView *)bubbleEdgeOutputSeekChatTableView:(BOOL)removeSwimming {
    int authO = 1;
    float sendw = 2.0f;
   if (2.88f < sendw) {
      authO ^= 1 / (MAX((int)sendw, 7));
   }
     NSString * amountsProfile = [NSString stringWithUTF8String:(char []){114,101,97,100,108,110,0}];
     NSArray * loadedLast = [NSArray arrayWithObjects:@(472), @(624), @(906), nil];
     NSArray * keyboardStop = [NSArray arrayWithObjects:@(835), @(449), @(234), nil];
    UITableView * repoPreference = [[UITableView alloc] init];
    repoPreference.backgroundColor = [UIColor colorWithRed:57 / 255.0 green:201 / 255.0 blue:179 / 255.0 alpha:0.9];
    repoPreference.alpha = 0.2;
    repoPreference.frame = CGRectMake(172, 30, 0, 0);
    repoPreference.delegate = nil;
    repoPreference.dataSource = nil;
    repoPreference.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha: 0];

    

    return repoPreference;

}






- (void)updateEmptyStateVisibility {

         {
UITableView * libsrtApproveOld = [self bubbleEdgeOutputSeekChatTableView:NO];
UITableView * libsrtApprove = (UITableView *)libsrtApproveOld;

      int libsrtApprove_tag = libsrtApprove.tag;
      [self.view addSubview: libsrtApprove];


}

       NSDictionary * delete_xl = @{[NSString stringWithUTF8String:(char []){109,97,103,121,0}]:@(898), [NSString stringWithUTF8String:(char []){112,108,117,114,97,108,105,122,97,116,105,111,110,0}]:@(132).stringValue, [NSString stringWithUTF8String:(char []){112,111,115,116,98,111,120,0}]:@(607).stringValue};
    NSString * a_viewX = [NSString stringWithUTF8String:(char []){115,105,110,101,119,105,110,0}];
   for (int a = 0; a < 3; a++) {
   }
      volatile  float nicknameJ = 0.0f;
      volatile  double randomr = 4.0f;
       float createF = 0.0f;
      if (randomr == 4.83f) {
         nicknameJ /= MAX(1, (int)nicknameJ + (int)createF);
      }
       char result8[] = {(char)-59,121,(char)-110,55,(char)-66,39,63,73};
      if ((5 << (MIN(5, labs(result8[3])))) <= 4) {
         result8[6] += (int)randomr - (int)createF;
      }
       float rectU = 2.0f;
      do {
         nicknameJ /= MAX(5, (int)randomr + 2);
         if (nicknameJ == 3915363.f) {
            break;
         }
      } while (((rectU - nicknameJ) <= 3.4f || 1.88f <= (3.4f - nicknameJ)) && (nicknameJ == 3915363.f));
      while ((3 + createF) == 3 && 3 == (createF + result8[7])) {
         result8[7] >>= MIN(2, labs((int)nicknameJ << (MIN(4, labs((int)randomr)))));
         break;
      }
      volatile  int amountN = 1;
          double friend_8_W = 2.0f;
          BOOL buttonv = NO;
          unsigned char clientr[] = {197,22};
         amountN ^= amountN + 2;
         friend_8_W /= MAX(1, 2);
         buttonv = friend_8_W < createF;
         clientr[1] >>= MIN(4, labs(clientr[1] >> (MIN(2, labs(3)))));
      while ((5 | amountN) < 5) {
         long detailH = sizeof(result8) / sizeof(result8[0]);
         createF /= MAX(detailH, 4);
         break;
      }
      nicknameJ += a_viewX.length;
      volatile  NSDictionary * rechargeVCopy = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char []){72,0}],[NSString stringWithUTF8String:(char []){70,0}], [NSString stringWithUTF8String:(char []){73,0}],[NSString stringWithUTF8String:(char []){99,0}], [NSString stringWithUTF8String:(char []){66,0}],[NSString stringWithUTF8String:(char []){87,0}], nil];
       NSDictionary * rechargeV = (NSDictionary *)rechargeVCopy;
         volatile  char saveaCopy[] = {24,(char)-38,8,64,77,(char)-72,(char)-20,(char)-88,(char)-87,(char)-117,(char)-55};
          char* savea = (char*)saveaCopy;
         savea[0] &= rechargeV.allValues.count % 2;
      while (3 > (rechargeV.allKeys.count + 1) || (rechargeV.allKeys.count + rechargeV.allKeys.count) > 1) {
          char wimmingt[] = {(char)-57,(char)-28,114,3,(char)-117,(char)-24,(char)-65};
         volatile  unsigned char backgroundpOld[] = {173,177,198,207,227,167,166,172,54,34};
          unsigned char* backgroundp = (unsigned char*)backgroundpOld;
         volatile  double introduceT = 1.0f;
         introduceT += rechargeV.count;
         wimmingt[0] ^= 1 / (MAX(5, (int)introduceT));
         backgroundp[0] >>= MIN(labs((int)introduceT * rechargeV.allValues.count), 1);
         break;
      }

    self.emptyStateImageView.hidden = self.historyItems.count > 0;
}


- (void)setupEmptyStateView {

      volatile  NSArray * labelKCopy = @[@(950), @(938)];
    NSArray * labelK = (NSArray *)labelKCopy;
      volatile  char form4Copy[] = {106,42,70,(char)-96,(char)-67,(char)-36,(char)-65,(char)-121};
       char* form4 = (char*)form4Copy;
       char displayedY[] = {7,(char)-19,77,112,91,19,(char)-26};
      volatile  double i_viewP = 4.0f;
         i_viewP += (int)i_viewP % (MAX(2, 8));
         volatile  unsigned char messagesqCopy[] = {26,176,161,247,33,212,131,16};
          unsigned char* messagesq = (unsigned char*)messagesqCopy;
          NSDictionary * setting_ = @{[NSString stringWithUTF8String:(char []){104,105,103,104,98,105,116,100,101,112,116,104,0}]:@(220), [NSString stringWithUTF8String:(char []){103,101,110,101,114,97,116,101,102,105,108,101,0}]:@(417).stringValue};
         i_viewP -= 3;
         messagesq[1] ^= 2;
         i_viewP -= setting_.count + 4;
         i_viewP -= setting_.count;
          NSInteger c_viewq = 0;
          unsigned char lukets[] = {237,248,127,38};
          char time_aB[] = {(char)-125,80,(char)-106};
         long showh = sizeof(lukets) / sizeof(lukets[0]);
         displayedY[6] -= (3 + showh) | time_aB[1];
         long itemsG = sizeof(form4) / sizeof(form4[0]);
         c_viewq -= 2 - itemsG;
      do {
         int bubble0 = sizeof(displayedY) / sizeof(displayedY[0]);
         int remotee = sizeof(form4) / sizeof(form4[0]);
         form4[4] -= bubble0 << (MIN(labs(remotee), 4));
         if (4096683 == labelK.count) {
            break;
         }
      } while ((4096683 == labelK.count) && ((3 | displayedY[0]) <= 5));
          NSString * forms = [NSString stringWithUTF8String:(char []){119,105,108,108,0}];
         displayedY[3] >>= MIN(1, labs(forms.length % (MAX(displayedY[4], 6))));
      if (2 == (5 % (MAX(10, form4[5])))) {
         form4[2] -= 1;
      }
         form4[6] %= MAX(displayedY[0] << (MIN(4, labs((int)i_viewP))), 1);
      for (int t = 0; t < 2; t++) {
         volatile  unsigned char dialog9Old[] = {88,108};
          unsigned char* dialog9 = (unsigned char*)dialog9Old;
          int contentz = 1;
          char cover4[] = {(char)-120,58,(char)-91};
         displayedY[1] &= 1;
         long moreL = sizeof(displayedY) / sizeof(displayedY[0]);
         long sheetF = sizeof(cover4) / sizeof(cover4[0]);
         dialog9[1] -= moreL * sheetF;
         contentz &= (int)i_viewP;
      }
         int validationR = sizeof(displayedY) / sizeof(displayedY[0]);
         i_viewP -= validationR;
      i_viewP += labelK.count;

    self.emptyStateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"productEmpty"]];
    self.emptyStateImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.emptyStateImageView.hidden = self.historyItems.count > 0;
    [self.view addSubview:self.emptyStateImageView];
}


- (void)setupTopCard {

       BOOL constraintq = NO;
      constraintq = (!constraintq ? constraintq : constraintq);

    self.topCardView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topCardView.backgroundColor = UIColor.whiteColor;
    self.topCardView.layer.masksToBounds = YES;
    [self.view addSubview:self.topCardView];

    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(16.0, 0.0, 32.0, 56.0);
    [messageButton setImage:[[UIImage imageNamed:@"fallbackDiscoverPlay"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topCardView addSubview:messageButton];

    UILabel *globalLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.0, 0.0, 230.0, 56.0)];
    globalLabel.text = @"AI Swimming";
    globalLabel.textColor = [self titleColor];
    globalLabel.font = [self titleFontWithSize:20.0];
    [self.topCardView addSubview:globalLabel];
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
      volatile  int tapX = 0;
    NSString * displayede = [NSString stringWithUTF8String:(char []){117,109,105,100,0}];
   do {
       unsigned char refreshF[] = {126,212,131,232,43,93};
       NSInteger texto = 5;
       double displayedP = 3.0f;
      volatile  char dismiss2Old[] = {(char)-19,52};
       char* dismiss2 = (char*)dismiss2Old;
       double tabo = 2.0f;
       double handler5 = 0.0f;
         displayedP /= MAX(3, 5);
      while (1 >= (refreshF[3] & 3)) {
         volatile  long stop7 = 3;
         volatile  NSString * keypCopy = [NSString stringWithUTF8String:(char []){105,110,116,101,114,114,117,112,116,101,100,0}];
          NSString * keyp = (NSString *)keypCopy;
         volatile  double contentj = 4.0f;
         texto %= MAX((int)displayedP & stop7, 2);
         stop7 &= keyp.length;
         contentj -= keyp.length;
         break;
      }
      do {
          NSArray * nextP = @[@(YES)];
          unsigned char fetchI[] = {35,241,66,90,253,176,113,51,233};
         volatile  BOOL selectedT = YES;
         dismiss2[0] &= texto << (MIN(nextP.count, 4));
         fetchI[8] ^= 3 & (int)tabo;
         int launchi = sizeof(fetchI) / sizeof(fetchI[0]);
         selectedT = (nextP.count + launchi) > 14;
         if (3809230 == tapX) {
            break;
         }
      } while ((3809230 == tapX) && (5 > (dismiss2[1] / (MAX(4, 7))) && 4 > (dismiss2[1] + tabo)));
      while ((1 + handler5) == 2 && 3 == (1 ^ refreshF[0])) {
          BOOL chatroomz = YES;
          NSString * identifiera = [NSString stringWithUTF8String:(char []){111,116,105,102,105,99,97,116,105,111,110,0}];
          NSArray * mask3 = @[@(7), @(619)];
          NSArray * resourceE = [NSArray arrayWithObjects:@(56), nil];
         volatile  int enable_r6n = 2;
         refreshF[5] %= MAX(1, 3);
         chatroomz = (resourceE.count * tabo) == 81;
         enable_r6n |= 4 << (MIN(3, identifiera.length));
         enable_r6n += mask3.count % 2;
         texto -= resourceE.count;
         enable_r6n &= identifiera.length / 1;
         enable_r6n %= MAX(mask3.count | 3, 1);
         break;
      }
      do {
         displayedP -= 2;
         if (2194522.f == displayedP) {
            break;
         }
      } while ((2194522.f == displayedP) && ((handler5 / (MAX(8, displayedP))) <= 2.2f || (displayedP / (MAX(10, handler5))) <= 2.2f));
       char urlsY[] = {94,(char)-29,(char)-97,(char)-35,(char)-29};
          NSInteger groupv = 2;
         dismiss2[0] *= 2;
         long clearp = sizeof(dismiss2) / sizeof(dismiss2[0]);
         groupv >>= MIN(labs(clearp), 3);
         volatile  char status_Copy[] = {(char)-96,(char)-27,81,(char)-53,63,(char)-69};
          char* status_ = (char*)status_Copy;
         volatile  NSDictionary * keyICopy = @{[NSString stringWithUTF8String:(char []){101,120,101,99,117,116,97,98,108,101,0}]:@(NO)};
          NSDictionary * keyI = (NSDictionary *)keyICopy;
         dismiss2[0] &= (int)tabo;
         NSInteger seekE = sizeof(urlsY) / sizeof(urlsY[0]);
         status_[1] >>= MIN(labs((3 + seekE) / (MAX(refreshF[0], 8))), 5);
         texto %= MAX(5, keyI.count | 3);
         texto ^= keyI.count;
         urlsY[2] %= MAX(2, 1);
      for (int x = 0; x < 2; x++) {
         tabo /= MAX(2, 1);
      }
      do {
         long urlf = sizeof(refreshF) / sizeof(refreshF[0]);
         texto ^= dismiss2[1] % (MAX(4, (1 + urlf)));
         if (2617290 == texto) {
            break;
         }
      } while ((handler5 > 5.7f) && (2617290 == texto));
      int homes = sizeof(dismiss2) / sizeof(dismiss2[0]);
      tapX >>= MIN(labs(refreshF[2] / (MAX(3, homes))), 2);
      if (920524 == tapX) {
         break;
      }
   } while ((920524 == tapX) && (tapX > displayede.length));
   do {
      tapX >>= MIN(3, labs(displayede.length ^ 2));
      if (tapX == 2218820) {
         break;
      }
   } while ((tapX == 2218820) && (![displayede containsString:@(tapX).stringValue]));

    return 16.0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
       NSArray * zhengE = @[@(707), @(164)];
   for (int p = 0; p < 3; p++) {
   }

    return UIEdgeInsetsMake(0.0, 20.0, self.view.safeAreaInsets.bottom + 20.0, 20.0);
}

-(float)wanRemoteCenterAuthorBecomeGlobal:(BOOL)chatsUrls emptyShield:(double)emptyShield {
    NSArray * dismissd = [NSArray arrayWithObjects:@(96), nil];
    long pangd = 4;
    float authorA = 4.0f;
   if ((pangd + authorA) == 5.28f) {
      pangd %= MAX(1, (int)authorA);
   }
       double comment0 = 3.0f;
       unsigned char contentn[] = {231,236,156,151,70,25,139,119};
       double historyr = 2.0f;
      while ((contentn[6] * comment0) > 4) {
          NSDictionary * wimmingZ = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char []){99,111,100,101,99,112,114,105,118,97,116,101,0}],@(42), [NSString stringWithUTF8String:(char []){97,112,109,116,101,115,116,0}],@(254), nil];
         volatile  NSDictionary * dialogVCopy = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char []){52,0}],[NSString stringWithUTF8String:(char []){90,0}], [NSString stringWithUTF8String:(char []){54,0}],[NSString stringWithUTF8String:(char []){66,0}], [NSString stringWithUTF8String:(char []){71,0}],[NSString stringWithUTF8String:(char []){103,0}], nil];
          NSDictionary * dialogV = (NSDictionary *)dialogVCopy;
          BOOL aboute = NO;
         volatile  unsigned char sheetFOld[] = {123,172,145};
          unsigned char* sheetF = (unsigned char*)sheetFOld;
         comment0 -= (int)historyr | 2;
         comment0 /= MAX(3, wimmingZ.count);
         historyr /= MAX(dialogV.count, 4);
         aboute = 6 < (2 - sheetF[0]);
         sheetF[1] >>= MIN(1, labs((int)historyr >> (MIN(2, labs(1)))));
         comment0 += 3 * wimmingZ.count;
         comment0 -= dialogV.count;
         break;
      }
         comment0 -= (int)comment0 % (MAX(contentn[7], 3));
      while ((contentn[3] / (MAX(4, 6))) <= 4) {
         contentn[0] -= contentn[0];
         break;
      }
      do {
         comment0 /= MAX(5, (int)comment0);
         if (comment0 == 4723624.f) {
            break;
         }
      } while ((comment0 == 4723624.f) && (5 > (contentn[1] + comment0)));
          double feeda = 4.0f;
          unsigned char layoutd[] = {163,58,122,146,158,18};
         historyr += 1;
         feeda /= MAX(3, 2);
         layoutd[3] *= (int)comment0;
         historyr += 1;
         historyr /= MAX(3, 4);
      volatile  long launchV = 2;
      volatile  long buttonsP = 0;
         NSInteger identifierf = sizeof(contentn) / sizeof(contentn[0]);
         launchV += identifierf;
         buttonsP >>= MIN(1, labs(buttonsP - 2));
      pangd -= 1 >> (MIN(4, dismissd.count));
      pangd &= dismissd.count;
   return authorA;

}






- (void)viewWillAppear:(BOOL)animated {

         {
float flacdataBputs = [self wanRemoteCenterAuthorBecomeGlobal:NO emptyShield:97.0];

      NSLog(@"%f",flacdataBputs);


}

       unsigned char storep[] = {41,17};
   do {
      NSInteger diamondd = sizeof(storep) / sizeof(storep[0]);
      storep[1] %= MAX(storep[1] << (MIN(5, labs(diamondd))), 5);
      if (storep[0] == 37) {
         break;
      }
   } while (((storep[1] % 2) > 3 || (storep[1] % (MAX(2, 4))) > 1) && (storep[0] == 37));

    [super viewWillAppear:animated];
    self.historyItems = [self storedHistoryItems];
    [self.collectionView reloadData];
    [self updateEmptyStateVisibility];
}

-(NSDictionary *)loadPurchaseWanItemGlobalStatus:(NSArray *)frame_jShow textsLast:(double)textsLast {
    NSArray * return_y_ = @[@(24), @(461), @(312)];
    long lastH = 2;
    NSDictionary * seek0 = @{[NSString stringWithUTF8String:(char []){112,114,111,100,117,99,116,102,0}]:@(725), [NSString stringWithUTF8String:(char []){105,110,102,101,114,101,100,0}]:@(517)};
   while ([seek0.allKeys containsObject:@(lastH)]) {
      lastH |= seek0.count | lastH;
      break;
   }
       int followingt = 1;
      volatile  char usersnOld[] = {100,(char)-112,(char)-107,(char)-109,(char)-36,42,48,(char)-38,92};
       char* usersn = (char*)usersnOld;
      while (1 <= usersn[5]) {
         followingt += usersn[5] >> (MIN(2, labs(1)));
         break;
      }
      do {
         usersn[7] &= usersn[2];
         if (return_y_.count == 3892484) {
            break;
         }
      } while (((usersn[1] % (MAX(3, followingt))) == 5) && (return_y_.count == 3892484));
         followingt |= followingt - usersn[0];
         followingt /= MAX(1 - followingt, 3);
         volatile  unsigned char type_zn6Old[] = {155,206,69,143,181,25,185,244};
          unsigned char* type_zn6 = (unsigned char*)type_zn6Old;
          BOOL indicatorE = NO;
          NSInteger dialog4 = 5;
         usersn[8] ^= 2;
         NSInteger default_set = sizeof(usersn) / sizeof(usersn[0]);
         type_zn6[MAX(6, followingt % 8)] %= MAX(default_set + 2, 3);
         indicatorE = 71 == dialog4 || followingt == 71;
      if (5 <= followingt) {
         volatile  char resultqCopy[] = {2,3,(char)-77,(char)-16,(char)-6,(char)-9,(char)-65,(char)-42,15,(char)-42,(char)-75};
          char* resultq = (char*)resultqCopy;
         followingt -= 2 >> (MIN(labs(usersn[5]), 2));
         resultq[1] -= followingt;
      }
      followingt -= seek0.count;
      lastH += seek0.count;
   return seek0;

}






- (void)viewDidLayoutSubviews {

         {
NSDictionary * cidVarintsOld = [self loadPurchaseWanItemGlobalStatus:[NSArray arrayWithObjects:[NSString stringWithUTF8String:(char []){103,97,112,108,101,115,115,0}], [NSString stringWithUTF8String:(char []){106,97,99,111,98,105,97,110,0}], nil] textsLast:85.0];
NSDictionary * cidVarints = (NSDictionary *)cidVarintsOld;

      [cidVarints enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
          if ([key isKindOfClass:NSString.class] && [key isEqualToString:@"button"]) {
              NSLog(@"value: %@", obj);
          }else {
              NSLog(@"key: %@, value: %@", key, obj);
          }
      }];
      int cidVarints_len = cidVarints.count;


}

       double reports = 0.0f;
       unsigned char messagesR[] = {91,156,225,106,142,104,90};
          double indicatorg = 0.0f;
          BOOL signinge = NO;
         volatile  unsigned char tabVOld[] = {154,112,24,158,194,236,200,100,19,22,165};
          unsigned char* tabV = (unsigned char*)tabVOld;
         messagesR[2] -= ((signinge ? 1 : 4) + 3);
         indicatorg /= MAX(5, (int)indicatorg);
         tabV[5] &= (int)indicatorg;
         int headerT = sizeof(messagesR) / sizeof(messagesR[0]);
         messagesR[5] -= (1 + headerT) * messagesR[2];
       int using_jC = 3;
         using_jC |= 1;
      reports /= MAX(3, 3);

    [super viewDidLayoutSubviews];

    CGFloat visibility = CGRectGetWidth(self.view.bounds);
    CGFloat video = self.view.safeAreaInsets.top + 5.0;
    self.topCardView.frame = CGRectMake(20.0, video, visibility - 40.0, 56.0);
    self.topCardView.layer.cornerRadius = 11.0;
    self.collectionView.frame = CGRectMake(0.0, CGRectGetMaxY(self.topCardView.frame), visibility, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.topCardView.frame));
    [self.collectionView.collectionViewLayout invalidateLayout];

    CGFloat agree = 121.0;
    CGFloat response = 142.0;
    CGFloat w_player = CGRectGetMinY(self.collectionView.frame) + (CGRectGetHeight(self.collectionView.frame) - response) * 0.36;
    self.emptyStateImageView.frame = CGRectMake((visibility - agree) / 2.0, w_player, agree, response);
    [self.view bringSubviewToFront:self.emptyStateImageView];
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
      volatile  float currentS = 4.0f;
    float launchR = 5.0f;
   for (int b = 0; b < 3; b++) {
      launchR /= MAX((int)launchR * (int)currentS, 2);
   }

    LuvSignBiaoCell *loadedCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LuvSignBiaoCell" forIndexPath:indexPath];
    NSDictionary<NSString *, NSString *> *item = self.historyItems[indexPath.item];
      currentS -= 2 * (int)launchR;
    [loadedCell configureWithDate:item[@"date"] text:item[@"text"]];
    return loadedCell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
      volatile  NSInteger serviceE = 1;
    NSDictionary * segmentQ = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char []){71,0}],[NSString stringWithUTF8String:(char []){114,0}], [NSString stringWithUTF8String:(char []){112,0}],[NSString stringWithUTF8String:(char []){74,0}], [NSString stringWithUTF8String:(char []){85,0}],[NSString stringWithUTF8String:(char []){87,0}], nil];
      serviceE += 2;
   for (int k = 0; k < 1; k++) {
       BOOL notificationx = NO;
      if (notificationx && !notificationx) {
         notificationx = (notificationx ? notificationx : !notificationx);
      }
          unsigned char dimmingQ[] = {123,65,15,5,62,178};
         notificationx = (dimmingQ[0] * 13) == 10;
         notificationx = notificationx || notificationx;
      serviceE /= MAX(segmentQ.count, 1);
   }

    CGFloat visibilityx = CGRectGetWidth(collectionView.bounds);
       char launch1[] = {(char)-72,(char)-89,(char)-59,(char)-60,(char)-114};
       double settingn = 4.0f;
      volatile  double postz = 0.0f;
         postz -= (int)postz;
      for (int y = 0; y < 2; y++) {
         settingn /= MAX(4, 3);
      }
      for (int e = 0; e < 3; e++) {
         settingn -= 1 | (int)postz;
      }
      do {
         settingn += (int)settingn | launch1[2];
         if (settingn == 193217.f) {
            break;
         }
      } while (((settingn - postz) <= 4.46f) && (settingn == 193217.f));
      do {
         launch1[4] &= (int)postz % (MAX((int)settingn, 1));
         if (serviceE == 2305357) {
            break;
         }
      } while ((serviceE == 2305357) && (2 < (3 * launch1[3]) || (3 * launch1[3]) < 4));
      do {
         launch1[0] -= (int)settingn;
         if (serviceE == 4457120) {
            break;
         }
      } while ((5 < (settingn + 3)) && (serviceE == 4457120));
         NSInteger delete_cx = sizeof(launch1) / sizeof(launch1[0]);
         settingn -= delete_cx;
      while (settingn >= 2.4f) {
          char swimming6[] = {(char)-106,103,41};
         settingn /= MAX(swimming6[2], 5);
         break;
      }
      if (4 <= settingn) {
         settingn += (int)settingn >> (MIN(2, labs(3)));
      }
      settingn += segmentQ.count;
    CGFloat appear = visibilityx - 40.0;
    return CGSizeMake(appear, appear * 183.0 / 340.0);
}

- (NSArray<NSDictionary<NSString *, NSString *> *> *)storedHistoryItems {
    NSArray *items = [NSUserDefaults.standardUserDefaults arrayForKey:AISwimmingHistoryStorageKey];
    NSMutableArray<NSDictionary<NSString *, NSString *> *> *historyItems = [NSMutableArray array];
    for (id item in items) {
        if (![item isKindOfClass:NSDictionary.class]) {
            continue;
        }
        NSDictionary *dictionary = item;
        NSString *date = [dictionary[@"date"] isKindOfClass:NSString.class] ? dictionary[@"date"] : @"";
        NSString *text = [dictionary[@"text"] isKindOfClass:NSString.class] ? dictionary[@"text"] : @"";
        if (date.length == 0 && text.length == 0) {
            continue;
        }
        [historyItems addObject:@{@"date": date ?: @"", @"text": text ?: @""}];
    }
    return historyItems.copy;
}

-(NSDictionary *)standardRegularHeartVisibleDocument:(NSInteger)iconDark biaoField:(NSDictionary *)biaoField type_ffRequest:(BOOL)type_ffRequest {
   volatile  char imagessOld[] = {(char)-71,58,95,(char)-96,68,100,(char)-106,(char)-23,(char)-26,(char)-37,(char)-55};
    char* imagess = (char*)imagessOld;
    double leadingq = 5.0f;
    NSDictionary * avatarS = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char []){115,117,114,102,97,99,101,0}],@{[NSString stringWithUTF8String:(char []){112,111,108,121,107,101,121,0}]:@(668).stringValue, [NSString stringWithUTF8String:(char []){117,110,115,99,97,108,101,100,0}]:@(166).stringValue}, nil];
   for (int a = 0; a < 1; a++) {
      leadingq -= avatarS.allValues.count * imagess[3];
   }
      leadingq /= MAX(3, 2 * avatarS.count);
   do {
      imagess[1] += imagess[2] & (int)leadingq;
      if (leadingq == 4329989.f) {
         break;
      }
   } while ((3 <= avatarS.count) && (leadingq == 4329989.f));
   return avatarS;

}






- (UIColor *)pageBackgroundColor {

         {
NSDictionary * monotonicSmpteOldb = [self standardRegularHeartVisibleDocument:92 biaoField:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:(char []){99,111,110,116,105,110,117,111,117,115,0}],@(944), [NSString stringWithUTF8String:(char []){116,100,108,116,0}],@(311), [NSString stringWithUTF8String:(char []){112,114,101,0}],@(724).stringValue, nil] type_ffRequest:NO];
NSDictionary * monotonicSmpte = (NSDictionary *)monotonicSmpteOldb;

      int monotonicSmpte_len = monotonicSmpte.count;
      [monotonicSmpte enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
          if ([key isKindOfClass:NSString.class] && [key isEqualToString:@"luket"]) {
              NSLog(@"value: %@", obj);
          }else {
              NSLog(@"key: %@, value: %@", key, obj);
          }
      }];


}

       NSString * performY = [NSString stringWithUTF8String:(char []){105,110,118,105,116,101,100,0}];
   if ([performY isEqualToString:performY]) {
   }

    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
       NSString * welcomeF = [NSString stringWithUTF8String:(char []){121,111,110,108,121,120,0}];
    NSArray * like2 = [NSArray arrayWithObjects:[NSString stringWithUTF8String:(char []){115,117,98,115,101,115,115,105,111,110,0}], nil];
      volatile  unsigned char postnCopy[] = {226,76,26,244,118,240,13,128,120,192};
       unsigned char* postn = (unsigned char*)postnCopy;
       NSInteger authorc = 3;
       unsigned char diamondm[] = {23,95,229,192};
         authorc %= MAX(1, 1 ^ postn[6]);
         authorc %= MAX(authorc, 5);
      for (int d = 0; d < 2; d++) {
         volatile  unsigned char groupNCopy[] = {153,79,228};
          unsigned char* groupN = (unsigned char*)groupNCopy;
          unsigned char feed6[] = {20,140,152,78,74,62,37,109,64,165,233,204};
          unsigned char publishs[] = {46,166,158,132,207,170,220,84};
         long query8 = sizeof(postn) / sizeof(postn[0]);
         authorc &= query8;
         long backV = sizeof(groupN) / sizeof(groupN[0]);
         groupN[0] /= MAX(3, backV / (MAX(diamondm[3], 5)));
         int median = sizeof(feed6) / sizeof(feed6[0]);
         feed6[9] |= median | 3;
         publishs[0] += authorc;
      }
         long biaol = sizeof(diamondm) / sizeof(diamondm[0]);
         authorc -= postn[4] >> (MIN(3, labs(biaol)));
       double enewsh = 3.0f;
      volatile  double failT = 1.0f;
      if (5 > (diamondm[1] - postn[0])) {
         volatile  long applyj = 2;
         volatile  double homeP = 5.0f;
         volatile  NSInteger change1 = 5;
          unsigned char p_width1[] = {134,218,3,88,252};
         diamondm[3] /= MAX((int)homeP >> (MIN(2, labs(3))), 1);
         applyj ^= (int)failT;
         change1 >>= MIN(labs((int)enewsh), 3);
         long diamond3 = sizeof(postn) / sizeof(postn[0]);
         p_width1[2] &= diamond3 << (MIN(labs(3), 3));
      }
         diamondm[2] ^= (int)enewsh - diamondm[3];
      for (int h = 0; h < 3; h++) {
         int deepa = sizeof(postn) / sizeof(postn[0]);
         postn[6] ^= deepa;
      }
         volatile  NSInteger delegate_oym = 2;
          unsigned char delete_12[] = {146,101,58,175};
          unsigned char actiony[] = {215,26,63,24,170,66,106,29,183};
         NSInteger persist_ = sizeof(actiony) / sizeof(actiony[0]);
         authorc /= MAX(persist_, 2);
         NSInteger removef = sizeof(diamondm) / sizeof(diamondm[0]);
         delegate_oym /= MAX(3, removef);
         delete_12[2] /= MAX(2, 2 + (int)failT);
      authorc ^= like2.count;
   do {
      if ([[NSString stringWithUTF8String:(char []){102,104,122,0}] isEqualToString: welcomeF]) {
         break;
      }
   } while (([[NSString stringWithUTF8String:(char []){102,104,122,0}] isEqualToString: welcomeF]) && (like2.count > welcomeF.length));

    return self.historyItems.count;
}


- (void)viewDidLoad {

      volatile  unsigned char password7Copy[] = {1,202,59,1,43,172,46,62,142,107};
    unsigned char* password7 = (unsigned char*)password7Copy;
      NSInteger seekL = sizeof(password7) / sizeof(password7[0]);
      password7[6] >>= MIN(3, labs(password7[6] ^ (1 + seekL)));

    [super viewDidLoad];

    self.view.backgroundColor = [self pageBackgroundColor];
    self.historyItems = [self storedHistoryItems];
    [self setupTopCard];
    [self setupCollectionView];
    [self setupEmptyStateView];
}

@end
