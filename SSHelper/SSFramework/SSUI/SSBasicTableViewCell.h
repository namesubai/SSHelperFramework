//
//  SSBasicTableViewCell.h
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/20.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "BasicRefreshTableViewCell.h"
#import "TitleTextFieldView.h"

@interface SSBasicTableViewCell : BasicRefreshTableViewCell

@property (assign ,nonatomic)  BOOL showDisclosureIndicator;
@property (copy, nonatomic) void(^cellAction)(id viewCell,id sender);
@property (copy, nonatomic) void(^basicImageViewAction)(id viewCell,id sender);
@property (strong, nonatomic)  UIImageView *rightIcon; //右边图标
@property (strong, nonatomic)  UILabel *rightTipLabel;//右边图标前面的文字
@property (strong, nonatomic)  UIImageView *basicImageView;//图片
@property (strong, nonatomic)  UILabel *basicTextLabel;
@property (strong, nonatomic)  UILabel *leftTextLabel;
@property (strong, nonatomic)  UILabel *rightTextLabel;
@property (strong, nonatomic)  UIView *bottomLineView;

@property (assign, nonatomic) NSInteger unReadNumber;//未读数量
@property (assign, nonatomic) BOOL basicImageCanTouch;
@property (assign, nonatomic) BOOL showBottomLine;
@property (assign, nonatomic) UIEdgeInsets bottomLineEdgeInsets;
@property (nonatomic, strong) TitleTextFieldView *titleTextfield;


//cell上的点击
- (void)ss_cellAction:(void(^)(id viewCell,id sender))block;
//图片的点击
- (void)ss_basicImageViewAction:(void(^)(id viewCell,id sender))block;

@end
