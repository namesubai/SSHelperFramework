//
//  HttpRequestConfig.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/17.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "HttpRequestConfig.h"

@implementation CacheBasicData

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.appVerSionString forKey:NSStringFromSelector(@selector(appVerSionString))];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.appVerSionString = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVerSionString))];
    
    return self;
}

@end


@implementation HttpRequestConfig

- (id)init{
    if (self = [super init]) {
        self.timeoutInterval = 30;
        self.cacheTimeInSeconds = 0;
        NSMutableDictionary *headerParams = @{}.mutableCopy;
        //配置参数
        self.headerParams = headerParams;

    }
    
    return self;
}

- (NSString *)paramUrl{
    if (!_requestUrl.length) {
        return @"";
    }
    return [self urlDictToStringWithUrlStr:_requestUrl paramDict:_paramDict];
}
- (NSString *)defaultCacheKey{
    return self.paramUrl;
}

- (NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr paramDict:(NSDictionary *)paramDict{
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    if (_unifiedParams) {
        [requestParam addEntriesFromDictionary:_unifiedParams];
    }
    
    NSArray *allkeys = [requestParam allKeys];
    
    NSArray *sortArray = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *parts = [NSMutableArray array];
    [sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *encodedKey = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *encodedValue = [[[requestParam objectForKey:obj]description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject: part];
    }];
    
    NSString *queryString = [parts componentsJoinedByString: @"&"];
    
    queryString =  queryString ? [NSString stringWithFormat:@"%@", queryString] : @"";
    
    NSString * pathStr = @"";
    if (![urlStr containsString:@"?"]) {
        pathStr =[NSString stringWithFormat:@"%@?%@",urlStr,queryString];
        
    }else{
        pathStr =[NSString stringWithFormat:@"%@%@",urlStr,queryString];
        
    }
    return pathStr;
}

@end
