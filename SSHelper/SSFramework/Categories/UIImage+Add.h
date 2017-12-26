//
//  UIImage+Add.h
//  SSHelper
//
//  Created by quanminqianbao on 2017/12/26.
//  Copyright © 2017年 yangshuquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Add)
+ (UIImage *)ss_imageWithColor:(UIColor *)color;
- (UIImage *)ss_imageByResizeToSize:(CGSize)size;
@end
