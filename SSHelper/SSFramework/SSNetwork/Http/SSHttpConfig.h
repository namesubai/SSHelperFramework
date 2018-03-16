
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//
//网络配置请求
#import <Foundation/Foundation.h>

@interface SSHttpConfig : NSObject
+ (instancetype)sharedManager;

@property (nonatomic, strong) NSDictionary *unifiedParams;//配置全局参数
@property (nonatomic, strong) NSDictionary *headerParams;//请求头参数
@property (nonatomic, copy) NSString *httpServiceUrl;//服务器链接
@property (nonatomic, assign) BOOL isJsonRequest;//是表单参数请求
@property (nonatomic, copy) NSString *httpMd5Key;

//请求加密
- (NSString *)configEncryptUrlWithHttpServiceUrl:(NSString *)httpServiceUrl paramDict:(NSDictionary *)paramDict;

@end
