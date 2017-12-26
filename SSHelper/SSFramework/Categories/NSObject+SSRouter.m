//
//  NSObject+SSRouter.m
//  SSHelper
//
//  Created by quanminqianbao on 2017/12/21.
//  Copyright © 2017年 yangshuquan. All rights reserved.
//

#import "NSObject+SSRouter.h"
#import <objc/runtime.h>

@implementation NSObject (SSRouter)
- (void)pushVCWithClassKey:(id)classKey params:(NSDictionary *)params{
    
    [self __pushViewController:[self.class __retrunViewControllerWithClassKey:classKey] parameters:params atNavigationController:self.visibleNavigationController animated:YES];
    
}
- (void)pushVCWithClassKeys:(NSArray *)classKeys{
    NSMutableArray *viewControllers = self.visibleNavigationController.viewControllers.mutableCopy;
    for (id classKey in classKeys) {
        [viewControllers addObject:[self.class __retrunViewControllerWithClassKey:classKey]];
    }
   
    [self.visibleNavigationController setViewControllers:viewControllers animated:YES];
}

- (void)popVC{
    [self.visibleNavigationController popViewControllerAnimated:YES];
}
- (void)popToRootViewController{
    [self.visibleNavigationController popToRootViewControllerAnimated:YES];
}
- (void)popVCWithClassKey:(id)classKey{
    UIViewController *viewController = nil;
    for (UIViewController *vc in self.visibleNavigationController.viewControllers) {
        if ([vc isEqual:classKey]) {
            viewController = classKey;
            break;
        }
        if ([NSStringFromClass(vc.class) isEqualToString:classKey]) {
            viewController = vc;
            break;
        }
    }
    [self.visibleNavigationController popToViewController:viewController animated:YES];
}

- (void)presentVCWithClassKey:(id)classKey params:(NSDictionary *)params{
    [self __presentViewController:[self.class __retrunViewControllerWithClassKey:classKey] parameters:params animated:YES finish:nil];
}
- (void)dimissVC{
    [self.visibleViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentVCWithClassKey:(id)classKey params:(NSDictionary *)params finish:(void (^)(void))finish{
    [self __presentViewController:[self.class __retrunViewControllerWithClassKey:classKey] parameters:params animated:YES finish:finish];
}

- (void)dimissVCFinish:(void (^)(void))finish{
    [self.visibleViewController dismissViewControllerAnimated:YES completion:finish];
}


- (void)__presentViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters  animated:(BOOL)animated finish:(void (^)(void))finish{
    if (viewController == nil)
    {
        NSLog(@"vc为空");
        return;
    }
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.class setVC:viewController value:obj key:key];
        
    }];
    
    [self.visibleViewController presentViewController:viewController animated:animated completion:^{
        !finish?:finish();
    }];
}

+ (void)setVC:(UIViewController *)viewController value:(id)value key:(id)key{
    
    if([key isEqualToString:@"title"]){
        if ([viewController isKindOfClass:[UIViewController class]]) {
            [viewController.navigationItem setTitle:value];
        }
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            [[(UINavigationController *)viewController topViewController].navigationItem setTitle:value];
        }
        
    }else{
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList([viewController class], &count);
        for(int i = 0; i < count; i++)
        {
            objc_property_t property = properties[i];
            NSString *name = [NSString stringWithUTF8String:property_getName(property)];
            if ([name isEqualToString:key]) {
                [viewController setValue:value forKey:key];
                break;
            }
        }
        free(properties);
    }
    
}




- (void)__pushViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters atNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated
{
    if (viewController == nil || navigationController == nil)
    {
        if (!navigationController) {
            NSLog(@"nav为空");
        }
        if (!viewController) {
            NSLog(@"vc为空");
        }
        return;
    }
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.class setVC:viewController value:obj key:key];
    }];
    
    [navigationController pushViewController:viewController
                                    animated:animated];
}



+ (UIViewController *)__retrunViewControllerWithClassKey:(id)classKey{
    
    UIViewController *vc  = nil;
    
    if ([classKey isKindOfClass:[UIViewController class]]) {
        
        vc = classKey;
        
    }else if ([classKey isKindOfClass:[NSString class]]){
        vc = [[NSClassFromString(classKey) alloc] init];
    }
    return vc;
}

- (UINavigationController *)visibleNavigationController
{
    UIViewController *vc        = [self.class __visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    UINavigationController *nvc = (UINavigationController *)([vc isKindOfClass:[UINavigationController class]] ? vc : vc.navigationController);
    
    return nvc;
}



- (UIViewController *)visibleViewController
{
    UIViewController *vc = [self.class __visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    
    return vc;
}

+ (UIViewController *)__visibleViewControllerWithRootViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tbc = (UITabBarController *)rootViewController;
        return [self __visibleViewControllerWithRootViewController:tbc.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nvc = (UINavigationController *)rootViewController;
        return [self __visibleViewControllerWithRootViewController:nvc.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedVC = rootViewController.presentedViewController;
        return [self __visibleViewControllerWithRootViewController:presentedVC];
    }
    else
    {
        return rootViewController;
    }
}


@end
