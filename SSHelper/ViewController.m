//
//  ViewController.m
//  SSHelper
//
//  Created by quanminqianbao on 2017/12/22.
//  Copyright © 2017年 yangshuquan. All rights reserved.
//

#import "ViewController.h"
#import "SSHelperDefine.h"
#import "Categorise.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)load:(id)sender {
    
    [self loadWithMessage:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_Main;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
