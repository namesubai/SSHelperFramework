//
//  SSTabBarViewController.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/21.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "SSTabBarViewController.h"
#import "SSTabBar.h"
#import "SSBasicNavigationController.h"
#import "SSHelperConfig.h"


@interface SSTabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic,copy)   NSArray *configs;

@end

@implementation SSTabBarViewController

- (void)setUpSubNav{
    NSMutableArray *navArray = [NSMutableArray new];

    for (int i=0; i<SSHelperConfigInstance.ss_tabar_configs.count; i++) {
        
        NSDictionary * item = self.configs[i];
        NSString *vcName = item[ss_tabarVCName];
        NSString *title  = item[ss_tabarTitle];
        NSString *imageName = item[ss_tabbarImage];
        NSString *imageSelected = item[ss_tabbarSelectImage];
        
        UIViewController *viewController = [[NSClassFromString(vcName) alloc]init];
        SSBasicNavigationController *nav = [[SSBasicNavigationController alloc]initWithRootViewController:viewController];
        nav.tabBarItem.title =  title;
        [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:SSHelperConfigInstance.ss_tabar_title_color,
                                                 NSFontAttributeName:SSHelperConfigInstance.ss_tabar_title_font}
                                      forState:UIControlStateNormal];
        [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:SSHelperConfigInstance.ss_tabar_title_selectColor,NSFontAttributeName:SSHelperConfigInstance.ss_tabar_title_font}
                                      forState:UIControlStateSelected];
        nav.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:imageSelected]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [navArray addObject:nav];
        
        
    }
    
    self.viewControllers = navArray;
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
    [self reSetTabbar];
    [self setUpSubNav];

}
- (void)reSetTabbar{
    SSTabBar *mainTabbar = [[SSTabBar alloc]init];
    mainTabbar.shadowColor = SSHelperConfigInstance.ss_tabar_shadow_color;
    [self setValue:mainTabbar forKey:@"tabBar"];
}


@end
