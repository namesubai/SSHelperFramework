//
//  UITextField+Keyborad.h
//  JHTDoctor
//
//  Created by yangsq on 16/7/19.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidChangeTextField)(UITextField *textField);

typedef void(^WillChangeTextField)(UITextField *textField);

typedef void(^BeginEditTextField)(UITextField *textField);

typedef void(^EndEditTextField)(UITextField *textField);


typedef NS_ENUM(NSInteger, CustomKeyboradType) {
    KeyBoardType_Default_Type,
    KeyBoardType_CMW_Type, //只能输入中文英文数字的组合
    KeyBoardType_NumberDecimal_Type,//整数和小数
    KeyBoardType_OnlyNumber_Type, //数字
    
};

@interface UITextField (Keyborad)<UITextFieldDelegate>

@property (copy, nonatomic) DidChangeTextField didChange;
@property (copy, nonatomic) WillChangeTextField willChange;
@property (copy, nonatomic) BeginEditTextField beginEdit;
@property (copy, nonatomic) EndEditTextField endEdit;

@property (assign, nonatomic) CustomKeyboradType customKeyBoardType;
@property (assign, nonatomic) NSInteger maxWordNum; //字母数
@property (assign, nonatomic) float maxNumber;  //填写数字的时候，最大值
@property (assign, nonatomic) float minNumber;  //填写数字的时候，最小值


- (void)didChange:(DidChangeTextField)block;
- (void)willChange:(WillChangeTextField)block;
- (void)beginEdit:(BeginEditTextField)block;
- (void)endEdit:(EndEditTextField)block;

@end
