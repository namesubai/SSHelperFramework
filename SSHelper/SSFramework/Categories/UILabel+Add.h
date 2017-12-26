//
//  UILabel+Add.h
//  JHTDoctor
//
//  Created by yangsq on 16/4/29.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Add)

+ (UILabel *)returnLabelFram:(CGRect)fram
                   textColor:(UIColor *)textColor
                    textFont:(UIFont *)font
                  numberLine:(NSInteger)nuberLine
                cornerRadius:(CGFloat)cornerRadius
              backgroudColor:(UIColor *)backgroudColor;

@end
