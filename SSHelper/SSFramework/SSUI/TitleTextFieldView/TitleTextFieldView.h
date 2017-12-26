//
//  TitleTextFieldView.h
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/24.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleTextFieldView : UIView
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat titleWidth;


/**
 

 @param frame -
 @param titleWidth 文字标题的宽度，0是根据文字长度自适应，
 @param margin 标题和内容的距离
 @return -
 */
- (id)initWithFrame:(CGRect)frame titleWidth:(CGFloat)titleWidth margin:(CGFloat)margin;

@end
