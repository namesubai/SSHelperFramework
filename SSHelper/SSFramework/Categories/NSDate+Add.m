//
//  NSDate+Add.m
//  SSHelper
//
//  Created by quanminqianbao on 2017/12/26.
//  Copyright © 2017年 yangshuquan. All rights reserved.
//

#import "NSDate+Add.h"

@implementation NSDate (Add)
- (NSString *)ss_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}
@end
