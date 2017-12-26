//
//  CustomButton.m
//  JHTDoctor
//
//  Created by yangsq on 16/5/30.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "CustomButton.h"
#import "SSHelperDefine.h"
#import "Masonry.h"
#import "Categorise.h"

#define buttonImageViewSize CGSizeMake(20, 20)

@interface CustomButton ()


@property (assign, nonatomic) CustomButtonType type;
@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) BOOL isAutoWith;
@property (assign, nonatomic) CGFloat midMargin;

@property (strong, nonatomic) UIView *redView;

@end

@implementation CustomButton

- (void)dealloc{
    _buttonImagView = nil;
    _buttonTitle = nil;
    _button = nil;
}


- (id)initWithFrame:(CGRect)frame type:(CustomButtonType)type{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.type = type;
        self.imageSize = buttonImageViewSize;
        [self setView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(CustomButtonType)type imageSize:(CGSize)imageSize{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.type = type;
    
        self.imageSize = imageSize;
        [self setView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(CustomButtonType)type imageSize:(CGSize)imageSize isAutoWith:(BOOL)isAutoWith{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.type = type;
        
        self.imageSize = imageSize;
        self.isAutoWith = isAutoWith;
        [self setView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(CustomButtonType)type imageSize:(CGSize)imageSize isAutoWith:(BOOL)isAutoWith midmargin:(CGFloat)midmargin{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.type = type;
        self.midMargin = midmargin;
        self.imageSize = imageSize;
        self.isAutoWith = isAutoWith;
        [self setView];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
     
        [self setView];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = _buttonImagView.frame;
    [_buttonImagView showBadgeView:_unreadNum andPoint:CGPointMake(CGRectGetMaxX(rect)-10, CGRectGetMinY(rect)-5) onView:_buttonImagView.superview];
}

- (void)setUnreadNum:(NSInteger)unreadNum{
    _unreadNum = unreadNum;
    [self layoutSubviews];
}

- (void)setIsShowRedPoint:(BOOL)isShowRedPoint{
    [_redView setHidden:!isShowRedPoint];
}


- (void)setView{
    
    UIView *tempView = [UIView new];
    [self addSubview:tempView];
    
    
    
    _buttonImagView = [UIImageView new];
    [tempView addSubview:_buttonImagView];
    
    _buttonTitle = [UILabel returnLabelFram:CGRectZero
                                  textColor:Color_Text_Detail
                                   textFont:[UIFont systemFontOfSize:13]
                                 numberLine:1
                               cornerRadius:0
                             backgroudColor:nil];
    
    [tempView addSubview:_buttonTitle];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:_button];
    
    
    _redView = [[UIView alloc]init];
    _redView.backgroundColor = [UIColor redColor];
    _redView.layer.cornerRadius = 8/2;
    [self addSubview:_redView];
    _redView.hidden = YES;
    [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_buttonImagView.mas_centerX).offset(self.imageSize.width/4+3);
        make.centerY.equalTo(_buttonImagView.mas_top).offset(8/2);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    
    
    if (self.type == CustomButtonLeftAndRightType) {
        
        [_buttonImagView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(self.imageSize);
            
        }];
        
        [_buttonTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_buttonImagView.mas_right).offset(self.midMargin==0? 8:self.midMargin);
            make.centerY.equalTo(@0);
            make.height.mas_equalTo(20);
            make.right.equalTo(@(0));
            
        }];
        
        
        
    }
    
    if(self.type == CustomButtonTopAndBottomType){
        
        _buttonTitle.textAlignment = NSTextAlignmentCenter;
    
        [_buttonImagView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(self.imageSize);
            make.top.equalTo(@0);
            make.centerX.equalTo(@0);
        }];
        
        [_buttonTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_buttonImagView.mas_bottom).offset(self.midMargin==0? 8:self.midMargin);
            make.width.greaterThanOrEqualTo(@(self.imageSize.width));
            make.right.equalTo(@(0));
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
            
        }];
    }
    
    if (self.type == CustomButtonRightAndLeftType) {
        
        [_buttonImagView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(@0);
            make.centerY.equalTo(@0);
            make.size.mas_equalTo(self.imageSize);
            
        }];
        
        [_buttonTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(_buttonImagView.mas_left).offset(-(self.midMargin==0? 8:self.midMargin));
            make.centerY.equalTo(@0);
            make.height.mas_equalTo(20);
            make.left.equalTo(@(0));
            
        }];
        
        

    }
    
    

    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.bottom.left.equalTo(@0);
    }];
    
    if (!self.isAutoWith) {
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.type == CustomButtonTopAndBottomType) {
                make.left.right.equalTo(@0);
                make.center.equalTo(@0);
            }else{
                make.center.equalTo(self);
                make.top.bottom.equalTo(@0);
            }
          
        }];
    }else{
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.left.bottom.right.top.equalTo(@0);

        }];
    }
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)buttonAction:(UIButton *)button{
    if (self.touchAction) {
        self.touchAction(self,button);
    }
}

- (void)setSelectHightLight:(BOOL)selectHightLight{
    _selectHightLight = selectHightLight;
    
    if (_selectHightLight) {
        
        [self.button setBackgroundImage:[UIImage ss_imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
    }else{
        [self.button setBackgroundImage:[UIImage ss_imageWithColor:[UIColor clearColor] ]forState:UIControlStateHighlighted];
    }
}

- (void)setImage:(UIImage *)image{
    _image = image;
    [self.buttonImagView setImage:_image];
}

- (void)setTitletext:(NSString *)titletext{
    _titletext = titletext;
    self.buttonTitle.text = _titletext;
}


- (void)touchAction:(void (^)(CustomButton *, UIButton *))button{
    self.touchAction = button;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
