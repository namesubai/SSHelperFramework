//
//  UIColor+SSHelper.h
//  SSHelper
//
//  Created by quanminqianbao on 2017/12/22.
//  Copyright © 2017年 yangshuquan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SS_ColorWithHexString(string)  [UIColor ss_colorWithHexString:string]

@interface UIColor (SSHelper)

+ (UIColor *)ss_colorWithHexString:(NSString *)hexString;

@end
