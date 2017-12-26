//
//  UIView+New.h
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/10.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (New)
/**
 *  获取当前的第一响应者
 */
- (UIView *)getFirstResponder;

+ (id)returnViewWithFrame:(CGRect)frame
             cornerRadius:(CGFloat)cornerRadius
           backgroudColor:(UIColor *)backgroudColor
           hasTopLineView:(BOOL)hasTopLineView
        hasBottomLineView:(BOOL)hasBottomLineView;



//开始旋转
- (void)beginRotate;
//停止动画
- (void)stopAnimation;

//开始缩放
- (void)beginZoom;


@end
