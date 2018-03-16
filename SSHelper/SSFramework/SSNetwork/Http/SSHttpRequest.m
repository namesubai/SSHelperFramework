
//
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import "SSHttpRequest.h"
#import "AFNetWorking.h"
#import "SSCacheDataCenter.h"



@implementation SSHttpRequest
+ (instancetype)sharedManager
{
    static SSHttpRequest *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SSHttpRequest alloc] init];
    });
    return instance;
}

+ (AFHTTPSessionManager *)returnSessionManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
          manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
    });
    return manager;
}

#pragma mark -

- (void)requestWithConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult{
    [self requestWithConfig:requestConfig responseResult:responseResult progress:nil];
}
- (void)upLoadWithConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress{
    requestConfig.requestType = RequestTypeUpLoad;
    [self requestWithConfig:requestConfig responseResult:responseResult progress:progress];
}
- (void)downLoadWithConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress{
    requestConfig.requestType = RequestTypeDownLoad;
    [self requestWithConfig:requestConfig responseResult:responseResult progress:progress];
}

#pragma mark - 公共调用
- (void)requestWithConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress{
    if (!requestConfig.requestUrl.length) {
        NSLog(@"请求链接为空");
        return;
    }
    NSLog(@"\n----请求连接-----\n%@", requestConfig.paramUrl);

    NSString *url = [requestConfig.requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionaryWithDictionary:requestConfig.returnAllParam];

    //缓存路径
    NSString *cacheUrl;
    if (requestConfig.customCacheKey.length) {
        cacheUrl = requestConfig.customCacheKey;
    }else{
        cacheUrl = requestConfig.defaultCacheKey;
    }
    //是否返回缓存数据
    if (requestConfig.cacheTimeInSeconds>=0) {
        [[SSCacheDataCenter sharedManager]getHttpCacheDataFromCachePath:cacheUrl success:^(NSData *cacheData) {
            if (cacheData) {
                id myResult = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
                responseResult(myResult,requestConfig,nil,YES);
                NSLog(@"\n----网络缓存数据----\n%@",myResult);
            }
        }];
    }
    
    
    AFHTTPSessionManager *  manager = [SSHttpRequest returnSessionManager];
    //是否json表单请求
    if (requestConfig.isJsonRequest) {
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
  
    [manager.requestSerializer setTimeoutInterval:requestConfig.timeoutInterval];
    
    if (requestConfig.headerParams) {
        for (NSString *key in requestConfig.headerParams.allKeys) {
            [manager.requestSerializer setValue:requestConfig.headerParams[key] forHTTPHeaderField:key];
        }
    }
    NSURLSessionDataTask * task;
    
    __weak typeof(self) weakSelf = self;
    
    //get请求
    if (requestConfig.requestType == RequestTypeGet) {
        task = [manager GET:url
                 parameters:requestParam
                   progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:responseObject error:nil responseResult:responseResult];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:nil error:error responseResult:responseResult];
        }];
        
        
    }
    //post请求
    if (requestConfig.requestType == RequestTypePost) {
        
        task = [manager POST:url
                  parameters:requestParam
                    progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:responseObject error:nil responseResult:responseResult];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:nil error:error responseResult:responseResult];
        }];
        
    }
    //上传文件
    if (requestConfig.requestType == RequestTypeUpLoad) {
        
        task = [manager POST:url
                  parameters:requestParam
   constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
            
            [weakSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:responseObject error:nil responseResult:responseResult];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf dealResponseWithRequestConfig:requestConfig task:task responseObject:nil error:error responseResult:responseResult];
            
        }];
        
        
    }
    //下载文件
    if (requestConfig.requestType == RequestTypeDownLoad) {
        
    }
    requestConfig.dataTask = task;
    
}

#pragma mark - 处理数据

- (void)dealResponseWithRequestConfig:(SSHttpRequestConfig *)requestConfig task:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error responseResult:(ResponseResult)responseResult{
    
    if (error) {
        
        [SSHttpResponse showTipWithError:error];
        responseResult(nil,requestConfig,error,NO);
        
    }else{
        
        NSData *resultData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString * dataString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSData *requstData=[dataString dataUsingEncoding:NSUTF8StringEncoding];
        id myResult = [NSJSONSerialization JSONObjectWithData:requstData options:NSJSONReadingMutableContainers error:nil];
   
        NSLog(@"\n----网络请求数据----\n%@",myResult);
        
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = (NSDictionary *)myResult;
            NSInteger code = [result[@"error"]integerValue];
            if (requestConfig.cacheTimeInSeconds>=0&&code==HttpResponseSuccess) {
                //更新缓存数据
                NSString *cacheUrl;
                if (requestConfig.customCacheKey.length) {
                    cacheUrl = requestConfig.customCacheKey;
                }else{
                    cacheUrl = requestConfig.defaultCacheKey;
                }
                [[SSCacheDataCenter sharedManager]saveHttpCacheData:requstData cachePath:cacheUrl];
            }
            
        }
        
        responseResult(myResult,requestConfig,nil,NO);
        
    }
    
}




@end
