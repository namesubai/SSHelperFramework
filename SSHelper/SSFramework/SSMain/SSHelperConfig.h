//
//  SSHelperConfig.h
//  SSHelper
//
//  Created by quanminqianbao on 2017/12/22.
//  Copyright © 2017年 yangshuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define  SSHelperConfigInstance  [SSHelperConfig sharedInstance]

static const NSString *ss_tabarVCName                  = @"tabarVCName";
static const NSString *ss_tabarTitle                  = @"tabarTitle";
static const NSString *ss_tabbarImage                 = @"tabbarImage";
static const NSString *ss_tabbarSelectImage           = @"tabbarSelectImage";

@interface SSHelperConfig : NSObject
+ (instancetype)sharedInstance;

//网络部分的配置
@property (nonatomic, copy) NSString *serviceUrl;//服务器连接

//UI部分的配置

//color
@property (nonatomic, strong) UIColor *ss_main_color; //主色调
@property (nonatomic, strong) UIColor *ss_line_color; //线的色调
@property (nonatomic, strong) UIColor *ss_bg_color; //背景颜色
@property (nonatomic, strong) UIColor *ss_text_default_color; //默认字体颜色
@property (nonatomic, strong) UIColor *ss_text_secondary_color; //次要的字体颜色
@property (nonatomic, strong) UIColor *ss_text_detial_color; //说明,标注颜色
@property (nonatomic, strong) UIColor *ss_green_color; //青色
@property (nonatomic, strong) UIColor *ss_bule_color; //蓝色
@property (nonatomic, strong) UIColor *ss_white_color; //白色
@property (nonatomic, strong) UIColor *ss_red_color; //红色

//text_font
@property (nonatomic, strong) UIFont *ss_text_max_font; //默认,font 17
@property (nonatomic, strong) UIFont *ss_text_min_font; //默认,font 14
@property (nonatomic, strong) UIFont *ss_text_small_font; //默认,font 12



//tabbar
@property (nonatomic, strong) UIColor *ss_tabar_title_color;//文字颜色
@property (nonatomic, strong) UIColor *ss_tabar_title_selectColor;//文字颜色
@property (nonatomic, strong) UIFont *ss_tabar_title_font;//文字大小
@property (nonatomic, strong) UIColor *ss_tabar_shadow_color;//线的颜色
@property (nonatomic, strong) NSArray *ss_tabar_configs;

//navigation
@property (nonatomic, strong) UIColor *ss_nav_title_color;//文字颜色
@property (nonatomic, strong) UIColor *ss_nav_backgroundColor;//
@property (nonatomic, strong) UIFont *ss_nav_title_font;//文字颜色
@property (nonatomic, strong) NSString *ss_nav_backImageName;//返回按钮图片
@property (nonatomic, strong) UIImage *ss_nav_shadowImage;
@property (nonatomic, assign) BOOL ss_hide_nav_ShadowImage;



@end
