//
//  EditProfileViewController.m
//  Luket
//

#import "EditProfileViewController.h"
#import "../../Common/LuketMediaResource.h"
#import "../../Data/Service/LuketDataService.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const EditProfileAboutStorageKeyPrefix = @"ProfileAbout";

@interface EditProfileViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *formContentView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *avatarIconImageView;
@property (nonatomic, copy) NSString *selectedAvatarIdentifier;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextView *aboutTextView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, weak) UIView *activeInputView;
@property (nonatomic, assign) CGFloat keyboardOffset;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self pageBackgroundColor];
    [self setupViews];
    [self setupKeyboardHandling];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutEditViews];
}

- (void)setupViews {
    [self setupTopCard];
    [self setupFormCard];
    [self setupSaveButton];
    [self applyProfileData];
}

- (void)setupTopCard {
    UIView *topCardView = [[UIView alloc] init];
    topCardView.tag = 1001;
    topCardView.backgroundColor = UIColor.whiteColor;
    topCardView.layer.cornerRadius = 11.0;
    topCardView.layer.masksToBounds = YES;
    [self.view addSubview:topCardView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16.0, 0.0, 44.0, 56.0);
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [topCardView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = 1002;
    titleLabel.text = @"Edit";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [topCardView addSubview:titleLabel];
}

- (void)setupFormCard {
    self.formContentView = [[UIView alloc] init];
    [self.view addSubview:self.formContentView];
    
    UIImageView *formCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EditProfileFormCard"]];
    formCardView.tag = 1001;
    formCardView.contentMode = UIViewContentModeScaleToFill;
    [self.formContentView addSubview:formCardView];
    
    self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeHeroImage"]];
    self.avatarImageView.tag = 1002;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatarTapped)];
    [self.avatarImageView addGestureRecognizer:avatarTap];
    [self.formContentView addSubview:self.avatarImageView];

    self.avatarIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EditProfileChangeAvatarButton"]];
    self.avatarIconImageView.tag = 1005;
    self.avatarIconImageView.contentMode = UIViewContentModeBottomRight;
    self.avatarIconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatarTapped)];
    [self.avatarIconImageView addGestureRecognizer:iconTap];
    [self.formContentView addSubview:self.avatarIconImageView];
    
    UILabel *nameLabel = [self formTitleLabelWithText:@"Name"];
    nameLabel.tag = 1003;
    [self.formContentView addSubview:nameLabel];
    
    self.nameTextField = [self textFieldWithPlaceholder:@"Please enter"];
    [self.formContentView addSubview:self.nameTextField];
    
    UILabel *aboutLabel = [self formTitleLabelWithText:@"About  me"];
    aboutLabel.tag = 1004;
    [self.formContentView addSubview:aboutLabel];
    
    self.aboutTextView = [[UITextView alloc] init];
    self.aboutTextView.backgroundColor = [self inputColor];
    self.aboutTextView.layer.cornerRadius = 11.0;
    self.aboutTextView.layer.masksToBounds = YES;
    self.aboutTextView.delegate = self;
    self.aboutTextView.returnKeyType = UIReturnKeyDone;
    self.aboutTextView.text = @"Please enter";
    self.aboutTextView.textColor = [self placeholderColor];
    self.aboutTextView.font = [UIFont systemFontOfSize:14.0];
    self.aboutTextView.textContainerInset = UIEdgeInsetsMake(14.0, 16.0, 14.0, 16.0);
    [self.formContentView addSubview:self.aboutTextView];
}

- (void)applyProfileData {
    NSString *name = [self displayNameForUser:self.profileUser];
    if (name.length > 0) {
        self.nameTextField.text = name;
    }

    [self setImageView:self.avatarImageView identifier:self.profileUser.avatarUrl placeholderImageName:@"HomeHeroImage"];

    NSString *about = self.profileAboutText.length > 0 ? self.profileAboutText : [self fallbackAboutTextForUser:self.profileUser];
    if (about.length > 0) {
        self.aboutTextView.text = about;
        self.aboutTextView.textColor = UIColor.whiteColor;
    }
}

- (void)setupSaveButton {
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setImage:[[UIImage imageNamed:@"EditProfileSaveButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
}

- (void)layoutEditViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat safeTop = self.view.safeAreaInsets.top;
    CGFloat safeBottom = self.view.safeAreaInsets.bottom;
    CGFloat contentWidth = width - 40.0;
    
    UIView *topCardView = [self.view viewWithTag:1001];
    topCardView.frame = CGRectMake(20.0, safeTop + 5.0, contentWidth, 56.0);
    
    UILabel *titleLabel = [topCardView viewWithTag:1002];
    titleLabel.frame = topCardView.bounds;
    
    CGFloat formHeight = contentWidth * 398.0 / 340.0;
    self.formContentView.frame = CGRectMake(20.0, CGRectGetMaxY(topCardView.frame) + 39.0, contentWidth, formHeight);
    
    UIImageView *formCardView = [self.formContentView viewWithTag:1001];
    formCardView.frame = self.formContentView.bounds;
    
    UIImageView *avatarView = [self.formContentView viewWithTag:1002];
    avatarView.frame = CGRectMake((contentWidth - 70.0) / 2.0, 36.0, 70.0, 70.0);
    avatarView.layer.cornerRadius = 35.0;

    UIImageView *avatarIconView = [self.formContentView viewWithTag:1005];
    avatarIconView.frame = CGRectMake(CGRectGetMaxX(avatarView.frame) - 40.0,
                                      CGRectGetMaxY(avatarView.frame) - 26.0,
                                      40.0,
                                      26.0);
    
    UILabel *nameLabel = [self.formContentView viewWithTag:1003];
    nameLabel.frame = CGRectMake(20.0, 145.0, contentWidth - 40.0, 28.0);
    
    self.nameTextField.frame = CGRectMake(20.0, 184.0, contentWidth - 40.0, 41.0);
    
    UILabel *aboutLabel = [self.formContentView viewWithTag:1004];
    aboutLabel.frame = CGRectMake(20.0, 253.0, contentWidth - 40.0, 28.0);
    
    self.aboutTextView.frame = CGRectMake(20.0, 292.0, contentWidth - 40.0, 100.0);
    
    CGFloat saveWidth = 250.0;
    CGFloat saveHeight = 59.0;
    self.saveButton.frame = CGRectMake((width - saveWidth) / 2.0,
                                       height - safeBottom - saveHeight - 20.0,
                                       saveWidth,
                                       saveHeight);
    
    self.formContentView.transform = CGAffineTransformMakeTranslation(0.0, -self.keyboardOffset);
    self.saveButton.transform = CGAffineTransformMakeTranslation(0.0, -self.keyboardOffset);
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [self inputColor];
    textField.layer.cornerRadius = 11.0;
    textField.layer.masksToBounds = YES;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.textColor = UIColor.whiteColor;
    textField.font = [UIFont systemFontOfSize:14.0];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 16.0, 1.0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                       attributes:@{NSForegroundColorAttributeName: [self placeholderColor]}];
    return textField;
}

- (UILabel *)formTitleLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [self titleColor];
    label.font = [self titleFontWithSize:20.0];
    return label;
}

- (void)setupKeyboardHandling {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [self.view convertRect:[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    CGRect inputFrame = [self.activeInputView convertRect:self.activeInputView.bounds toView:self.view];
    CGFloat overlap = CGRectGetMaxY(inputFrame) + 20.0 - CGRectGetMinY(keyboardFrame);
    self.keyboardOffset = MAX(overlap, 0.0);
    
    [self animateWithKeyboardNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardOffset = 0.0;
    [self animateWithKeyboardNotification:notification];
}

- (void)animateWithKeyboardNotification:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutEditViews];
    } completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeInputView = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.activeInputView = textView;
    if ([textView.text isEqualToString:@"Please enter"]) {
        textView.text = @"";
        textView.textColor = UIColor.whiteColor;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = @"Please enter";
        textView.textColor = [self placeholderColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonTapped {
    [self.view endEditing:YES];
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSString *about = [self.aboutTextView.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if ([about isEqualToString:@"Please enter"]) {
        about = @"";
    }

    if (name.length == 0) {
        [self showAlertWithMessage:@"Please enter your name."];
        return;
    }

    LuketGlobalData *globalData = self.globalData ?: LuketDataService.sharedService.cachedGlobalData;
    NSString *userId = self.profileUser.userId.length > 0 ? self.profileUser.userId : LuketDataService.sharedService.currentLoginUserId;
    if (!globalData || userId.length == 0) {
        [self saveAboutText:about userId:userId];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    LuketUser *targetUser = [self userWithId:userId globalData:globalData];
    targetUser.nickname = name;
    self.profileUser.nickname = name;
    [self saveAboutText:about userId:userId];

    self.saveButton.enabled = NO;
    [[LuketDataService sharedService] saveGlobalData:globalData completion:^(BOOL success, NSString *message, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.saveButton.enabled = YES;
            if (!success || error) {
                [self showAlertWithMessage:error.localizedDescription ?: @"Save failed."];
                return;
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (LuketUser *)userWithId:(NSString *)userId globalData:(LuketGlobalData *)globalData {
    for (LuketUser *user in globalData.userList) {
        if ([user.userId isEqualToString:userId]) {
            return user;
        }
    }
    return self.profileUser;
}

- (void)saveAboutText:(NSString *)about userId:(NSString *)userId {
    if (userId.length == 0) {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%@.%@", EditProfileAboutStorageKeyPrefix, userId];
    if (about.length > 0) {
        [NSUserDefaults.standardUserDefaults setObject:about forKey:key];
    } else {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
    }
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)displayNameForUser:(LuketUser *)user {
    if (user.nickname.length > 0) {
        return user.nickname;
    }
    if (user.email.length > 0) {
        return user.email;
    }
    if (user.userId.length > 0) {
        return user.userId;
    }
    return @"";
}

- (NSString *)fallbackAboutTextForUser:(LuketUser *)user {
    if (user.email.length > 0) {
        return user.email;
    }
    if (user.gender.length > 0 && user.age > 0) {
        return [NSString stringWithFormat:@"%@  %ld", user.gender, (long)user.age];
    }
    if (user.gender.length > 0) {
        return user.gender;
    }
    if (user.age > 0) {
        return [NSString stringWithFormat:@"%ld", (long)user.age];
    }
    return @"";
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)changeAvatarTapped {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    if (image) {
        self.avatarImageView.image = image;
        self.selectedAvatarIdentifier = [self saveAvatarImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)saveAvatarImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.85);
    if (imageData.length == 0) {
        return @"";
    }

    NSString *userId = self.profileUser.userId.length > 0 ? self.profileUser.userId : LuketDataService.sharedService.currentLoginUserId;
    NSString *fileName = [NSString stringWithFormat:@"ProfileAvatar.%@.jpg", userId.length > 0 ? userId : NSUUID.UUID.UUIDString];
    NSURL *documentsURL = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL *avatarsURL = [documentsURL URLByAppendingPathComponent:@"Avatars" isDirectory:YES];
    NSError *directoryError;
    [NSFileManager.defaultManager createDirectoryAtURL:avatarsURL withIntermediateDirectories:YES attributes:nil error:&directoryError];
    if (directoryError) {
        return @"";
    }

    NSURL *fileURL = [avatarsURL URLByAppendingPathComponent:fileName];
    NSError *writeError;
    BOOL saved = [imageData writeToURL:fileURL options:NSDataWritingAtomic error:&writeError];
    return saved && !writeError ? fileURL.path : @"";
}

- (void)setImageView:(UIImageView *)imageView identifier:(NSString *)identifier placeholderImageName:(NSString *)placeholderImageName {
    UIImage *placeholderImage = [UIImage imageNamed:placeholderImageName];
    UIImage *localImage = [LuketMediaResource localImageWithIdentifier:identifier];
    if (localImage) {
        [imageView sd_cancelCurrentImageLoad];
        imageView.image = localImage;
        return;
    }

    NSURL *imageURL = [LuketMediaResource imageURLWithIdentifier:identifier];
    if (!imageURL) {
        [imageView sd_cancelCurrentImageLoad];
        imageView.image = placeholderImage;
        return;
    }

    [imageView sd_setImageWithURL:imageURL
                 placeholderImage:placeholderImage
                          options:SDWebImageRetryFailed | SDWebImageScaleDownLargeImages];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIColor *)inputColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIColor *)placeholderColor {
    return [UIColor colorWithRed:132.0 / 255.0 green:150.0 / 255.0 blue:174.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

@end
