//
//  SSBasicTableViewCell.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/20.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "SSBasicTableViewCell.h"
#import "Masonry.h"
#import "Categorise.h"
#import "SSHelperDefine.h"
@interface SSBasicTableViewCell ()

@property (strong, nonatomic) UILabel *NumberLabel;
@property (strong, nonatomic) UIImageView *NumberImageView;

@end

@implementation SSBasicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)rightTipLabel{
    if (!_rightTipLabel) {
        _rightTipLabel  = [UILabel returnLabelFram:CGRectZero
                                         textColor:Color_Text_Detail
                                          textFont:[UIFont systemFontOfSize:12]
                                        numberLine:0
                                      cornerRadius:0
                                    backgroudColor:nil];
        _rightTipLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightTipLabel];
        
        [_rightTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightIcon.mas_left).offset(-5);
            make.centerY.equalTo(@0);
            if (self.leftTextLabel) {
                make.left.greaterThanOrEqualTo(self.leftTextLabel.mas_right).offset(5);
                
            }
            if (self.basicTextLabel) {
                make.left.greaterThanOrEqualTo(self.basicTextLabel.mas_right).offset(5);
                
            }
            
            
        }];
        
    }
    
    return _rightTipLabel;
}


- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc]init];
        _rightIcon.image = [[UIImage imageNamed:@"cell_right_icon"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
        [self.contentView addSubview:_rightIcon];
        __weak typeof(self) weakself = self;
        [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(weakself.contentView);
            make.right.equalTo(weakself.contentView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(7, 13));
            
        }];
        [_rightIcon setHidden:YES];
    }
    return _rightIcon;
}


- (UILabel *)leftTextLabel{
    if (!_leftTextLabel) {
        _leftTextLabel = [UILabel returnLabelFram:CGRectZero
                                        textColor:Color_Text_Standard
                                         textFont:[UIFont systemFontOfSize:14]
                                       numberLine:1
                                     cornerRadius:0
                                   backgroudColor:nil];
        [self.contentView addSubview:_leftTextLabel];
        
        [_leftTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(@0);
            make.height.equalTo(@15);
        }];
        
    }
    
    return _leftTextLabel;
}


- (UILabel *)rightTextLabel{
    if (!_rightTextLabel) {
        _rightTextLabel = [UILabel returnLabelFram:CGRectZero
                                         textColor:Color_Text_Detail
                                          textFont:[UIFont systemFontOfSize:14]
                                        numberLine:1
                                      cornerRadius:0
                                    backgroudColor:nil];
        _rightTextLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightTextLabel];
        
        [_rightTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.centerY.equalTo(@0);
            make.height.equalTo(@15);
        }];
        
    }
    
    return _rightTextLabel;
}

- (UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
        _bottomLineView.backgroundColor = Color_Line;
        [self.contentView addSubview:_bottomLineView];
        [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@(0));
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
        
    }
    
    return _bottomLineView;
    
}

- (void)setShowBottomLine:(BOOL)showBottomLine{
    [self.bottomLineView setHidden:!showBottomLine];
}

- (void)setBottomLineEdgeInsets:(UIEdgeInsets)bottomLineEdgeInsets{
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(bottomLineEdgeInsets.left));
        make.right.equalTo(@(bottomLineEdgeInsets.right));
        make.bottom.equalTo(@(bottomLineEdgeInsets.bottom));
        make.height.equalTo(@0.5);
    }];
}


- (UILabel *)NumberLabel{
    if (!_NumberLabel) {
        UIImageView *NumberImageView = [UIImageView new];
        NumberImageView.image = [UIImage imageNamed:@"newtip_yuanicon"];
        [self.contentView addSubview:NumberImageView];
        _NumberLabel = [UILabel returnLabelFram:CGRectZero
                                      textColor:[UIColor whiteColor]
                                       textFont:[UIFont systemFontOfSize:10]
                                     numberLine:1
                                   cornerRadius:0
                                 backgroudColor:nil];
        _NumberLabel.textAlignment = NSTextAlignmentCenter;
        [NumberImageView addSubview:_NumberLabel];
        self.NumberImageView = NumberImageView;
        
        [NumberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_showDisclosureIndicator) {
                make.right.equalTo(_rightIcon.mas_left).offset(-5);
            }else{
                make.right.equalTo(@(-10));
            }
            make.centerY.equalTo(@0);
        }];
        
        [_NumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(NumberImageView).insets(UIEdgeInsetsMake(2, 5, 2, 5));
        }];
        
    }
    
    return _NumberLabel;
}


- (UIImageView *)basicImageView{
    if (!_basicImageView) {
        _basicImageView = [UIImageView new];
        [self.contentView addSubview:_basicImageView];
        [_basicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(@15);
            make.top.equalTo(@10);
            make.bottom.equalTo(@(-10));
            make.width.equalTo(_basicImageView.mas_height);
        }];
        
        
    }
    
    return _basicImageView;
}

- (UILabel *)basicTextLabel{
    if (!_basicTextLabel) {
        _basicTextLabel = [UILabel returnLabelFram:CGRectZero
                                         textColor:Color_Text_Standard
                                          textFont:[UIFont systemFontOfSize:14]
                                        numberLine:1
                                      cornerRadius:0
                                    backgroudColor:nil];
        [self.contentView addSubview:_basicTextLabel];
        
        @weakify(self);
        [_basicTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.basicImageView.mas_right).offset(10);
            make.centerY.equalTo(@0);
            make.right.lessThanOrEqualTo(self.rightTipLabel.mas_left).offset(-5);
        }];
    }
    
    return _basicTextLabel;
}
- (void)setShowDisclosureIndicator:(BOOL)showDisclosureIndicator{
    _showDisclosureIndicator = showDisclosureIndicator;
    
    [self.rightIcon setHidden:!_showDisclosureIndicator];
    
    
}

- (void)setUnReadNumber:(NSInteger)unReadNumber{
    _unReadNumber = unReadNumber;
    if (unReadNumber >0) {
        
        self.NumberImageView.hidden = NO;
        
        NSString *num = nil;
        if (unReadNumber>99) {
            num = @"99..";
        }else{
            num = [NSString stringWithFormat:@"%ld",unReadNumber];
        }
        self.NumberLabel.text = num;
    }else{
        self.NumberImageView.hidden = YES;
    }
}

- (void)setBasicImageCanTouch:(BOOL)basicImageCanTouch{
    _basicImageCanTouch = basicImageCanTouch;
    _basicImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_basicImageView addGestureRecognizer:tap];
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.basicImageViewAction) {
        self.basicImageViewAction(self,tap.view);
    }
}

- (TitleTextFieldView *)titleTextfield{
    if (!_titleTextfield) {
        _titleTextfield = [[TitleTextFieldView alloc]initWithFrame:CGRectZero titleWidth:0 margin:10];
        [self.contentView addSubview:_titleTextfield];
        [_titleTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.bottom.equalTo(@0);
            make.right.equalTo(@(-10));
        }];
    }
    
    return _titleTextfield;
}


- (void)ss_cellAction:(void (^)(id, id))block{
    self.cellAction  = block;
}
- (void)ss_basicImageViewAction:(void (^)(id, id))block{
    self.basicImageViewAction = block;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
