//
//  HttpRequestConfig.h
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/17.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//请求方式
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypePost,   //post
    RequestTypeGet,    //get
    RequestTypeUpLoad, //上传
    RequestTypeDownLoad, //下载
};


@interface CacheBasicData :NSObject <NSSecureCoding>
@property (nonatomic, strong) NSString *appVerSionString;//程序版本号
@end



@interface HttpRequestConfig : NSObject
@property (nonatomic, assign) RequestType requestType; //请求方式
@property (nonatomic, strong) NSDictionary *paramDict; //参数字典
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSArray *fileDatas; //要上传的文件
@property (nonatomic, strong) NSArray *names; //图片名称
@property (nonatomic, copy) NSString *customCacheKey;//自定义网络数据缓存的路径
@property (nonatomic, copy) NSString *defaultCacheKey;//默认网络数据缓存的路径
@property (nonatomic, copy) NSString *paramUrl;//带参数的请求链接
@property (nonatomic, strong) NSDictionary *unifiedParams;//配置全局参数
@property (nonatomic, strong) NSDictionary *headerParams;//请求头参数
@property (nonatomic, assign) NSTimeInterval timeoutInterval;//设置请求时间，默认30秒
@property (nonatomic, strong) CacheBasicData *cacheBasicData;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, assign) BOOL isNotShowLogin;

/*!
 *  缓存的策略：(如果 cacheTime == 0，将永久缓存数据) 也就是缓存的时间 以 秒 为单位计算,默认-1，不缓存
 *  分钟 ： 60
 *  小时 ： 60 * 60
 *  一天 ： 60 * 60 * 24
 *  星期 ： 60 * 60 * 24 * 7
 *  一月 ： 60 * 60 * 24 * 30
 *  一年 ： 60 * 60 * 24 * 365
 *  永远 ： 0
 */
@property (nonatomic, assign) NSInteger cacheTimeInSeconds; //默认0,永久

- (NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr paramDict:(NSDictionary *)paramDict;

@end
