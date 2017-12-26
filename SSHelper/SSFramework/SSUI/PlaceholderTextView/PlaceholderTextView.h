//
//  PlaceholderTextView.h
//  imssee
//
//  Created by subai on 16/1/8.
//  Copyright © 2016年 鑫易. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  带默认提示的textView
 */

typedef NS_ENUM(NSInteger, CustomTextViewKeyboradType) {
    
//    TextView_KeyBoardType_Default,
    TextView_KeyBoardType_CMW_PUNCTUATION,//中文英文字母标点符号
    TextView_KeyBoardType_CMW_Type,//中文英文字母
    TextView_KeyBoardType_NumberDecimal_Type, //整数和小数
    TextView_KeyBoardType_OnlyNumber_Type,    //数字
    
};

@class PlaceholderTextView;
@protocol PlaceholderTextViewDelegate <NSObject>

@optional

- (void)textViewBeginEdit:(PlaceholderTextView *)textView;
- (void)textViewEndEdit:(PlaceholderTextView *)textView;

- (void)keyboardWillShow:(PlaceholderTextView *)textView size:(CGSize)size;
- (void)keyboarWillHide:(PlaceholderTextView *)textView;
@end

@interface PlaceholderTextView : UITextView<UITextViewDelegate>

@property (copy, nonatomic) NSString *placeholder;
@property (assign, nonatomic) NSInteger maxLength;
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong, nonatomic) UILabel *wordNumLabel;
@property (assign, nonatomic) CustomTextViewKeyboradType textcustomType;


@property (copy, nonatomic) void(^didChangeText)(PlaceholderTextView *textView);

@property (weak, nonatomic) id<PlaceholderTextViewDelegate>adelegate;


- (void)didChangeText:(void(^)(PlaceholderTextView *textView))block;
@end
