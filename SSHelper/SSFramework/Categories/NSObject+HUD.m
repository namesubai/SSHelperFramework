//
//  NSObject+HUD.m
//  JHTDoctor
//
//  Created by yangsq on 16/6/3.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "NSObject+HUD.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "ArcView.h"
#import "SSHelperKit.h"
#import "Masonry.h"


static void   *  baseHUDKey              = &baseHUDKey;

@implementation NSObject (HUD)

- (void)showWithMessageinWindow:(NSString *)message finish:(void (^)(void))finish{
    [self returnShowinWindowWithMessage:message finish:finish];
}


- (void)showWithMessage:(NSString *)message{
    
    [self returnshowWithMessage:message isbottom:NO finish:^{
        
    }];
}

- (void)showWithMessage:(NSString *)message finish:(void (^)(void))finish{
    [self returnshowWithMessage:message isbottom:NO finish:^{
        finish();
    }];
    
}

- (void)showSuccessWithMessage:(NSString *)message finish:(void (^)(void))finish{
     [self returnshowSuccessWithMessage:message isbottom:NO finish:^{
         finish();
     }];
}

- (void)showSuccessWithMessageinWindow:(NSString *)message finish:(void (^)(void))finish{
    [self returnshowSuccessWindowWithMessage:message finish:^{
        finish();
    }];
}


- (void)showbottomWithMessage:(NSString *)message{
    [self returnshowWithMessage:message isbottom:YES finish:^{
        
    }];

}

- (void)loadWithMessage:(NSString *)message{
    
    [self returnHUBWithMessage:message];
}

- (void)showAlertMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
}

- (void)returnshowSuccessWithMessage:(NSString *)message isbottom:(BOOL)isbottom finish:(void(^)(void))finish{
    UIView * superview = [self SuperView1];
    if (!superview) {
        return;
    }
    self.baseHUD = [MBProgressHUD showHUDAddedTo:superview animated:YES];
    self.baseHUD.bezelView.backgroundColor = SS_ColorWithHexString(@"2c2c2c");
    self.baseHUD.mode = MBProgressHUDModeCustomView;
    self.baseHUD.margin =13.f;
    UIImage *image = [UIImage imageNamed:[SSHELPER_BUNDLE_IMAGEPATH stringByAppendingPathComponent:@"success"]];;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.baseHUD.customView = imageView;
    // Looks a bit nicer if we make it square.
    self.baseHUD.square = YES;
    self.baseHUD.label.font = [UIFont systemFontOfSize:16];
    self.baseHUD.label.text = message;
    [self.baseHUD hideAnimated:YES afterDelay:2];
    self.baseHUD.label.textColor = [UIColor whiteColor];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        finish();
    });
}


- (void)returnshowSuccessWindowWithMessage:(NSString *)message finish:(void(^)(void))finish{
    UIView * superview = [UIApplication sharedApplication].keyWindow;
    if (!superview) {
        return;
    }
    self.baseHUD = [MBProgressHUD showHUDAddedTo:superview animated:YES];
    self.baseHUD.bezelView.backgroundColor = SS_ColorWithHexString(@"2c2c2c");
    self.baseHUD.mode = MBProgressHUDModeCustomView;
    self.baseHUD.margin =13.f;
    UIImage *image = [UIImage imageNamed:[SSHELPER_BUNDLE_IMAGEPATH stringByAppendingPathComponent:@"success"]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.baseHUD.customView = imageView;
    // Looks a bit nicer if we make it square.
    self.baseHUD.square = YES;
    self.baseHUD.label.font = [UIFont systemFontOfSize:16];

    self.baseHUD.label.text = message;
    [self.baseHUD hideAnimated:YES afterDelay:2];
    self.baseHUD.label.textColor = [UIColor whiteColor];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        finish();
    });
}


- (void)returnshowWithMessage:(NSString *)message isbottom:(BOOL)isbottom finish:(void(^)(void))finish{
    UIView * superview = [self SuperView1];
    if (!superview) {
        return;
    }
    self.baseHUD = [MBProgressHUD showHUDAddedTo:superview animated:YES];
    self.baseHUD.userInteractionEnabled = NO;
    self.baseHUD.bezelView.backgroundColor = SS_ColorWithHexString(@"2c2c2c");
    self.baseHUD.mode = MBProgressHUDModeText;
    self.baseHUD.margin =13.f;
    self.baseHUD.label.text = message;
    self.baseHUD.removeFromSuperViewOnHide = YES;
    self.baseHUD.label.font = [UIFont systemFontOfSize:16];
    self.baseHUD.animationType = MBProgressHUDAnimationZoom;
    self.baseHUD.label.textColor = [UIColor whiteColor];

    if (isbottom) {
        self.baseHUD.offset = CGPointMake(0.f, MBProgressMaxOffset);
    }
    
    [self.baseHUD hideAnimated:YES afterDelay:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        finish();
    });
  
}

- (void)returnHUBWithMessage:(NSString *)message{
    
    
    UIView * superview = [self SuperView1];
    if (!superview) {
        return;
    }
    if ([self.baseHUD.superview.superview isEqual:superview.superview]) {
        [self.baseHUD dismiss];
    }
    self.baseHUD = [MBProgressHUD showHUDAddedTo:superview animated:YES];
    self.baseHUD.bezelView.backgroundColor = SS_ColorWithHexString(@"2c2c2c");
    self.baseHUD.mode = MBProgressHUDModeCustomView;
    self.baseHUD.customView = [self returnArcView];
//    self.baseHUD.activityIndicatorColor = [UIColor whiteColor];
    self.baseHUD.margin =13.f;
    self.baseHUD.removeFromSuperViewOnHide = YES;
    self.baseHUD.label.font = [UIFont systemFontOfSize:16];
    self.baseHUD.label.textColor = [UIColor whiteColor];

    if ([message length]>0 || message!=nil) {
        self.baseHUD.label.text = message;
    }
}

- (void)returnHUBonWindowWithMessage:(NSString *)message {
    
    UIView * superview = [UIApplication sharedApplication].keyWindow;
    if (!superview) {
        return;
    }
  
    self.baseHUD = [MBProgressHUD showHUDAddedTo:superview animated:YES];
    self.baseHUD.bezelView.backgroundColor = SS_ColorWithHexString(@"2c2c2c");
    self.baseHUD.mode = MBProgressHUDModeCustomView;
    self.baseHUD.customView = [self returnArcView];
//    self.baseHUD.activityIndicatorColor = [UIColor whiteColor];
    self.baseHUD.removeFromSuperViewOnHide = YES;
    self.baseHUD.margin =13.f;
    self.baseHUD.label.font = [UIFont systemFontOfSize:16];
    self.baseHUD.label.textColor = [UIColor whiteColor];

    if ([message length]>0 || message!=nil) {
        self.baseHUD.label.text = message;
    }
}

- (void)returnShowinWindowWithMessage:(NSString *)message finish:(void(^)(void))finish{
    UIView * superview = [UIApplication sharedApplication].keyWindow;
    if (!superview) {
        return;
    }
    self.baseHUD = [MBProgressHUD showHUDAddedTo:superview animated:YES];
    self.baseHUD.userInteractionEnabled = NO;
    self.baseHUD.bezelView.backgroundColor = SS_ColorWithHexString(@"2c2c2c");
    self.baseHUD.mode = MBProgressHUDModeText;
    self.baseHUD.removeFromSuperViewOnHide = YES;
    self.baseHUD.margin =13.f;
    self.baseHUD.label.font = [UIFont systemFontOfSize:16];
    self.baseHUD.animationType = MBProgressHUDAnimationZoom;
    self.baseHUD.label.textColor = [UIColor whiteColor];
    
    self.baseHUD.label.text = message;
    [self.baseHUD hideAnimated:YES afterDelay:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        finish();
    });
}


- (void)dismiss{
    
    [self.baseHUD hideAnimated:NO];
}


- (ArcView *)returnArcView{
    ArcView *view = [[ArcView alloc]init];
    view.image =  [UIImage imageNamed:[SSHELPER_BUNDLE_IMAGEPATH stringByAppendingPathComponent:@"jiazai"]];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(37, 37));
    }];
    return view;
}


- (UIView *)SuperView1
{
    UIView * superview = nil;
    if ([[self class] isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController * ctr = (UINavigationController *)self;
        if ([ctr respondsToSelector:@selector(view)]) {
            superview = ctr.view;
        }
    }
    else if ([[self class] isSubclassOfClass:[UIViewController class]]) {
        UIViewController * ctr = (UIViewController *)self;
        if ([ctr respondsToSelector:@selector(view)]) {
            superview = ctr.view;
        }
    }
    else if ([[self class] isSubclassOfClass:[UIView class]]) {
        UIView * ctr = (UIView *)self;
        superview = ctr;
    }
    else if ([[self class] isSubclassOfClass:[UIWindow class]]) {
        UIWindow * ctr = (UIWindow *)self;
        superview = ctr;
        
    }
    else if ([[self class] isSubclassOfClass:[AppDelegate class]]) {
        AppDelegate * ctr = (AppDelegate *)self;
        superview = ctr.window;
    }else if([UIApplication sharedApplication].keyWindow ) {
        superview = [UIApplication sharedApplication].keyWindow;
    }
    return superview;
}

- (void)setBaseHUD:(MBProgressHUD *)baseHUD{
    objc_setAssociatedObject(self, &baseHUDKey, baseHUD, OBJC_ASSOCIATION_RETAIN);
}

- (MBProgressHUD *)baseHUD
{
    return objc_getAssociatedObject(self, &baseHUDKey);
  
}




- (void)showloadHUD{
    [self loadWithMessage:@"正在加载"];

}
- (void)showErrorHUD{
    [self showWithMessage:@"发生错误，请稍后再试！"];

}

- (void)showWithMessageinWindow:(NSString *)message{
    
    [self returnShowinWindowWithMessage:message finish:^{
        
    }];
}

- (void)loadWithMessageinWindow:(NSString *)message{
    [self returnHUBonWindowWithMessage:message];

}



@end
