
//
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import "SSHttpConfig.h"
#import "SSCacheDataCenter.h"

@implementation SSHttpConfig
+ (instancetype)sharedManager
{
    static SSHttpConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SSHttpConfig alloc] init];
    });
    return instance;
}

- (NSString *)configEncryptUrlWithHttpServiceUrl:(NSString *)httpServiceUrl paramDict:(NSDictionary *)paramDict{
    if ([[paramDict allKeys] containsObject:@"_s"] ||
        [[paramDict allKeys] containsObject:@"_t"]) {
     
        return nil;
    }
    
    if (![SSHttpConfig sharedManager].httpMd5Key.length) {return nil;}
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString *currentDate = [formatter stringFromDate:date];
    [paramDict setValue:currentDate forKey:@"_t"];
    NSArray *parameterNames = [paramDict allKeys];
    parameterNames = [parameterNames
                      sortedArrayUsingSelector:@selector(compare:)]; // 字符串编码升序排序
    
    if (![httpServiceUrl hasSuffix:@"?"] && ![httpServiceUrl hasSuffix:@"&"]) {
        if ([httpServiceUrl rangeOfString:@"?"].length <= 0) {
            httpServiceUrl = [httpServiceUrl stringByAppendingString:@"?"];
        } else {
            httpServiceUrl = [httpServiceUrl stringByAppendingString:@"&"];
        }
    }
    
    NSString *signData = @"";
    
    for (int i = 0; i < [paramDict count]; i++) {
        NSString *_key = parameterNames[i];
        NSString *_value;
        if ([paramDict[_key] isKindOfClass:[NSNumber class]]) {
            _value = [paramDict[_key]stringValue];
        }else {
            _value = paramDict[_key];
        }
        
        signData = [NSString stringWithFormat:@"%@%@=%@", signData, _key, _value];
        
        httpServiceUrl = [NSString
                   stringWithFormat:@"%@%@=%@", httpServiceUrl, _key,
                   [_value stringByAddingPercentEscapesUsingEncoding:
                    NSUTF8StringEncoding]]; // 将value编码
        
        if (i < ([paramDict count] - 1)) {
            signData = [signData stringByAppendingString:@"&"];
            httpServiceUrl = [httpServiceUrl stringByAppendingString:@"&"];
        }
    }
    httpServiceUrl = [NSString stringWithFormat:@"%@&_s=%@", httpServiceUrl,
      [[SSCacheDataCenter sharedManager]md5StringFromString:[signData stringByAppendingString:[SSHttpConfig sharedManager].httpMd5Key]]];
    
    return httpServiceUrl;
}

@end
