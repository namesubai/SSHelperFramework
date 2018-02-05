//
//  SSHelperDefine.h
//  SSHelper
//
//  Created by quanminqianbao on 2017/12/22.
//  Copyright © 2017年 yangshuquan. All rights reserved.
//

#ifndef SSHelperDefine_h
#define SSHelperDefine_h
#import "SSHelperConfig.h"
#import "UIImage+Add.h"

#define NSLog(format, ...) fprintf(stderr,"\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:format, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]);


#define  SSHELPER_BUNDLE_IMAGEPATH  @"SSHelperResource.bundle/images"

//配置部分的宏
#define SSHELPER   [SSHelperConfig sharedInstance]

#define Color_Main           [SSHELPER ss_main_color] //主色调
#define Color_Line           [SSHELPER ss_line_color] //线的色调
#define Color_BG             [SSHELPER ss_bg_color] //背景颜色
#define Color_Text_Standard       [SSHELPER ss_text_default_color] //默认字体颜色
#define Color_Text_Secondary      [SSHELPER ss_text_secondary_color] //次要的字体颜色
#define Color_Text_Detail         [SSHELPER ss_text_detial_color] //说明,标注颜色
#define Color_Green          [SSHELPER ss_green_color] //青色
#define Color_Blue           [SSHELPER ss_bule_color] //蓝色
#define Color_White          [SSHELPER ss_white_color] //白色
#define Color_Red            [SSHELPER ss_red_color] //红色


//字体
#define Text_Max_Font       [SSHELPER ss_text_max_font] //默认,font 17
#define Text_Min_Font       [SSHELPER ss_text_min_font] //默认,font 14
#define Text_small_Font     [SSHELPER ss_text_small_font] //默认,font 12


#pragma mark - 变量-编译相关

// 判断当前是否debug编译模式
#ifdef DEBUG
#define IS_DEBUG YES
#else
#define IS_DEBUG NO
#endif


/// 判断当前编译使用的 Base SDK 版本是否为 iOS 8.0 及以上

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#define IOS8_SDK_ALLOWED YES
#endif


/// 判断当前编译使用的 Base SDK 版本是否为 iOS 9.0 及以上

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
#define IOS9_SDK_ALLOWED YES
#endif


/// 判断当前编译使用的 Base SDK 版本是否为 iOS 10.0 及以上

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#define IOS10_SDK_ALLOWED YES
#endif


/// 判断当前编译使用的 Base SDK 版本是否为 iOS 11.0 及以上

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
#define IOS11_SDK_ALLOWED YES
#endif


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_320WIDTH   SCREEN_WIDTH==320
#define Scale   ((IS_IPHONE_6||IS_320WIDTH)?1:(SCREEN_WIDTH<SCREEN_HEIGHT?(SCREEN_WIDTH/375.0):(SCREEN_HEIGHT/375.0)))
//#define Scale (IS_IPHONE_6P?  (SCREEN_WIDTH<SCREEN_HEIGHT?(SCREEN_WIDTH/375.0):(SCREEN_HEIGHT/375.0)):(IS_IPHONE_6? (SCREEN_WIDTH<SCREEN_HEIGHT? SCREEN_WIDTH/375.0:SCREEN_HEIGHT/375.0) : 1))
#define IPHONE4_Scale   (SCREEN_WIDTH==320?(SCREEN_WIDTH<SCREEN_HEIGHT?(SCREEN_WIDTH/375.0):(SCREEN_HEIGHT/375.0)):1.0)
#define NonePlalceholderImage   [UIImage ss_imageWithColor:[Color_Line colorWithAlphaComponent:0.5]]

#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* SSHelperDefine_h */
