//
//  WelcomShowView.h
//  JHTDoctor
//
//  Created by yangsq on 16/8/7.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  欢迎页
 */
@interface WelcomShowView : UIView

@property (copy, nonatomic) void(^show)(WelcomShowView *view);


- (id)initWithFrame:(CGRect)frame Images:(NSArray <NSString *>*)images;

- (void)show:(void(^)(WelcomShowView *view))block;

//只展示一次,
+ (void)showWelcomViewOnlyOneceTimeImages:(NSArray<NSString *> *)images hideCompletion:(void (^)(WelcomShowView *))block;

@end
