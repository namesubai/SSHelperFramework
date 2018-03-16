//
//  SSHttpRequestConfig.h
//  SSHelper
//
//  Created by quanminqianbao on 2018/3/16.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
//请求方式
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypePost,   //post
    RequestTypeGet,    //get
    RequestTypeUpLoad, //上传
    RequestTypeDownLoad, //下载
};


@interface SSHttpRequestConfig : NSObject


@property (nonatomic, assign) RequestType requestType; //请求方式
@property (nonatomic, strong) NSDictionary *paramDict; //参数字典
@property (nonatomic, strong) NSDictionary *returnAllParam; //带公共参数字典

@property (nonatomic, copy) NSString *requestUrl;//请求的链接
@property (nonatomic, copy) NSString *paramUrl;//带参数的请求链接
@property (nonatomic, strong) NSArray <NSData *> *fileDatas; //要上传的文件
@property (nonatomic, strong) NSArray <NSString *> *names; //图片名称
@property (nonatomic, assign) NSTimeInterval timeoutInterval;//设置请求时间，默认30秒
@property (nonatomic, strong) NSDictionary *unifiedParams;//配置全局参数
@property (nonatomic, strong) NSDictionary *headerParams;//请求头参数
@property (nonatomic, assign) BOOL isJsonRequest;//是表单参数请求

@property (nonatomic, copy) NSString *customCacheKey;//自定义网络数据缓存的路径
@property (nonatomic, copy) NSString *defaultCacheKey;//默认网络数据缓存的路径
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, assign) BOOL isNotShowLogin;

@property (nonatomic, assign) NSInteger cacheTimeInSeconds; //缓存时间,默认0,永久


- (NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr paramDict:(NSDictionary *)paramDict;
@end
