//
//  NSObject+HUD.h
//  JHTDoctor
//
//  Created by yangsq on 16/6/3.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@interface NSObject (HUD)

@property (strong, nonatomic) MBProgressHUD *baseHUD;


- (void)loadWithMessage:(NSString *)message;

- (void)showWithMessage:(NSString *)message;

- (void)showbottomWithMessage:(NSString *)message;

- (void)showAlertMessage:(NSString *)message;

- (void)dismiss;

- (void)showWithMessage:(NSString *)message finish:(void(^)(void))finish;

- (void)showSuccessWithMessage:(NSString *)message finish:(void(^)(void))finish;
- (void)showSuccessWithMessageinWindow:(NSString *)message finish:(void(^)(void))finish;


//网络错误
- (void)showErrorHUD;
//正在加载
- (void)showloadHUD;

- (void)showWithMessageinWindow:(NSString *)message;
- (void)showWithMessageinWindow:(NSString *)message finish:(void(^)(void))finish;
- (void)loadWithMessageinWindow:(NSString *)message;


@end
