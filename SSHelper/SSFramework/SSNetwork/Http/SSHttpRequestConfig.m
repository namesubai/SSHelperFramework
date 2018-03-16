//
//  SSHttpRequestConfig.m
//  SSHelper
//
//  Created by quanminqianbao on 2018/3/16.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import "SSHttpRequestConfig.h"
#import "SSHttpConfig.h"

@implementation SSHttpRequestConfig
- (id)init{
    if (self = [super init]) {
        self.timeoutInterval = 30;
        //配置参数
        self.headerParams = [SSHttpConfig sharedManager].headerParams;
        self.unifiedParams = [SSHttpConfig sharedManager].unifiedParams;
        self.isJsonRequest = [SSHttpConfig sharedManager].isJsonRequest;
        
    }
    
    return self;
}

- (NSString *)paramUrl{
    if (!_requestUrl.length) {
        return @"";
    }
    return [self urlDictToStringWithUrlStr:_requestUrl paramDict:[self returnAllParam]];
}
- (NSString *)defaultCacheKey{
    return self.paramUrl;
}


- (NSDictionary *)returnAllParam{
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionaryWithDictionary:_paramDict];
    if (_unifiedParams) {
        [requestParam addEntriesFromDictionary:_unifiedParams];
    }
    return requestParam;
}


- (NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr paramDict:(NSDictionary *)paramDict{
    
    
    NSArray *allkeys = [[self returnAllParam] allKeys];
    
    NSArray *sortArray = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *parts = [NSMutableArray array];
    [sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *encodedKey = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *encodedValue = [[[[self returnAllParam] objectForKey:obj]description] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
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
