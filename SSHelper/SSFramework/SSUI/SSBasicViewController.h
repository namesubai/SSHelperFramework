//
//  SSBasicViewController.h
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/18.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "BasicRefreshViewController.h"
#import "NoneView.h"

@class BasicRefreshViewController;
@protocol BasicRefreshViewControllerChosePhotoDelegate <NSObject>

@optional
- (void)didChosePhotobaseViewController:(BasicRefreshViewController *)viewcontroller imageData:(NSData *)imageData;
- (void)didChosePhotobaseViewController:(BasicRefreshViewController *)viewcontroller images:(NSArray *)photos assets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;
@end

@interface SSBasicViewController : BasicRefreshViewController

//app活动回调
- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;
- (void)applicationDidBecomeActive;

/**
 *  添加键盘通知
 */
- (void)addKeyBoardNotification;
/**
 *  移除键盘通知
 */
- (void)removeKeyBoardNotification;
- (void)keyboardWillShow:(NSNotification *)keyboardNotificat;
- (void)keyboardWillHide:(NSNotification *)keyboardNotificat;
- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification;

@property (nonatomic, strong) NSMutableArray *basicDataArray;//数据源
@property (nonatomic, assign) NSInteger basicFirst;//数据请求分页
@property (nonatomic, assign) NSInteger basicMoreMax;//上拉加载更多数据条数,默认20条
@property (nonatomic, copy) void(^basicViewControllerBlock)(id vc,id sender);
- (void)basicViewControllerBlock:(void(^)(id vc,id sender))block;
- (void)setupViews;
//文字按钮
- (void)setLeftBarButtonWithTitle:(NSString *)title
                        textColor:(UIColor *)textColor
                         textFont:(UIFont *)textfont
                     buttonAction:(void(^)(id vc,id sender))block;
- (void)setRightBarButtonWithTitle:(NSString *)title
                         textColor:(UIColor *)textColor
                          textFont:(UIFont *)textfont
                      buttonAction:(void(^)(id vc,id sender))block;

//图片按钮
- (void)setLeftBarButtonWithImages:(NSArray *)images buttonAction:(void(^)(id vc,id sender))block;
- (void)setRightBarButtonWithImages:(NSArray *)images buttonAction:(void(^)(id vc,id sender))block;

//tableview底部按钮
- (UIButton *)setTableViewFooterButtonTitle:(NSString *)title buttonBlock:(void(^)(id vc, id sender))block;


//拍照和图片选择
@property (strong, nonatomic) UIImagePickerController *basicImagePicker;
@property (weak, nonatomic) id<BasicRefreshViewControllerChosePhotoDelegate>chosPhotoDelegate;
@property (assign, nonatomic) NSInteger maxImagesCount;//选择图片最大张数
@property (assign, nonatomic) BOOL isShowSystemPhoto; //是否用系统自带的相册
@property (assign, nonatomic) BOOL baseAllowsEditing;
- (void)showPhotoChose;//展示图片选择
- (void)savePhotoWithImage:(UIImage *)image completion:(void (^)())completion;//保存图片
- (void)takePhoto;//拍照
- (void)showLocalPhoto;//打开相册

//导航栏搜索
@property (strong, nonatomic) UISearchBar *basicSearchBar;
@property (copy, nonatomic)  NSString *rightButtonTitle;
- (void)setNavBarSearchBarRightButton:(BOOL)isShow searchPlaceholder:(NSString *)placeholder rightButtonTitle:(NSString *)title;
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;

/**
 *  内容为空页
 */
@property (strong, nonatomic) NoneView *baseNoneView;//内容为空页
-(void)showNoneView;
-(void)hideNoneView;
- (void)setNoneViewHiden:(BOOL)hiden;

@property (nonatomic, assign) BOOL endEdit;

@end
