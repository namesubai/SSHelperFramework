//
//  NoneView.m
//  JHTDoctor
//
//  Created by yangsq on 16/7/14.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "NoneView.h"
#import "SSHelperDefine.h"
#import "UIColor+SSHelper.h"
#import "UILabel+Add.h"
#import "Masonry.h"
@implementation NoneView

- (void)dealloc{
    _tipImageView = nil;
    _textLabel = nil;
    _detailLabel = nil;
    _button = nil;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupView];
    }
    
    return self;
}

- (void)setupView{
    
    
    _tipImageView = [UIImageView new];
    [self addSubview:_tipImageView];
    
    _textLabel = [UILabel returnLabelFram:CGRectZero
                                textColor:Color_Text_Secondary
                                 textFont:Text_Min_Font
                               numberLine:0
                             cornerRadius:0
                           backgroudColor:nil];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
    
    _detailLabel = [UILabel returnLabelFram:CGRectZero
                                  textColor:SS_ColorWithHexString(@"c0c0c0")
                                   textFont:Text_small_Font
                                 numberLine:0
                               cornerRadius:0
                             backgroudColor:nil];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_detailLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button.titleLabel setFont:Text_Min_Font];
    [_button setTitleColor:Color_Main forState:UIControlStateNormal];
    [self addSubview:_button];
    
    
    [_tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
////        make.top.equalTo(@(55*Scale));
//        make.centerY.equalTo(@(-50));
        make.top.equalTo(@(80*Scale));
        make.size.mas_equalTo(CGSizeMake(85*Scale, 85*Scale));
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipImageView.mas_bottom).offset(20);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textLabel.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailLabel.mas_bottom).offset(15);
        make.centerX.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(150*Scale, 30*Scale));
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
