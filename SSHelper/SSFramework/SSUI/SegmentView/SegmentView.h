//
//  SegmentView.h
//  JHTDoctor
//
//  Created by yangsq on 16/5/5.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentView : UIView
@property (assign, nonatomic) BOOL showTriangle;//显示三角形
@property (copy) void(^SelectBlock)(NSInteger index,SegmentView *view);





- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items selectColor:(UIColor *)selectColor noselectColor:(UIColor *)noselectColor;
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items secondItems:(NSArray *)secondItems;


- (void)selectBlock:(void(^)(NSInteger index,SegmentView *view))block;
- (void)touchWithIndex:(NSUInteger)index;
- (void)changeButtonWithIndex:(NSInteger)tag;
- (void)touchIndex:(NSInteger)index isMove:(BOOL)isMove;
- (void)setTitle:(NSString *)title  index:(NSInteger)index;

- (void)changeButtonWithIndex:(NSInteger)index progress:(CGFloat)progress;

@end
