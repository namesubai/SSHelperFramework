//
//  SSTabBar.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/21.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "SSTabBar.h"


@interface SSTabBar ()

@property (nonatomic, strong) UIView *lineView;
@end

@implementation SSTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        _lineView = [UIView new];
        [self addSubview:_lineView];
        
        
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _lineView.frame = (CGRect){0,0,CGRectGetWidth(self.frame),1};
}

- (void)setShadowColor:(UIColor *)shadowColor{
    _shadowColor = shadowColor;
    _lineView.backgroundColor = _shadowColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
