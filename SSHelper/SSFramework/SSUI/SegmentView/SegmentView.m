//
//  SegmentView.m
//  JHTDoctor
//
//  Created by yangsq on 16/5/5.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "SegmentView.h"
#import "SSHelperDefine.h"
#import "Categorise.h"
#import "Masonry.h"

#define LineHeight   2   //下划线高度
#define bottomLineHeight 0.5 //底部线高度

@interface SegmentItemView : UIView


@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UILabel *midLabel;
@property (strong, nonatomic) UILabel *bottomLabel;

@end

@implementation SegmentItemView


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _topLabel = [UILabel returnLabelFram:CGRectZero
                                   textColor:Color_Text_Standard
                                    textFont:[UIFont systemFontOfSize:14]
                                  numberLine:1
                                cornerRadius:0
                              backgroudColor:nil];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_topLabel];
        
        _midLabel = [UILabel returnLabelFram:CGRectZero
                                   textColor:Color_Text_Standard
                                    textFont:[UIFont systemFontOfSize:14]
                                  numberLine:1
                                cornerRadius:0
                              backgroudColor:nil];
        _midLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_midLabel];
        
        
        _bottomLabel = [UILabel returnLabelFram:CGRectZero
                                      textColor:Color_Text_Standard
                                       textFont:[UIFont systemFontOfSize:12]
                                     numberLine:1
                                   cornerRadius:0
                                 backgroudColor:nil];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bottomLabel];
        
        
        [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(_topLabel.superview.mas_centerY).offset(-2.5);
        }];
        [_midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.centerY.equalTo(@0);
        }];
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(_topLabel.superview.mas_centerY).offset(2.5);
        }];
        
    }
    
    return self;
}


@end


@interface SegmentView ()

{
    
    
}


@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *secondItems;

@property (strong, nonatomic) NSMutableArray *itemViews;
@property (strong, nonatomic) NSMutableArray *itemViewTaps;

@property (strong, nonatomic) UIImageView *triangleImageview;
@property (strong, nonatomic) UIColor *selectColor;
@property (strong, nonatomic) UIColor *noselectColor;
@property (strong,  nonatomic) UIView *lineView;
@property (strong, nonatomic) UIScrollView *myScrollView;
@property (strong, nonatomic) NSArray *itemWiths;

@property (assign, nonatomic) NSInteger currentIndex;

@end
@implementation SegmentView
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = items;
        self.selectColor = Color_Main;
        self.noselectColor = [UIColor ss_colorWithHexString:@"383838"];
        [self setupViews];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items secondItems:(NSArray *)secondItems{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = items;
        self.secondItems = secondItems;
        self.selectColor = Color_Main;
        self.noselectColor = [UIColor ss_colorWithHexString:@"383838"];
        [self setupViews];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items selectColor:(UIColor *)selectColor noselectColor:(UIColor *)noselectColor{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = items;
        self.selectColor = selectColor;
        self.noselectColor = noselectColor;
        [self setupViews];
        
    }
    return self;
}
- (void)layoutSubviews{
    _myScrollView.contentInset = UIEdgeInsetsZero;
}

- (CGFloat)returnTotalWith{
    
    CGFloat totalWith = 0;
    
    if (self.secondItems.count) {
        for (NSString *string in self.secondItems) {
            CGFloat with = [string ss_sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(MAXFLOAT, self.frame.size.height) mode:NSLineBreakByClipping].width;
            totalWith+=with+20;
        }
    }else{
        for (NSString *string in self.items) {
            CGFloat with = [string ss_sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(MAXFLOAT, self.frame.size.height) mode:NSLineBreakByClipping].width;
            totalWith+=with+20;
        }
    }
    
   
    return totalWith;
}

- (NSArray *)itemWiths{
    
    NSMutableArray *tempArray = @[].mutableCopy;
    
    if (self.secondItems.count) {
        for (NSString *string in self.secondItems) {
            CGFloat with ;
            with = [string ss_sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(MAXFLOAT, self.frame.size.height) mode:NSLineBreakByClipping].width;
            
            if ([self returnTotalWith]>self.frame.size.width) {
                
                [tempArray addObject:@(with+20)];
            }else{
                [tempArray addObject:@(self.frame.size.width/self.items.count)];
            }
        }
        
    }else{
        for (NSString *string in self.items) {
            CGFloat with ;
            with = [string ss_sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(MAXFLOAT, self.frame.size.height) mode:NSLineBreakByClipping].width;

            if ([self returnTotalWith]>self.frame.size.width) {
                
                [tempArray addObject:@(with+20)];
            }else{
                [tempArray addObject:@(self.frame.size.width/self.items.count)];
            }
        }
    }
    
    
    
    
    return tempArray;
}

- (void)setupViews{
    _currentIndex = -1;
    CGFloat with = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, with, height)];
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.layer.masksToBounds = NO;
    if ([self returnTotalWith]>self.frame.size.width) {
        _myScrollView.contentSize = CGSizeMake([self returnTotalWith], height);
    }else{
        _myScrollView.contentSize = CGSizeMake(with, height);
    }
    [self addSubview:_myScrollView];
    
    
    self.itemViews = [@[]mutableCopy];
    self.itemViewTaps = @[].mutableCopy;
    UIView *lastView = nil;
    for (int i=0; i<self.items.count; i++) {
        
        SegmentItemView *itemView = [[SegmentItemView alloc]init];
        itemView.topLabel.textColor = _noselectColor;
        itemView.midLabel.textColor = _noselectColor;
        itemView.bottomLabel.textColor = _noselectColor;

        if (self.secondItems.count>0) {
            itemView.topLabel.text = self.items[i];
            itemView.bottomLabel.text = self.secondItems[i];

            
        }else{
            itemView.midLabel.text = self.items[i];

        }
        
        if (!lastView) {
            itemView.frame = CGRectMake(0, 0, [self.itemWiths[i] floatValue], height);
        }else{
            itemView.frame = CGRectMake(CGRectGetMaxX(lastView.frame), 0, [self.itemWiths[i] floatValue], height);
        }
        
        itemView.tag = 101+i;
        [_myScrollView addSubview:itemView];
        [self.itemViews addObject:itemView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [itemView addGestureRecognizer:tap];
        [self.itemViewTaps addObject:tap];
        
        lastView = itemView;

        
    }
    
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, height-bottomLineHeight, with, bottomLineHeight)];
    bottomLineView.backgroundColor = Color_Line;
    [self addSubview:bottomLineView];
    

    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor  = self.selectColor;
    CGFloat lineWith;
    if (self.secondItems.count) {
        NSString *title = self.secondItems[0];
        lineWith = [title ss_sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(MAXFLOAT, height) mode:NSLineBreakByClipping].width+10;
        
    }else{
        NSString *title = self.items[0];
        lineWith = [title ss_sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(MAXFLOAT, height) mode:NSLineBreakByClipping].width+10;
    }
    
    _lineView.frame = CGRectMake(([self.itemWiths[0] floatValue]-lineWith)/2, height-LineHeight, lineWith, LineHeight);
    [_myScrollView addSubview:_lineView];
    
    _triangleImageview = [[UIImageView alloc]init];
    _triangleImageview.image = [UIImage imageNamed:@"san_jiao"];
    
    _triangleImageview.frame = CGRectMake((lineWith-10)/2, 0, 10, 5);
    [_lineView addSubview:_triangleImageview];
    [_triangleImageview setHidden:YES];
  

    
}



- (void)tapAction:(UITapGestureRecognizer *)tap{

    NSInteger tag = tap.view.tag - 101;
    
  
    [self changeButtonWithIndex:tag];
    
    if (self.SelectBlock) {
        self.SelectBlock(tag,self);
    }
    
    _currentIndex = tag;
    
}




- (void)changeButtonWithIndex:(NSInteger)tag{
    CGFloat height = self.frame.size.height;

    SegmentItemView *itemView = self.itemViews[tag];
    CGFloat with;
    if (self.secondItems.count) {
        NSString *title = self.secondItems[tag];
        with = [title ss_sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(MAXFLOAT, height) mode:NSLineBreakByClipping].width+10;
    }else{
        NSString *title = self.items[tag];
        with = [title ss_sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(MAXFLOAT, height) mode:NSLineBreakByClipping].width+10;
    }
    [self.myScrollView scrollRectToVisible:itemView.frame animated:YES];

    [UIView animateWithDuration:0.2 animations:^{
        
        _lineView.frame = CGRectMake(CGRectGetMinX(itemView.frame)+([self.itemWiths[tag] floatValue]-with)/2, height-LineHeight, with, LineHeight);
        _triangleImageview.frame = CGRectMake((with-10)/2, 0, 10, 5);
        
    } completion:^(BOOL finished) {
        
        
        
        
        for (int  i=0; i<self.itemViews.count; i++) {
            SegmentItemView *itemView = self.itemViews[i];
            if (tag == i) {
                [itemView.topLabel setTextColor:self.selectColor ];
                [itemView.midLabel setTextColor:self.selectColor ];
                [itemView.bottomLabel setTextColor:self.selectColor ];
                
                
            }else{
                [itemView.topLabel setTextColor:self.noselectColor ];
                [itemView.midLabel setTextColor:self.noselectColor ];
                [itemView.bottomLabel setTextColor:self.noselectColor ];
                
            }
            
        }
    }];
    
    
    
}



- (void)selectBlock:(void (^)(NSInteger, SegmentView *))block{
    self.SelectBlock = block;
}

- (void)touchWithIndex:(NSUInteger)index{
    
    [self tapAction:self.itemViewTaps[index]];
}

- (void)touchIndex:(NSInteger)index isMove:(BOOL)isMove{
    
    
//    if (index == _currentIndex) {
//        return;
//    }
    if (self.SelectBlock) {
        self.SelectBlock(index,self);
    }
    if (isMove) {
        [self changeButtonWithIndex:index];
    }
    
    _currentIndex = index;

}

- (void)changeButtonWithIndex:(NSInteger)index progress:(CGFloat)progress{
    
    NSLog(@"%f",progress);
    
    CGFloat height = self.frame.size.height;
    SegmentItemView *itemView = self.itemViews[index];
    CGFloat with;
    if (self.secondItems.count) {
        NSString *title = self.secondItems[index];
        with = [title ss_sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(MAXFLOAT, height) mode:NSLineBreakByClipping].width+10;
    }else{
        NSString *title = self.items[index];
        with = [title ss_sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(MAXFLOAT, height) mode:NSLineBreakByClipping].width+10;
    }
    
    CGFloat lastWith;
    

    SegmentItemView *lastItem = self.itemViews[_currentIndex];
    
    if (self.secondItems.count) {
        NSString *title = self.secondItems[_currentIndex];
        lastWith = [title ss_sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(MAXFLOAT, height) mode:NSLineBreakByClipping].width+10;
    }else{
        NSString *title = self.items[_currentIndex];
        lastWith = [title ss_sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(MAXFLOAT, height) mode:NSLineBreakByClipping].width+10;
    }
    
    
    CGFloat lastLineMinX = CGRectGetMinX(lastItem.frame)+(CGRectGetWidth(lastItem.frame)-lastWith)/2;
    CGFloat lineMinX = CGRectGetMinX(itemView.frame)+(CGRectGetWidth(itemView.frame)-with)/2;
    NSLog(@"%f,%f",lastLineMinX,lineMinX);
    
    _lineView.frame = CGRectMake(lastLineMinX+(lineMinX-lastLineMinX)*progress, height-LineHeight, with, LineHeight);
    _triangleImageview.frame = CGRectMake((with-10)/2, 0, 10, 5);
    
    
   
}


- (void)setShowTriangle:(BOOL)showTriangle{
    _showTriangle = showTriangle;
    
    [_triangleImageview setHidden:!_showTriangle];
    
}
- (void)setTitle:(NSString *)title index:(NSInteger)index{
    SegmentItemView *itemView = self.itemViews[index];
    itemView.midLabel.text = title;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
