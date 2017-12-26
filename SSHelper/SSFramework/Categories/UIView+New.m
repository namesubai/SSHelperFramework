//
//  UIView+New.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/10.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "UIView+New.h"
#import "Masonry.h"
#import "SSHelperDefine.h"

@implementation UIView (New)
- (UIView *)getFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView getFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

+ (id)returnViewWithFrame:(CGRect)frame
             cornerRadius:(CGFloat)cornerRadius
           backgroudColor:(UIColor *)backgroudColor
           hasTopLineView:(BOOL)hasTopLineView
        hasBottomLineView:(BOOL)hasBottomLineView{
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    if (!cornerRadius) {
        view.layer.cornerRadius = cornerRadius;
    }
    if (backgroudColor) {
        view.backgroundColor = backgroudColor;
    }
    if (hasTopLineView) {
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = Color_Line;
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    if (hasBottomLineView) {
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = Color_Line;
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    
    
    return view;
    
}

- (void)beginRotate{
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = (id) 0;
    animation.toValue = @(M_PI*2);
    animation.duration = 1;
    animation.timingFunction = linearCurve;
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    [self.layer addAnimation:animation forKey:@"rotate"];
}
- (void)beginZoom{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 0.3; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.2]; // 结束时的倍率
    // 添加动画
    [self.layer addAnimation:animation forKey:@"scale-layer"];
}

- (void)stopAnimation{
    [self.layer removeAllAnimations];
}



@end
