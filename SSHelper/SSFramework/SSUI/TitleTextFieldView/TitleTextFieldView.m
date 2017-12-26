//
//  TitleTextFieldView.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/24.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "TitleTextFieldView.h"
#import "SSHelperDefine.h"
#import "Categorise.h"

@interface TitleTextFieldView ()

@end

@implementation TitleTextFieldView

- (id)initWithFrame:(CGRect)frame
         titleWidth:(CGFloat)titleWidth
             margin:(CGFloat)margin{
    if (self = [super initWithFrame:frame]) {
        self.titleWidth = titleWidth;
        self.margin = margin;
        _titleLabel = [UILabel returnLabelFram:CGRectZero
                                     textColor:Color_Text_Standard
                                      textFont:[UIFont systemFontOfSize:14]
                                    numberLine:1
                                  cornerRadius:0
                                backgroudColor:nil];
        [self addSubview:_titleLabel];
        
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = Color_Text_Standard;
        [self addSubview:_textField];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.titleWidth>0) {
        self.titleLabel.frame = CGRectMake(0, 0, self.titleWidth, CGRectGetHeight(self.frame));
    }else{
        CGFloat width = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, 30)].width;
        self.titleLabel.frame = self.titleLabel.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.frame));
    }
    _textField.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+self.margin, 0, CGRectGetWidth(self.frame)-(CGRectGetMaxX(self.titleLabel.frame)+self.margin), CGRectGetHeight(self.frame));
}

- (void)setTitleWidth:(CGFloat)titleWidth{
    _titleWidth = titleWidth;
    [self layoutSubviews];
}

- (void)setMargin:(CGFloat)margin{
    _margin = margin;
    [self layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
