//
//  NSString+Add.h
//  JHTDoctor
//
//  Created by yangsq on 16/4/23.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Add)
//大于一万用中文万结尾
+ (NSString *)convertThousandWithNumber:(double)number;\

//判断是否是emoji
+ (BOOL)stringContainsEmoji:(NSString *)string;

//手机号码验证

+ (BOOL) isValidateMobile:(NSString *)mobile;

//邮箱验证

+ (BOOL)isValidateEmail:(NSString *)email;

//精确计算

+(NSString *)decimalNumberWithString1:(NSString *)string1 String2:(NSString *)string2 symbol:(NSString *)symbol;

//过滤字符串
+ (NSString *)filterWithString:(NSString *)string;


//判断是否输入数字（整数）

+ (BOOL)validateNumber:(NSString*)number;

//判断是否输入数字(带小数点)

+ (BOOL)validateNumberAndPoint:(NSString*)number;

//判断是否有中文


+ (BOOL)IsChinese:(NSString *)str;

//按（前天，昨天，日期的方式转换日期）

+ (NSString *)returnNewDateWithString:(NSString *)date;

 // 时间戳转日期
+ (NSString *)returnNewDateWithTime:(long long)time;


//时间戳转自定义的日期
+ (NSString *)returnNewDateWithTime:(long long)time format:(NSString *)format;


//自定义的日期转时间戳

+ (long long)returnNewTimeWithDate:(NSString *)date format:(NSString *)format;

//返回日期和时间中间分隔的日期

+ (NSString *)returnNewDateWithSpace:(NSString *)date;

// 判断是否输入数字或者字母

+ (BOOL)validateNumberORWord:(NSString *)string;

//返回自定义文本

+ (NSMutableAttributedString *)returnAttributedString:(NSString *)string keyStrings:(NSArray *)keyStrings attributes:(NSArray *)attributes values:(NSArray *)values;

//判断中英混合的的字符串长度及字符个数
+(NSUInteger)returnMixtureStringLength:(NSString*)string;

//判断输入的是中文和数字字母组合
+ (BOOL)validateCMWString:(NSString *)string;
//判断输入的是中文和数字字母组合标点符号组合
+ (BOOL)validateCMW_PunctuationString:(NSString *)string;
//电话号码中间*****
+ (NSString *)replaceSecretPhoneNumber:(NSString *)phoneNumber;
//md5
- (NSString *)md5String;
//计算文字长度
- (CGSize)ss_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

@end
