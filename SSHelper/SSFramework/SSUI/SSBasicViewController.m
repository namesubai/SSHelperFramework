//
//  SSBasicViewController.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/18.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "SSBasicViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SQActionSheetView.h"
#import "TZImagePickerController.h"
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "Categorise.h"
#import "SSHelperDefine.h"
#import "Masonry.h"



@interface SSBasicViewController ()<UISearchBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (assign, nonatomic) BOOL keyBoardisShow;
@property (strong, nonatomic)  ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) void(^leftAction)(id vc, id sender);
@property (nonatomic, strong) void(^rightAction)(id vc, id sender);

@end

@implementation SSBasicViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground)name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground)name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void)applicationWillEnterForeground{
    NSLog(@"进入前台");
}

- (void)applicationDidEnterBackground{
    NSLog(@"进入后台");
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformIdentity;
        
    }];
}
- (void)applicationDidBecomeActive{
    
}
- (void)addKeyBoardNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
- (void)removeKeyBoardNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UIKeyboardNotification

- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification
{
}

- (void)keyboardWillShow:(NSNotification *)keyboardNotificat{
    UIView*tempView = [self.view getFirstResponder];
    
    CGRect rect = [tempView.superview convertRect:tempView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGRect keyRect = [[keyboardNotificat.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat height = keyRect.origin.y - (rect.origin.y+rect.size.height);
    if (height <=0) {
        
        if (!_keyBoardisShow) {
            _keyBoardisShow = YES;
            [UIView animateWithDuration:0.2 animations:^{
                
                self.view.transform = CGAffineTransformMakeTranslation(0, height-20);
                //            NSLog(@"向上%@",NSStringFromCGRect(self.view.frame));
                
            }];
        }
        
    }
    
}

- (void)keyboardWillHide:(NSNotification *)keyboardNotificat{
    
    _keyBoardisShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        //        NSLog(@"向下%@",NSStringFromCGRect(self.view.frame));
        self.view.transform = CGAffineTransformIdentity;
        
    }];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.basicMoreMax = 20;
    self.maxImagesCount = 1;
    self.view.backgroundColor = Color_BG;
    
    [self setupViews];

    // Do any additional setup after loading the view.
}



- (NSMutableArray *)basicDataArray{
    if (!_basicDataArray) {
        _basicDataArray = @[].mutableCopy;
    }
    return _basicDataArray;
}
- (void)basicViewControllerBlock:(void (^)(id, id))block{
    self.basicViewControllerBlock = block;
}
- (void)setupViews{
    //子类重写
}

#pragma mark - 导航栏文字按钮
-(void)setLeftBarButtonWithTitle:(NSString *)title
                       textColor:(UIColor *)textColor
                        textFont:(UIFont *)textfont
                    buttonAction:(void (^)(id , id))block{
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    self.leftAction = block;
    
  
    [leftButton setTitleTextAttributes:@{NSFontAttributeName:!textfont?[UIFont systemFontOfSize:15]:textfont,NSForegroundColorAttributeName:textColor} forState:UIControlStateNormal];
     [leftButton setTitleTextAttributes:@{NSFontAttributeName:!textfont?[UIFont systemFontOfSize:15]:textfont,NSForegroundColorAttributeName:textColor} forState:UIControlStateSelected];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)leftAction:(UIBarButtonItem *)buttonItem{
    if (self.leftAction) {
        self.leftAction(self,buttonItem);
    }
}

-(void)setRightBarButtonWithTitle:(NSString *)title
                        textColor:(UIColor *)textColor
                         textFont:(UIFont *)textfont
                     buttonAction:(void (^)(id, id))block{
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    self.rightAction = block;
    
    [rightButton setTitleTextAttributes:@{NSFontAttributeName:!textfont?[UIFont systemFontOfSize:15]:textfont,NSForegroundColorAttributeName:textColor} forState:UIControlStateNormal];
    [rightButton setTitleTextAttributes:@{NSFontAttributeName:!textfont?[UIFont systemFontOfSize:15]:textfont,NSForegroundColorAttributeName:textColor} forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)rightAction:(UIBarButtonItem *)buttonItem{
    if (self.rightAction) {
        self.rightAction(self,buttonItem);
    }
}

- (void)setLeftBarButtonWithImages:(NSArray *)images buttonAction:(void (^)(id, id))block{
    

    if (images.count==1) {
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:images[0]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
         self.leftAction = block;
         self.navigationItem.leftBarButtonItem = leftButton;
    }else{
        NSMutableArray *tempArray = @[].mutableCopy;
        for (NSInteger i=0; i<images.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setImage:[[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            if (images.count>1) {
                [button sizeToFit];
            }
            
            UIBarButtonItem *buttonitem = [[UIBarButtonItem alloc]initWithCustomView:button];
            buttonitem.tag = i;
            [tempArray addObject:buttonitem];
            [button buttonClick:^(UIButton *button) {
                !block?:block(self,buttonitem);
            }];
        }
        self.navigationItem.leftBarButtonItems =  tempArray;
    }
    
    
   
}

- (void)setRightBarButtonWithImages:(NSArray *)images buttonAction:(void (^)(id, id))block{
    
    if (images.count==1) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:images[0]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
        self.rightAction = block;
        self.navigationItem.rightBarButtonItem = rightButton;
    }else{
        NSMutableArray *tempArray = @[].mutableCopy;
        for (NSInteger i=0; i<images.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setImage:[[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            if (images.count>1) {
                [button sizeToFit];
            }
            UIBarButtonItem *buttonitem = [[UIBarButtonItem alloc]initWithCustomView:button];
            buttonitem.tag = i;
            [tempArray addObject:buttonitem];
            [button buttonClick:^(UIButton *button) {
                !block?:block(self,buttonitem);
            }];
        }
        self.navigationItem.rightBarButtonItems =  tempArray;
    }
    
}

- (UIButton *)setTableViewFooterButtonTitle:(NSString *)title buttonBlock:(void (^)(id, id))block{
    UIView *footreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    
    UIButton *button = [UIButton returnButtonFram:CGRectZero
                                             type:UIButtonTypeSystem
                                            title:title
                                       titleColor:Color_White
                                     cornerRadius:(40*Scale)/2
                                         textFont:[UIFont systemFontOfSize:18]
                                   backgroudColor:Color_Blue];
    [footreView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.height.equalTo(@(40*Scale));
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
    }];
    @weakify(self);
    [button buttonClick:^(UIButton *button) {
        @strongify(self);
        !block?:block(self,button);
    }];
    self.basicTable.tableFooterView = footreView;
    return button;
}


#pragma mark - ImagePicker初始化
- (void)initImagePicker
{
    
    if (!_basicImagePicker) {
        _basicImagePicker = [[UIImagePickerController alloc] init];
        _basicImagePicker.delegate = self;
    }
}

#pragma mark - 拍照
- (void)takePhoto{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        //
        UIAlertView *alerView = [UIAlertView showWithTitle:@"温馨提示" message:@"请在iPhone的“设置-隐私-相机中允许访问相机。”" cancelButtonTitle:@"取消" otherButtonTitles:@[@"现在设置"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex==1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
        [alerView show];
        return;
    }
    
    self.basicImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.basicImagePicker.allowsEditing = _baseAllowsEditing;
    [self presentViewController:self.basicImagePicker animated:YES completion:nil];
    
}

#pragma mark - 打开相册
- (void)showLocalPhoto{
    
    /* kCLAuthorizationStatusNotDetermined = 0, // 用户尚未做出选择这个应用程序的问候
     kCLAuthorizationStatusRestricted,        // 此应用程序没有被授权访问的照片数据。可能是家长控制权限
     kCLAuthorizationStatusDenied,            // 用户已经明确否认了这一照片数据的应用程序访问
     kCLAuthorizationStatusAuthorized         // 用户已经授权应用访问照片数据
     */
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == AVAuthorizationStatusDenied) {
        //
        UIAlertView *alerView = [UIAlertView showWithTitle:@"温馨提示" message:@"请在iPhone的“设置-隐私中允许访问相册。”" cancelButtonTitle:@"取消" otherButtonTitles:@[@"现在设置"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex==1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
        [alerView show];
        return;
    }
    
    
    if (self.isShowSystemPhoto) {
        self.basicImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.basicImagePicker.allowsEditing = YES;
        [self presentViewController:self.basicImagePicker animated:YES completion:nil];
    }else{
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
        imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
        imagePickerVc.maxImagesCount  = _maxImagesCount;
        // 2. Set the appearance
        // 2. 在这里设置imagePickerVc的外观
        // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
        // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
        // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
        
        // 3. Set allow picking video & photo & originalPhoto or not
        // 3. 设置是否可以选择视频/图片/原图
        imagePickerVc.allowPickingVideo = NO;
        
        // 4. 照片排列按修改时间升序
        imagePickerVc.sortAscendingByModificationDate = YES;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            //        [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            //            NSLog(@"图片大小＝＝＝%ld",UIImagePNGRepresentation(obj).length);
            //        }];
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            
            @weakify(self)
            [self loadWithMessageinWindow:@"正在处理.."];
            __block NSInteger count = 0;
            NSMutableArray *tempImages = @[].mutableCopy;
            [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @strongify(self);
                [self returnNewdataSizeImage:obj maxLength:100 success:^(UIImage *returnImage) {
                    count++;
                    [tempImages addObject:returnImage];
                    if (count==photos.count) {
                        [self dismiss];
                        if ([_chosPhotoDelegate respondsToSelector:@selector(didChosePhotobaseViewController:images:assets:isSelectOriginalPhoto:)]) {
                            [_chosPhotoDelegate didChosePhotobaseViewController:self images:tempImages assets:nil isSelectOriginalPhoto:YES];
                        }
                    }
                }];
               
                
            }];
            
            
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    }
    
    
}


#pragma mark - 拍照,相册

- (void)showPhotoChose{
    
    
    
    [self initImagePicker];
    
    
    SQActionSheetView *sheet;
    BOOL isCamraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (isCamraAvailable) {
        
        @weakify(self);
        sheet = [[SQActionSheetView alloc]initWithTitle:@"请选择" buttons:@[@"拍照",@"从相册中选取",@"取消"] buttonClick:^(SQActionSheetView *sheetView, NSInteger buttonIndex) {
            @strongify(self);
            [self touchActionSheet:buttonIndex];
        }];
        
    }else{
        @weakify(self);
        sheet = [[SQActionSheetView alloc]initWithTitle:@"请选择" buttons:@[@"从相册中选取",@"取消"] buttonClick:^(SQActionSheetView *sheetView, NSInteger buttonIndex) {
            @strongify(self);
            [self touchActionSheet:buttonIndex];
            
        }];
        
        
    }
    [sheet showView];
    
    
    
}

- (void)touchActionSheet:(NSInteger)index{
    BOOL isCamraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    switch (index) {
        case 0: {
            //相册
            
            if (isCamraAvailable) {
                [self takePhoto];
            }else{
                
                [self showLocalPhoto];
            }
            
        }
            
            break;
        case 1:{
            //相机
            if (isCamraAvailable) {
                [self showLocalPhoto];
                break;
            }
        }
            
        default:
            return;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //    NSURL *url = info[UIImagePickerControllerReferenceURL];
    UIImage *orgImage;
    if (info[UIImagePickerControllerEditedImage]) {
        orgImage = info[UIImagePickerControllerEditedImage];
    }else if (info[UIImagePickerControllerOriginalImage]){
        orgImage = info[UIImagePickerControllerOriginalImage];
    }
    orgImage = [self fixOrientation:orgImage];
    if (!orgImage){
        return;
    }
    
    //    [self savePhotoWithImage:orgImage completion:^{
    //
    //    }];
    
    
    
    [self loadWithMessageinWindow:@"正在处理.."];
    @weakify(self);
    [self returnNewdataSizeImage:orgImage maxLength:100 success:^(UIImage *returnImage) {
        [self dismiss];

        @strongify(self);
        if ([_chosPhotoDelegate respondsToSelector:@selector(didChosePhotobaseViewController:imageData:)]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *imageData = UIImagePNGRepresentation(returnImage);
                dispatch_async(dispatch_get_main_queue(), ^{
                     [_chosPhotoDelegate didChosePhotobaseViewController:self imageData:imageData];
                });
            });
            
        }
        
        if ([_chosPhotoDelegate respondsToSelector:@selector(didChosePhotobaseViewController:images:assets:isSelectOriginalPhoto:)]) {
            
             [_chosPhotoDelegate didChosePhotobaseViewController:self images:@[returnImage] assets:nil isSelectOriginalPhoto:YES];
        }
        
    }];
    
   
    [self.basicImagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self.basicImagePicker dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark - 把拍照的旋转的图片纠正
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation ==UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform =CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma 保存图片
#pragma mark - Save photo

- (void)savePhotoWithImage:(UIImage *)image completion:(void (^)())completion {
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) { // 这里有坑... iOS8系统下这个方法保存图片会失败
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
            options.shouldMoveFile = YES;
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (success && completion) {
                    completion();
                } else if (error) {
                    NSLog(@"保存照片出错:%@",error.localizedDescription);
                }
            });
        }];
    } else {
        [self.assetLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:[self orientationFromImage:image] completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"保存图片失败:%@",error.localizedDescription);
            } else {
                if (completion) {
                    completion();
                }
            }
        }];
    }
}

- (ALAssetOrientation)orientationFromImage:(UIImage *)image {
    NSInteger orientation = image.imageOrientation;
    return orientation;
}

#pragma mark - 搜索框

- (void)setNavBarSearchBarRightButton:(BOOL)isShow
                    searchPlaceholder:(NSString *)placeholder
                     rightButtonTitle:(NSString *)title{
    
    _basicSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH - 40 , 30)];
    _basicSearchBar.delegate = self;
    _basicSearchBar.placeholder = placeholder;
    _basicSearchBar.tintColor = Color_Text_Secondary;
    //        _searchBar.barTintColor = Color_Text_Secondary;
    _basicSearchBar.showsCancelButton = isShow;
    UIImage * bgimg = [UIImage ss_imageWithColor:[UIColor clearColor]];
    
    _basicSearchBar.backgroundImage = bgimg;
    _rightButtonTitle = title;
    self.navigationItem.titleView = _basicSearchBar;
    
    
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([NSString validateCMWString:text]||[text isEqualToString:@""]||[text isEqualToString:@"\n"]) {
        return YES;
    }
    
    return NO;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    if (searchBar == _basicSearchBar) {
        [searchBar resignFirstResponder];
        
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar == _basicSearchBar){
        [searchBar resignFirstResponder];
        UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
        cancelBtn.enabled = YES; //把enabled设置为yes
    }
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    if (searchBar == _basicSearchBar) {
        searchBar.showsCancelButton = YES;
        for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
            if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                UIButton * cancel =(UIButton *)view;
                [cancel setTitle:_rightButtonTitle forState:UIControlStateNormal];
                cancel.titleLabel.font = [UIFont systemFontOfSize:16];
                [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    if (searchBar == _basicSearchBar) {
        searchBar.showsCancelButton = YES;
        for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
            if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                UIButton * cancel =(UIButton *)view;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [cancel setEnabled:YES];
                    
                });
            }
        }
    }
    
}

- (NoneView *)baseNoneView{
    
    if (!_baseNoneView) {
        _baseNoneView = [NoneView new];
        _baseNoneView.frame = (CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT-self.navHeight};
        [self.basicTable addSubview:_baseNoneView];
        //        [self.baseTable sendSubviewToBack:_baseNoneView];
        _baseNoneView.hidden = YES;
        
    }
    
    return _baseNoneView;
}


- (void)showNoneView{
    
    self.baseNoneView.hidden = NO;
}

- (void)hideNoneView{
    self.baseNoneView.hidden = YES;
}

- (void)setNoneViewHiden:(BOOL)hiden{
    self.baseNoneView.hidden =hiden;
}

- (void)setEndEdit:(BOOL)endEdit{
    _endEdit = endEdit;
    if (_endEdit) {
        self.basicTable.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tap.delegate = self;
        [self.view addGestureRecognizer:tap];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        
        return YES;
    }
    
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
