//
//  SSHelperConfig.m
//  SSHelper
//
//  Created by quanminqianbao on 2017/12/22.
//  Copyright © 2017年 yangshuquan. All rights reserved.
//

#import "SSHelperConfig.h"
#import "UIColor+SSHelper.h"

@implementation SSHelperConfig
+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static SSHelperConfig *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[SSHelperConfig alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaultConfiguration];
    }
    return self;
}
#pragma mark - 默认配置
- (void)initDefaultConfiguration{
    //color
    self.ss_main_color = SS_ColorWithHexString(@"ddad29");
    self.ss_line_color = SS_ColorWithHexString(@"e6e6e6");
    self.ss_bg_color = SS_ColorWithHexString(@"f3f3F3");
    self.ss_text_default_color = SS_ColorWithHexString(@"37394D");
    self.ss_text_secondary_color = SS_ColorWithHexString(@"9495AB");
    self.ss_text_detial_color = SS_ColorWithHexString(@"a1a1a1");
    self.ss_green_color = SS_ColorWithHexString(@"77CD6C");
    self.ss_bule_color = SS_ColorWithHexString(@"638CF8");
    self.ss_white_color = SS_ColorWithHexString(@"FFFFFF");
    self.ss_red_color = SS_ColorWithHexString(@"F96F59");
    
    //text_font
    self.ss_text_max_font = [UIFont systemFontOfSize:17];
    self.ss_text_min_font = [UIFont systemFontOfSize:14];
    self.ss_text_small_font = [UIFont systemFontOfSize:12];

    //tabar
    self.ss_tabar_title_color = SS_ColorWithHexString(@"37394D");
    self.ss_tabar_title_selectColor = SS_ColorWithHexString(@"638CF8");
    self.ss_tabar_title_font = [UIFont systemFontOfSize:11];
    self.ss_tabar_shadow_color = SS_ColorWithHexString(@"e6e6e6");

    //nav
    self.ss_nav_title_color = SS_ColorWithHexString(@"37394D");
    self.ss_nav_title_font = [UIFont systemFontOfSize:18];
    self.ss_nav_backgroundColor = SS_ColorWithHexString(@"638CF8");
}
@end
