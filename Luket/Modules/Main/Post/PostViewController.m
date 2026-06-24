//
//  PostViewController.m
//  Luket
//

#import "PostViewController.h"

@interface PostViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *topCardView;
@property (nonatomic, strong) UIView *copywriterCardView;
@property (nonatomic, strong) UITextView *copywriterTextView;
@property (nonatomic, strong) UIView *uploadCardView;
@property (nonatomic, strong) UIScrollView *uploadScrollView;
//@property (nonatomic, strong) UILabel *uploadCountLabel;
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImages;
@property (nonatomic, strong) UIView *photoSourceDimmingView;
@property (nonatomic, strong) UIView *photoSourceSheetView;
@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [self pageBackgroundColor];
    self.selectedImages = [NSMutableArray array];
    [self setupViews];
    [self setupKeyboardHandling];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}

- (void)setupViews {
    [self setupTopCard];
    [self setupCopywriterCard];
    [self setupUploadCard];
}

- (void)setupTopCard {
    self.topCardView = [[UIView alloc] init];
    self.topCardView.backgroundColor = UIColor.whiteColor;
    self.topCardView.layer.cornerRadius = 9.0;
    self.topCardView.layer.masksToBounds = YES;
    [self.view addSubview:self.topCardView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16.0, 10.0, 32.0, 32.0);
    [backButton setImage:[[UIImage imageNamed:@"AuthBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topCardView addSubview:backButton];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.0, 0.0, 140.0, 52.0)];
    titleLabel.text = @"Post";
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:20.0];
    [self.topCardView addSubview:titleLabel];

    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.tag = 1005;
    [sendButton setImage:[[UIImage imageNamed:@"DetailSendButtonBackground"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(postButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topCardView addSubview:sendButton];
}

- (void)setupCopywriterCard {
    self.copywriterCardView = [[UIView alloc] init];
    [self.view addSubview:self.copywriterCardView];

    UIImageView *cardBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PostCardBackground"]];
    cardBackgroundView.tag = 1009;
    cardBackgroundView.contentMode = UIViewContentModeScaleToFill;
    [self.copywriterCardView addSubview:cardBackgroundView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"Copywriter";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:17.0];
    titleLabel.tag = 1001;
    [self.copywriterCardView addSubview:titleLabel];

    self.copywriterTextView = [[UITextView alloc] init];
    self.copywriterTextView.backgroundColor = [self inputColor];
    self.copywriterTextView.layer.cornerRadius = 8.0;
    self.copywriterTextView.layer.masksToBounds = YES;
    self.copywriterTextView.delegate = self;
    self.copywriterTextView.text = @"Please enter";
    self.copywriterTextView.textColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    self.copywriterTextView.font = [UIFont systemFontOfSize:14.0];
    self.copywriterTextView.textContainerInset = UIEdgeInsetsMake(12.0, 17.0, 12.0, 17.0);
    [self.copywriterCardView addSubview:self.copywriterTextView];
}

- (void)setupUploadCard {
    self.uploadCardView = [[UIView alloc] init];
    self.uploadCardView.backgroundColor = UIColor.whiteColor;
    self.uploadCardView.layer.cornerRadius = 9.0;
    self.uploadCardView.layer.masksToBounds = YES;
    [self.view addSubview:self.uploadCardView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"Upload";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [self titleColor];
    titleLabel.font = [self titleFontWithSize:18.0];
    titleLabel.tag = 1002;
    [self.uploadCardView addSubview:titleLabel];

//    self.uploadCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.uploadCountLabel.textColor = [self titleColor];
//    self.uploadCountLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
//    [self.uploadCardView addSubview:self.uploadCountLabel];

    self.uploadScrollView = [[UIScrollView alloc] init];
    self.uploadScrollView.showsHorizontalScrollIndicator = NO;
    self.uploadScrollView.alwaysBounceHorizontal = YES;
    [self.uploadCardView addSubview:self.uploadScrollView];

    UIImageView *addPhotoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PostUploadAddButton"]];
    addPhotoView.tag = 1006;
    addPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    addPhotoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhotoTapped)];
    [addPhotoView addGestureRecognizer:addTap];
    [self.uploadScrollView addSubview:addPhotoView];

    [self updateUploadImages];
}

- (void)layoutViews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat topY = self.view.safeAreaInsets.top + 5.0;
    CGFloat inputOffset = self.keyboardHeight > 0.0 ? -self.keyboardHeight * 0.35 : 0.0;

    self.topCardView.frame = CGRectMake(20.0, topY, width - 40.0, 56.0);
    UIButton *sendButton = [self.topCardView viewWithTag:1005];
    sendButton.frame = CGRectMake(CGRectGetWidth(self.topCardView.bounds) - 96.0, 5.0, 80.0, 44.0);

    self.copywriterCardView.frame = CGRectMake(20.0, CGRectGetMaxY(self.topCardView.frame) + 5.0 + inputOffset, width - 40.0, 222.0);
    UIImageView *copywriterCardBackgroundView = [self.copywriterCardView viewWithTag:1009];
    copywriterCardBackgroundView.frame = self.copywriterCardView.bounds;
    UILabel *copywriterTitleLabel = [self.copywriterCardView viewWithTag:1001];
    copywriterTitleLabel.frame = CGRectMake(0.0, 44.0, CGRectGetWidth(self.copywriterCardView.bounds), 22.0);
    self.copywriterTextView.frame = CGRectMake(26.0, 78.0, CGRectGetWidth(self.copywriterCardView.bounds) - 52.0, 125.0);

    self.uploadCardView.frame = CGRectMake(20.0, CGRectGetMaxY(self.copywriterCardView.frame) + 19.0, width - 40.0, 230.0);
    UILabel *uploadTitleLabel = [self.uploadCardView viewWithTag:1002];
    [uploadTitleLabel sizeToFit];
//    [self.uploadCountLabel sizeToFit];
//    CGFloat titleGroupWidth = CGRectGetWidth(uploadTitleLabel.bounds) + 12.0 + CGRectGetWidth(self.uploadCountLabel.bounds);
    CGFloat titleX = (CGRectGetWidth(self.uploadCardView.bounds) - 40) / 2.0;
    uploadTitleLabel.frame = CGRectMake(titleX, 18.0, CGRectGetWidth(uploadTitleLabel.bounds), 24.0);
//    self.uploadCountLabel.frame = CGRectMake(CGRectGetMaxX(uploadTitleLabel.frame) + 12.0, 22.0, CGRectGetWidth(self.uploadCountLabel.bounds), 16.0);

    self.uploadScrollView.frame = CGRectMake(26.0, 61.0, CGRectGetWidth(self.uploadCardView.bounds) - 26.0, 125.0);
    UIView *addPhotoView = [self.uploadScrollView viewWithTag:1006];
    addPhotoView.frame = CGRectMake(0.0, 0.0, 125.0, 125.0);

    CGFloat contentWidth = CGRectGetMaxX(addPhotoView.frame);
    for (NSUInteger index = 0; index < self.selectedImages.count; index++) {
        UIImageView *imageView = [self.uploadScrollView viewWithTag:1100 + index];
        imageView.frame = CGRectMake(136.0 * (index + 1), 0.0, 125.0, 125.0);
        contentWidth = CGRectGetMaxX(imageView.frame);
    }
    self.uploadScrollView.contentSize = CGSizeMake(contentWidth + 26.0, 125.0);
    [self layoutPhotoSourceSheet];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    self.keyboardHeight = CGRectGetHeight(self.view.bounds) - CGRectGetMinY(keyboardFrame);

    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutViews];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardHeight = 0.0;

    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        [self layoutViews];
    } completion:nil];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)addPhotoTapped {
    if (self.selectedImages.count >= 4) {
        [self showAlertWithMessage:@"You can add up to 4 photos."];
        return;
    }

    [self.view endEditing:YES];

    [self showPhotoSourceSheet];
}

- (void)showPhotoSourceSheet {
    if (self.photoSourceSheetView) {
        return;
    }

    self.photoSourceDimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.photoSourceDimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPhotoSourceSheet)];
    [self.photoSourceDimmingView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.photoSourceDimmingView];

    self.photoSourceSheetView = [[UIView alloc] initWithFrame:CGRectZero];
    self.photoSourceSheetView.backgroundColor = UIColor.whiteColor;
    self.photoSourceSheetView.layer.cornerRadius = 16.0;
    self.photoSourceSheetView.layer.masksToBounds = YES;
    [self.view addSubview:self.photoSourceSheetView];

    UIButton *cameraButton = [self photoSourceButtonWithTitle:@"Camera" action:@selector(cameraSourceTapped)];
    cameraButton.tag = 1301;
    [self.photoSourceSheetView addSubview:cameraButton];

    UIButton *libraryButton = [self photoSourceButtonWithTitle:@"Photo Library" action:@selector(librarySourceTapped)];
    libraryButton.tag = 1302;
    [self.photoSourceSheetView addSubview:libraryButton];

    UIView *separatorView = [[UIView alloc] init];
    separatorView.tag = 1303;
    separatorView.backgroundColor = [UIColor colorWithRed:226.0 / 255.0 green:233.0 / 255.0 blue:241.0 / 255.0 alpha:1.0];
    [self.photoSourceSheetView addSubview:separatorView];

    UIView *gapView = [[UIView alloc] init];
    gapView.tag = 1304;
    gapView.backgroundColor = [self pageBackgroundColor];
    [self.photoSourceSheetView addSubview:gapView];

    UIButton *cancelButton = [self photoSourceButtonWithTitle:@"Cancel" action:@selector(dismissPhotoSourceSheet)];
    cancelButton.tag = 1305;
    [self.photoSourceSheetView addSubview:cancelButton];

    [self layoutPhotoSourceSheetAtHiddenPosition];
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.photoSourceDimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.38];
        [self layoutPhotoSourceSheet];
    } completion:nil];
}

- (UIButton *)photoSourceButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColor.whiteColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[self titleColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)layoutPhotoSourceSheet {
    if (!self.photoSourceSheetView) {
        return;
    }

    self.photoSourceDimmingView.frame = self.view.bounds;

    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat safeBottom = self.view.safeAreaInsets.bottom;
    CGFloat buttonHeight = 56.0;
    CGFloat gapHeight = 8.0;
    CGFloat separatorHeight = 1.0;
    CGFloat sheetHeight = buttonHeight * 3.0 + gapHeight + separatorHeight + safeBottom;
    self.photoSourceSheetView.frame = CGRectMake(0.0,
                                                 CGRectGetHeight(self.view.bounds) - sheetHeight,
                                                 width,
                                                 sheetHeight);

    UIButton *cameraButton = [self.photoSourceSheetView viewWithTag:1301];
    UIButton *libraryButton = [self.photoSourceSheetView viewWithTag:1302];
    UIView *separatorView = [self.photoSourceSheetView viewWithTag:1303];
    UIView *gapView = [self.photoSourceSheetView viewWithTag:1304];
    UIButton *cancelButton = [self.photoSourceSheetView viewWithTag:1305];

    cameraButton.frame = CGRectMake(0.0, 0.0, width, buttonHeight);
    separatorView.frame = CGRectMake(20.0, buttonHeight, width - 40.0, 1.0);
    libraryButton.frame = CGRectMake(0.0, buttonHeight + 1.0, width, buttonHeight);
    gapView.frame = CGRectMake(0.0, CGRectGetMaxY(libraryButton.frame), width, gapHeight);
    cancelButton.frame = CGRectMake(0.0, CGRectGetMaxY(gapView.frame), width, buttonHeight);
}

- (void)layoutPhotoSourceSheetAtHiddenPosition {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat safeBottom = self.view.safeAreaInsets.bottom;
    CGFloat sheetHeight = 56.0 * 3.0 + 8.0 + 1.0 + safeBottom;
    self.photoSourceDimmingView.frame = self.view.bounds;
    self.photoSourceSheetView.frame = CGRectMake(0.0, CGRectGetHeight(self.view.bounds), width, sheetHeight);
}

- (void)dismissPhotoSourceSheet {
    if (!self.photoSourceSheetView) {
        return;
    }

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.photoSourceDimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        [self layoutPhotoSourceSheetAtHiddenPosition];
    } completion:^(BOOL finished) {
        [self.photoSourceSheetView removeFromSuperview];
        [self.photoSourceDimmingView removeFromSuperview];
        self.photoSourceSheetView = nil;
        self.photoSourceDimmingView = nil;
    }];
}

- (void)cameraSourceTapped {
    [self dismissPhotoSourceSheetWithCompletion:^{
        [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
}

- (void)librarySourceTapped {
    [self dismissPhotoSourceSheetWithCompletion:^{
        [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
}

- (void)dismissPhotoSourceSheetWithCompletion:(void (^)(void))completion {
    if (!self.photoSourceSheetView) {
        if (completion) {
            completion();
        }
        return;
    }

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.photoSourceDimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        [self layoutPhotoSourceSheetAtHiddenPosition];
    } completion:^(BOOL finished) {
        [self.photoSourceSheetView removeFromSuperview];
        [self.photoSourceDimmingView removeFromSuperview];
        self.photoSourceSheetView = nil;
        self.photoSourceDimmingView = nil;
        if (completion) {
            completion();
        }
    }];
}

- (void)presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        NSString *message = sourceType == UIImagePickerControllerSourceTypeCamera ? @"Camera is not available." : @"Photo Library is not available.";
        [self showAlertWithMessage:message];
        return;
    }

    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = sourceType;
    pickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)postButtonTapped {
    [self.view endEditing:YES];

    NSString *copywriter = [self.copywriterTextView.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (copywriter.length == 0 || [copywriter isEqualToString:@"Please enter"]) {
        [self showAlertWithMessage:@"Please enter copywriter."];
        return;
    }

    if (self.selectedImages.count == 0) {
        [self showAlertWithMessage:@"Please upload at least one photo."];
        return;
    }

    [self showPostSuccessAlert];
}

- (void)showPostSuccessAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"Post submitted successfully. It is under review."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateUploadImages {
    for (UIView *subview in self.uploadScrollView.subviews) {
        if (subview.tag >= 1100) {
            [subview removeFromSuperview];
        }
    }

    [self.selectedImages enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger index, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tag = 1100 + index;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 8.0;
        [self.uploadScrollView addSubview:imageView];
    }];

//    self.uploadCountLabel.text = [NSString stringWithFormat:@"(%lu/4)", (unsigned long)self.selectedImages.count];
    [self layoutViews];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image && self.selectedImages.count < 4) {
        [self.selectedImages insertObject:image atIndex:0];
        [self updateUploadImages];
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Please enter"]) {
        textView.text = @"";
        textView.textColor = UIColor.whiteColor;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = @"Please enter";
        textView.textColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    }
}

- (UIColor *)pageBackgroundColor {
    return [UIColor colorWithRed:181.0 / 255.0 green:221.0 / 255.0 blue:244.0 / 255.0 alpha:1.0];
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:32.0 / 255.0 green:60.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
}

- (UIColor *)inputColor {
    return [UIColor colorWithRed:31.0 / 255.0 green:62.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
}

- (UIFont *)titleFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PangMenZhengDao" size:size];
    return font ?: [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
