//
//  UIViewController+Add.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/13.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "UIViewController+Add.h"

@implementation UIViewController (Add)

- (CGFloat)navHeight{
   return [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height;
}


@end

