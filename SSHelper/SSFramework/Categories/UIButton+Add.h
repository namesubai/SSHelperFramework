//
//  UIButton+Add.h
//  JHTDoctor
//
//  Created by yangsq on 16/4/29.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClick)(UIButton *button);




@interface UIButton (Add)


+ (UIButton *)returnButtonFram:(CGRect)frame
                          type:(UIButtonType)type
                         title:(NSString *)title
                    titleColor:(UIColor *)color
                  cornerRadius:(CGFloat)cornerRadius
                      textFont:(UIFont *)font
                backgroudColor:(UIColor *)backgroudColor;



@property (copy, nonatomic)ButtonClick buttonClickblock;

- (void)buttonClick:(ButtonClick)block;
@end
