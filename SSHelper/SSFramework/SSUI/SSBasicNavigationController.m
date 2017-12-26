//
//  SSBasicNavigationController.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/21.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "SSBasicNavigationController.h"
#import "SSHelperConfig.h"

@interface SSBasicNavigationController ()
@property (strong,nonatomic)UIImageView *navBarHairlineImageView;

@end

@implementation SSBasicNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    
    // Do any additional setup after loading the view.
}

- (void)configNav{
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:SSHelperConfigInstance.ss_nav_title_color,
                                                          NSFontAttributeName:SSHelperConfigInstance.ss_nav_title_font}];
    if (SSHelperConfigInstance.ss_nav_backImageName) {
        [UINavigationBar appearance].backIndicatorTransitionMaskImage = [[UIImage imageNamed:SSHelperConfigInstance.ss_nav_backImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [UINavigationBar appearance].backIndicatorImage = [[UIImage imageNamed:SSHelperConfigInstance.ss_nav_backImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    //    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageWithColor:Color_Main] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].barStyle =  UIBarStyleDefault;
    [UINavigationBar appearance].barTintColor = SSHelperConfigInstance.ss_nav_backgroundColor;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        
        viewControllers.lastObject.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super setViewControllers:viewControllers animated:animated];
}


-(BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
    
}

//设置状态栏
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
