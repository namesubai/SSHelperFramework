 //
//  CustomButton.h
//  JHTDoctor
//
//  Created by yangsq on 16/5/30.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  自定义按钮
 */
typedef NS_ENUM(NSInteger,CustomButtonType) {
    
    CustomButtonLeftAndRightType, //左图标，右文字
    CustomButtonTopAndBottomType, //上图标，下文字
    CustomButtonRightAndLeftType, //右图标，左文字
    
};


@interface CustomButton : UIView

@property (strong, nonatomic) UIImageView *buttonImagView;
@property (strong, nonatomic) UILabel *buttonTitle;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *titletext;
@property (copy,   nonatomic) void(^touchAction)(CustomButton *view,UIButton *button);


@property (assign, nonatomic) BOOL isShowRedPoint;
@property (assign, nonatomic) NSInteger unreadNum;

@property (assign, nonatomic) BOOL selectHightLight; // 设置点击高亮

- (id)initWithFrame:(CGRect)frame type:(CustomButtonType)type;
/**
 *
 *
 *  @param frame
 *  @param type
 *  @param imageSize 图标大小
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame type:(CustomButtonType)type imageSize:(CGSize)imageSize;
/**
 *
 *
 *  @param frame
 *  @param type
 *  @param imageSize  图标大小
 *  @param isAutoWith 是否根据文字长度自适应
 *
 *  @return 
 */
- (id)initWithFrame:(CGRect)frame type:(CustomButtonType)type imageSize:(CGSize)imageSize isAutoWith:(BOOL)isAutoWith;

- (id)initWithFrame:(CGRect)frame type:(CustomButtonType)type imageSize:(CGSize)imageSize isAutoWith:(BOOL)isAutoWith midmargin:(CGFloat)midmargin;

/**
 *  点击
 */
- (void)touchAction:(void(^)(CustomButton *view,UIButton *button))button;
@end
