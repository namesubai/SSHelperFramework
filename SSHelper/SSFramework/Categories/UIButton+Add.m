//
//  UIButton+Add.m
//  JHTDoctor
//
//  Created by yangsq on 16/4/29.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "UIButton+Add.h"
#import <objc/runtime.h>
static const void *UIButtonbuttonClickblockKey                           = &UIButtonbuttonClickblockKey;


@implementation UIButton (Add)

+ (UIButton *)returnButtonFram:(CGRect)frame
                          type:(UIButtonType)type
                         title:(NSString *)title
                    titleColor:(UIColor *)color
                  cornerRadius:(CGFloat)cornerRadius
                      textFont:(UIFont *)font
                backgroudColor:(UIColor *)backgroudColor{
    UIButton *button = [UIButton buttonWithType:type];
    
    button.frame = frame;
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];

    }
    [button setTitle:title forState:UIControlStateNormal];
    
    if (font) {
        [button.titleLabel setFont:font];

    }
    if (cornerRadius>0) {
        button.layer.cornerRadius = cornerRadius;
    }
    if (backgroudColor) {
        button.backgroundColor = backgroudColor;
    }
    return button;
    return nil;
}



- (void)buttonAction:(UIButton *)button{
   
  
    if (self.buttonClickblock) {
        self.buttonClickblock (button);
    }
}

- (ButtonClick)buttonClickblock{
    return objc_getAssociatedObject(self, UIButtonbuttonClickblockKey);
}
- (void)setButtonClickblock:(ButtonClick)buttonClickblock{
    objc_setAssociatedObject(self, UIButtonbuttonClickblockKey, buttonClickblock, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(ButtonClick)block{
     self.buttonClickblock = block;
    
}




@end
