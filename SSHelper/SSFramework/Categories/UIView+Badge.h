//
//  UIView+Badge.h
//  JHTDoctor
//
//  Created by yangsq on 16/5/17.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Badge)

@property (strong, nonatomic) UILabel *badgeLabel;
@property (strong, nonatomic) UIImageView *badgeBackGroundImageView;

//添加到superView
- (void)showBadgeView:(NSInteger)badge andPoint:(CGPoint)point;
//添加到view
- (void)showBadgeView:(NSInteger)badge andPoint:(CGPoint)point onView:(UIView *)onView;
//添加红点
- (void)showRedPointViewPoint:(CGPoint)point onView:(UIView *)onView;
- (void)hideRedpoint;

@end
