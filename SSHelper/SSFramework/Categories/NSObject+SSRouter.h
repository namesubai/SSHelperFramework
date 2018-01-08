//
//  NSObject+SSRouter.h
//  SSHelper
//
//  Created by quanminqianbao on 2017/12/21.
//  Copyright © 2017年 yangshuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (SSRouter)
//push pop
- (void)pushVCWithClassKey:(id)classKey params:(NSDictionary *)params;
- (void)pushVCWithClassKeys:(NSArray *)classKeys;

- (void)popVC;
- (void)popVCWithClassKey:(id)classKey;
- (void)popToRootViewController;

//modal
- (void)presentVCWithClassKey:(id)classKey params:(NSDictionary *)params;
- (void)dimissVC;

- (void)presentVCWithClassKey:(id)classKey params:(NSDictionary *)params finish:(void(^)(void))finish;
- (void)dimissVCFinish:(void(^)(void))finish;

//
- (UINavigationController *)visibleNavigationController;
- (UIViewController *)visibleViewController;

@end
