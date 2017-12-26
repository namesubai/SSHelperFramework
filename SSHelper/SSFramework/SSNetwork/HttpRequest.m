//
//  HttpRequest.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/17.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetWorking.h"
#import <CommonCrypto/CommonDigest.h>
#import "SSHelperDefine.h"
#import "Categorise.h"

#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_With_QoS_Available 1140.11
#else
#define NSFoundationVersionNumber_With_QoS_Available NSFoundationVersionNumber_iOS_8_0
#endif
static dispatch_queue_t request_cache_writing_queue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attr = DISPATCH_QUEUE_SERIAL;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_With_QoS_Available) {
            attr = dispatch_queue_attr_make_with_qos_class(attr, QOS_CLASS_BACKGROUND, 0);
        }
        queue = dispatch_queue_create("com.yuantiku.ytkrequest.caching", attr);
    });
    
    return queue;
}

@implementation HttpRequest
+ (instancetype)sharedManager
{
    static HttpRequest *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HttpRequest alloc] init];
    });
    return instance;
}

+ (AFHTTPSessionManager *)returnSessionManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
    });
    return manager;
}


- (void)requestWithConfig:(HttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult{
    [self requestWithConfig:requestConfig responseResult:responseResult progress:nil];
}
- (void)upLoadWithConfig:(HttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress{
    requestConfig.requestType = RequestTypeUpLoad;
     [self requestWithConfig:requestConfig responseResult:responseResult progress:progress];
}
- (void)downLoadWithConfig:(HttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress{
    requestConfig.requestType = RequestTypeDownLoad;
     [self requestWithConfig:requestConfig responseResult:responseResult progress:progress];
}

- (void)requestWithConfig:(HttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress{
    if (!requestConfig.requestUrl.length) {
        NSLog(@"请求链接为空");
        return;
    }
   NSString *url = [requestConfig.requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionaryWithDictionary:requestConfig.paramDict];
    if (requestConfig.unifiedParams) {
        [requestParam addEntriesFromDictionary:requestConfig.unifiedParams];
    }
    
    NSLog(@"\n\n---请求连接-----\n%@\n\n", [[requestConfig urlDictToStringWithUrlStr:requestConfig.requestUrl paramDict:requestConfig.paramDict]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    NSString *cacheUrl;
    if (requestConfig.customCacheKey.length) {
        cacheUrl = requestConfig.customCacheKey;
    }else{
        cacheUrl = requestConfig.defaultCacheKey;
    }
     //是否返回缓存数据
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self returnCachePath:cacheUrl] isDirectory:nil]) {
        CacheBasicData *basicData = [self loadCacheMetadataWithCachePath:cacheUrl];
        if (![basicData.appVerSionString isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]) {
            NSLog(@"版本号不匹配");
        }else{
            if (requestConfig.cacheTimeInSeconds>=0) {
                [self getCacheDataFromCacheKey:cacheUrl success:^(NSData *cacheData) {
                    if (cacheData) {
                        id myResult = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
                        responseResult(myResult,nil,YES);
                        NSLog(@"\nCache:%@\n",myResult);
                    }
                }];
                
            }
        }
        
    }

    
    AFHTTPSessionManager *  manager = [HttpRequest returnSessionManager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    [manager.requestSerializer setTimeoutInterval:requestConfig.timeoutInterval];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    manager.securityPolicy = securityPolicy;
//    //是否接受无效的证书
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    //是否匹配域名
//    manager.securityPolicy.validatesDomainName = NO;
    
    
    if (requestConfig.headerParams) {
        for (NSString *key in requestConfig.headerParams.allKeys) {
            [manager.requestSerializer setValue:requestConfig.headerParams[key] forHTTPHeaderField:key];
        }
    }
    NSURLSessionDataTask * task;
    @weakify(self);
    if (requestConfig.requestType == RequestTypeGet) {
        task = [manager GET:url parameters:requestParam progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @strongify(self);
            [self dealResponseWithRequestConfig:requestConfig task:task responseObject:responseObject error:nil responseResult:responseResult];
  
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            @strongify(self);
          [self dealResponseWithRequestConfig:requestConfig task:task responseObject:nil error:error responseResult:responseResult];
        }];
        
        
    }
    if (requestConfig.requestType == RequestTypePost) {
     
        task = [manager POST:url parameters:requestParam progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @strongify(self);
          [self dealResponseWithRequestConfig:requestConfig task:task responseObject:responseObject error:nil responseResult:responseResult];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            @strongify(self);
            [self dealResponseWithRequestConfig:requestConfig task:task responseObject:nil error:error responseResult:responseResult];
        }];
        
    }
    if (requestConfig.requestType == RequestTypeUpLoad) {
        
        
        task = [manager POST:url parameters:requestParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            // 给上传的文件命名
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
            
            for (int i=0; i<requestConfig.fileDatas.count; i++) {
                NSString * manyfileName =[NSString stringWithFormat:@"%@_%d.png",@(timeInterval),i];
                [formData appendPartWithFileData:requestConfig.fileDatas[i] name:requestConfig.names[i] fileName:manyfileName mimeType:@"image/png"];
                
            }
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            float myProgress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            NSLog(@"上传文件进度：%lf",myProgress);
            progress(uploadProgress);
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @strongify(self);
            
            [self dealResponseWithRequestConfig:requestConfig task:task responseObject:responseObject error:nil responseResult:responseResult];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            @strongify(self);
            [self dealResponseWithRequestConfig:requestConfig task:task responseObject:nil error:error responseResult:responseResult];
            
        }];
        
        
    }
    requestConfig.dataTask = task;
    [task resume];
    
}


- (void)dealResponseWithRequestConfig:(HttpRequestConfig *)requestConfig task:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error responseResult:(ResponseResult)responseResult{
    
    if (error) {
        if (error.code == NSURLErrorTimedOut) {
            //请求超时
            [self showWithMessageinWindow:@"网络请求超时，请检查网络！"];
            !requestConfig.dataTask?:[requestConfig.dataTask cancel];
        }else if (error.code == NSURLErrorNotConnectedToInternet||error.code == NSURLErrorNetworkConnectionLost){
            
            [self showWithMessageinWindow:@"当前网络不稳定，请检查网络！"];
            
        }else if(error.code == NSURLErrorBadURL|| error.code == NSURLErrorNetworkConnectionLost){
            
            [self showWithMessageinWindow:@"当前网络不稳定，请检查网络!"];
            !requestConfig.dataTask?:[requestConfig.dataTask cancel];
            
        }else{
            [self showErrorHUD];
        }
   
        responseResult(nil,error,NO);
        
    }else{
     
        NSData *resultData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString * dataString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSData *requstData=[dataString dataUsingEncoding:NSUTF8StringEncoding];
        id myResult = [NSJSONSerialization JSONObjectWithData:requstData options:NSJSONReadingMutableContainers error:nil];
        NSMutableDictionary *requestParam = [NSMutableDictionary dictionaryWithDictionary:requestConfig.paramDict];
        if (requestConfig.unifiedParams) {
            [requestParam addEntriesFromDictionary:requestConfig.unifiedParams];
        }
        NSLog(@"Url%@",requestConfig.paramUrl);
        NSLog(@"%@",myResult);
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = (NSDictionary *)myResult;
            NSInteger code = [result[@"code"]integerValue];
            NSString *message = result[@"message"];
            if (requestConfig.cacheTimeInSeconds>=0&&code==0) {
                //更新缓存数据
                [self saveCacheWithData:requstData cacheKey:requestConfig.defaultCacheKey];
            }
            
        }
        
        responseResult(myResult,nil,NO);
        
    }
    
}


#pragma mark - 保存缓存
- (void)saveCacheWithData:(NSData *)requestData cacheKey:(NSString *)cacheKey{
    NSString *path = [self returnFilePath];
    NSString *cache = [self returnCachePath:cacheKey];
    dispatch_async(request_cache_writing_queue(), ^{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path isDirectory:nil]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                                       attributes:nil error:&error];
            if (error) {
                NSLog(@"创建文件夹失败");
            }
        }
        
        
        BOOL isSuceess = [requestData writeToFile:cache atomically:YES];
        if (isSuceess) {
            NSLog(@"创建/更新缓存成功");
        }
        CacheBasicData *basicData = [CacheBasicData new];
        basicData.appVerSionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [NSKeyedArchiver archiveRootObject:basicData toFile:[self returnCacheBasicDataFilePathWithCachePath:cacheKey]];

    });
    
}

- (NSString *)returnFilePath{
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"RequestCache"];
    return path;
}

#pragma mark - 读取缓存

- (void)getCacheDataFromCacheKey:(NSString *)cacheKey success:(void(^)(NSData *cacheData))success{
    
    dispatch_async(request_cache_writing_queue(), ^{
        NSString *cache = [self returnCachePath:cacheKey];
        NSData *cacheData = [NSData dataWithContentsOfFile:cache];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(cacheData);
            }
        });
    });
}
#pragma mark - 返回缓存的路径
- (NSString *)returnCachePath:(NSString *)cacheKey{
    return [[self returnFilePath] stringByAppendingPathComponent:[self md5StringFromString:cacheKey]];
}
#pragma mark - md5编码
- (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}
#pragma mark - 缓存的配置信息的路径
- (NSString *)returnCacheBasicDataFilePathWithCachePath:(NSString *)cacheKey {
    NSString *cacheMetadataFileName = [NSString stringWithFormat:@"%@.basicData", [self returnCachePath:cacheKey]];
    return cacheMetadataFileName;
}
#pragma mark - 读取缓存配置信息
- (CacheBasicData *)loadCacheMetadataWithCachePath:(NSString *)cacheKey{
    NSString *path = [self returnCacheBasicDataFilePathWithCachePath:cacheKey];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    CacheBasicData *basicData = nil;
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        @try {
            basicData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        } @catch (NSException *exception) {
            NSLog(@"Load cache metadata failed, reason = %@", exception.reason);
        }
    }
    return basicData;
}

@end
