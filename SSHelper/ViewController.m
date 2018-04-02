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
#import "SSWaveView.h"
#import "TextPathDemo.h"
#import "Masonry.h"
@interface ScaleView:UIView
{
    BOOL _isTap;
}
@property (nonatomic, strong) UIView *scaleView;
@end

@implementation ScaleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *scaleView = [[UIView alloc]initWithFrame:CGRectZero];
        scaleView.backgroundColor = [UIColor redColor];
        [self addSubview:scaleView];
        [scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(@0);
        }];
        self.scaleView = scaleView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [scaleView addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews{
    self.scaleView.layer.position = CGPointMake(self.scaleView.frame.origin.x, self.scaleView.frame.origin.y);
    self.scaleView.layer.anchorPoint = CGPointMake(0, 0);
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    _isTap = !_isTap;
    if (_isTap) {
        [UIView animateWithDuration:0.2 animations:^{
            tap.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            tap.view.transform = CGAffineTransformIdentity;
        }];
    }
}

@end

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)load:(id)sender {
    
    [self loadWithMessage:@""];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}
- (IBAction)textDrawAnimotion:(id)sender {
    TextPathDemo *domo = [TextPathDemo new];
    [self presentViewController:domo animated:YES completion:nil];
}

- (IBAction)action:(id)sender {
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"提示" message:@"提示提示提示提示提示提示提示" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:action];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (IBAction)alert:(id)sender {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"提示" message:@"提示提示提示提示提示提示提示" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"")
        textField.superview.layer.borderColor = [UIColor redColor].CGColor;
    }];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_Main;
    
    SSWaveView *waveView = [[SSWaveView alloc]initWithFrame:CGRectMake(100, 500, 100, 100)];
    waveView.progress = 0.7;
    [self.view addSubview:waveView];
    
    
    ScaleView *scaleView = [[ScaleView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:scaleView];
//    scaleView.layer.position = CGPointMake(scaleView.frame.origin.x, scaleView.frame.origin.y);
//    scaleView.layer.anchorPoint = CGPointMake(0, 0);
    [scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@100);
        make.top.equalTo(@610);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    

    
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



