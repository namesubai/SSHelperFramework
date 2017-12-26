//
//  UILabel+Add.m
//  JHTDoctor
//
//  Created by yangsq on 16/4/29.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "UILabel+Add.h"

@implementation UILabel (Add)
+ (UILabel *)returnLabelFram:(CGRect)fram
                   textColor:(UIColor *)textColor
                    textFont:(UIFont *)font
                  numberLine:(NSInteger)nuberLine
                cornerRadius:(CGFloat)cornerRadius
              backgroudColor:(UIColor *)backgroudColor{
    

    
    UILabel *label = [[UILabel alloc]initWithFrame:fram];
    if (backgroudColor) {
        label.backgroundColor = backgroudColor;
    }
    if (label.textColor) {
        label.textColor = textColor;
    }
    if (font) {
        label.font = font;
    }
    label.numberOfLines = nuberLine!=1? nuberLine:1;
    if (cornerRadius>0) {
        label.layer.cornerRadius = cornerRadius;
    }
    return label;
    
    return nil;
}



@end
