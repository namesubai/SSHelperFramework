//
//  NSString+Add.m
//  JHTDoctor
//
//  Created by yangsq on 16/4/23.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "NSString+Add.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSDate+Add.h"

#define NUM_OR_WORD   @"QWERTYUIOPLKJHGFDSAZXCVBNMzxcvbnmlkjhgfdsaqwertyuiop1234567890"
#define NUM           @"0123456789"
#define NUM_AND_POINT @"0123456789."

@implementation NSString (Add)
+ (NSString *)convertThousandWithNumber:(double)number{
    
    
    NSString *string = nil;
    if (number >= 10000) {
        
        double num = number/10000.00f;
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        
        [numberFormatter setPositiveFormat:@"0.00"];
        string = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:num]];
        if ([string containsString:@".00"]) {
            
            string = [string stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        string = [NSString stringWithFormat:@"%@万",string];
        
    }else{
        
        string = [NSString stringWithFormat:@"%.f",number];
    }
    
    
    return string;
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (BOOL)isValidateMobile:(NSString *)mobile{
    //手机号以13, 15,17,18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]|(17[0-9])))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    if (mobile.length!=11) {
        return NO;
    }
    return YES;
//    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)decimalNumberWithString1:(NSString *)string1 String2:(NSString *)string2 symbol:(NSString *)symbol{
    
    NSString *tempString1 = @"0";
    NSString *tempString2 = @"0";
    if (!string1.length || !string1) {
        tempString1 = @"0";
    }else{
        tempString1 = string1;
    }
    if (!string2.length || !string2) {
        tempString2 = @"0";
    }else{
        tempString2 = string2;
    }
    
    if ([symbol isEqualToString:@"/"]&&[tempString2 integerValue]==0) {
        tempString2 = @"1";
    }
    
    
    NSDecimalNumber *decimal1 = [NSDecimalNumber decimalNumberWithString:tempString1];
    NSDecimalNumber *decimal2 = [NSDecimalNumber decimalNumberWithString:tempString2];
    
    NSDecimalNumber *tempdecimal;
    if ([symbol isEqualToString:@"+"]) {
        tempdecimal = [decimal1 decimalNumberByAdding:decimal2];
    }
    if ([symbol isEqualToString:@"-"]) {
        tempdecimal = [decimal1 decimalNumberBySubtracting:decimal2];
    }
    if ([symbol isEqualToString:@"*"]) {
        tempdecimal = [decimal1 decimalNumberByMultiplyingBy:decimal2];
    }
    if ([symbol isEqualToString:@"/"]) {
         tempdecimal = [decimal1 decimalNumberByDividingBy:decimal2];
    }
    
    
    return [tempdecimal stringValue];

}

+ (NSString *)filterWithString:(NSString *)string{
    NSString *aString = @"";
    if (![string isKindOfClass:[NSNull class]] && string != nil) {
        aString = string;
    }
    
    return aString;
    
    
    
}

+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:NUM];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

+ (BOOL)validateNumberAndPoint:(NSString *)number{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:NUM_AND_POINT];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    
    return res;
}

+ (BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}

+ (NSString *)returnNewDateWithString:(NSString *)date{
//    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
//    if ([date rangeOfString:@"-"].location != NSNotFound ) {
//        [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
//        
//    }else{
//        [dateFormatter setDateFormat:@"yyyy/MM/ddHH:mm:ss"];
//        
//    }
//    
//    
//    NSDate *oldDate = [dateFormatter dateFromString:date];
//    
//    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
//    NSString *strMsgDay = [dateFormatter stringFromDate:oldDate];
//
//    
//    NSDate *nowDate = [NSDate date];    //这是当前的时间，其实这里可以是任意时间
//    NSString *strToday = [dateFormatter stringFromDate:nowDate];
//    
//    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
//    NSDate *beforeYesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60 * 2)];
//    NSString *strYesterday = [dateFormatter stringFromDate:yesterday];
//    NSString *strbeforeYestrerday = [dateFormatter stringFromDate:beforeYesterday];
//    
//    NSString *textString = @"";
//    if ([strMsgDay isEqualToString:strToday]) {
//        [dateFormatter setDateFormat:@"HH':'mm"];
//        textString = [dateFormatter stringFromDate:oldDate];
//        
//    }else if ([strMsgDay isEqualToString:strYesterday]){
//        [dateFormatter setDateFormat:@"HH':'mm"];
//        textString = [dateFormatter stringFromDate:oldDate];
//        textString = [NSString stringWithFormat:@"昨天%@",textString];
//    }else if([strMsgDay isEqualToString:strbeforeYestrerday]) {
//        [dateFormatter setDateFormat:@"HH':'mm"];
//        textString = [dateFormatter stringFromDate:oldDate];
//        textString = [NSString stringWithFormat:@"前天%@",textString];
//
//    }else{
//        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
//        textString = [dateFormatter stringFromDate:oldDate];
//
//    }
//
//    return textString;
    
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    if ([date rangeOfString:@"-"].location != NSNotFound ) {
        [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
        
    }else{
        [dateFormatter setDateFormat:@"yyyy/MM/ddHH:mm:ss"];
        
    }
    NSDate *oldDate = [dateFormatter dateFromString:date];
    
    NSDate *nowDate = [NSDate date];    //这是当前的时间，其实这里可以是任意时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps1,*comps2;
    comps1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:nowDate];
    NSInteger Year1     = [comps1 year];
    NSInteger Month1    = [comps1 month];
    NSInteger Day1      = [comps1 day];
//        NSInteger hour1     = [comps1 hour];
//        NSInteger minute1   = [comps1 minute];
    NSInteger Week1     = [comps1 weekday];
    
    comps2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:oldDate];
    
    
    NSInteger Year2     = [comps2 year];
    NSInteger Month2    = [comps2 month];
    NSInteger Day2      = [comps2 day];
    NSInteger hour2     = [comps2 hour];
    NSInteger minute2   = [comps2 minute];
    NSInteger Week2     = [comps2 weekday];
    
    
    NSString *hourStr,*minuteStr;
    if (hour2<10) {
        hourStr = [NSString stringWithFormat:@"0%ld",hour2];
    }else{
        hourStr = [NSString stringWithFormat:@"%ld",hour2];
    }
    if (minute2<10) {
        minuteStr = [NSString stringWithFormat:@"0%ld",minute2];
    }else{
        minuteStr = [NSString stringWithFormat:@"%ld",minute2];

    }
    
    //    //前7天
    NSCalendar *tempcalendar = [NSCalendar currentCalendar];
    NSDateComponents  * tempcomps = [tempcalendar components:(NSCalendarUnitHour | NSCalendarUnitHour | NSCalendarUnitSecond) fromDate:[[NSDate alloc] init]];
    if (Week1==1) {
        [tempcomps setHour:-24*7];
    }else{
        [tempcomps setHour:-24*(Week1-1)];

    }
    [tempcomps setMinute:0];
    [tempcomps setSecond:0];
    NSDate *tmpDate = [tempcalendar dateByAddingComponents:tempcomps toDate:nowDate options:0];
    if (Year1==Year2&&Month1==Month2&&Day1==Day2) {
        return [NSString stringWithFormat:@"%@:%@",hourStr,minuteStr];
    }else{
        
       
        
        if (NSOrderedDescending==[oldDate compare:tmpDate]) {
            
            NSString *weekStr = [[NSString alloc] init];
            
            
            switch (Week2) {
                case 1:
                    weekStr = @"周日";
                    break;
                case 2:
                    weekStr = @"周一";
                    break;
                case 3:
                    weekStr = @"周二";
                    break;
                case 4:
                    weekStr = @"周三";
                    break;
                case 5:
                    weekStr = @"周四";
                    break;
                case 6:
                    weekStr = @"周五";
                    break;
                case 7:
                    weekStr = @"周六";
                    break;
                    
                default:
                    break;
            }
            
            return [NSString stringWithFormat:@"%@ %@:%@",weekStr,hourStr,minuteStr];
        }else{
            return [NSString stringWithFormat:@"%ld/%ld/%ld %@:%@",Year2,Month2,Day2,hourStr,minuteStr];
        }
    }

    
}

+ (NSString *)returnNewDateWithTime:(long long)time{
    if (time==0) {
        return @"";
    }
    
    NSString *timeStr = @"";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    timeStr = [NSString returnNewDateWithString: [date ss_stringWithFormat:@"yyyy-MM-ddHH:mm:ss"]];
    
    return timeStr;
}

+ (NSString *)returnNewDateWithTime:(long long)time format:(NSString *)format{
    if (time==0) {
        return @"";
    }
    
    NSString *timeStr = @"";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    timeStr = [date ss_stringWithFormat:format];
    
    return timeStr;
}

+ (long long)returnNewTimeWithDate:(NSString *)date format:(NSString *)format{
    if (date==0) {
        return 0;
    }
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *tempdate = [dateFormatter dateFromString:date];
    return tempdate.timeIntervalSince1970*1000;
}


+ (NSString *)returnNewDateWithSpace:(NSString *)date{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    if ([date rangeOfString:@"-"].location != NSNotFound ) {
        [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
        if (![date containsString:@":"]) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        
    }else{
        [dateFormatter setDateFormat:@"yyyy/MM/ddHH:mm:ss"];
        
    }
     NSDate *oldDate = [dateFormatter dateFromString:date];
    if ([date rangeOfString:@"-"].location != NSNotFound ) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    }else{
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
    }
    NSString *strMsgDay = [dateFormatter stringFromDate:oldDate];
    if (strMsgDay.length) {
        return strMsgDay;

    }
    return @"";

}

+ (BOOL)validateNumberORWord:(NSString *)string{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:NUM_OR_WORD];
    int i = 0;
    while (i < string.length) {
        NSString * tempstring = [string substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [tempstring rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

+ (NSMutableAttributedString *)returnAttributedString:(NSString *)string keyStrings:(NSArray *)keyStrings attributes:(NSArray *)attributes values:(NSArray *)values{
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    for (NSInteger i=0; i<keyStrings.count; i++) {
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"(%@)",keyStrings[i]] options:0 error:nil];
        //遍历字符串，usingBlock中返回子字符串的状态，在usingBlock中处理子字符串
        [regularExpression enumerateMatchesInString:string options:0 range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            [attributStr addAttribute:attributes[i] value:values[i] range:result.range];

        }];
        
    }
    
    return attributStr;
}
//判断中英混合的的字符串长度及字符个数
+ (NSUInteger)returnMixtureStringLength:(NSString*)string
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [string dataUsingEncoding:enc];
    return [da length];
}

+ (BOOL)validateCMWString:(NSString *)string{
    NSString *regex = @"^[a-z0－9A-Z\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:string]) {
        return YES;
    }
    
    return NO;
}
+ (BOOL)validateCMW_PunctuationString:(NSString *)string{
    NSString *regex = @"[0-9a-zA-Z\u4e00-\u9fa5\\.\\*\\)\\(\\+\\$\\[\\?\\\\\\^\\{\\|\\]\\}%%%@\'\",。‘、-【】·！_——=:;；<>《》‘’“”!#~]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:string]) {
        return YES;
    }
    
    return NO;
}

+(NSString *)replaceSecretPhoneNumber:(NSString *)phoneNumber{
    
    NSString *str1 = [phoneNumber substringWithRange:NSMakeRange(0, 3)];
    NSString *str2 = [phoneNumber substringFromIndex:phoneNumber.length-4];
    
    return [NSString stringWithFormat:@"%@****%@",str1,str2];
}
- (NSString *)md5String {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
- (CGSize)ss_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

@end
