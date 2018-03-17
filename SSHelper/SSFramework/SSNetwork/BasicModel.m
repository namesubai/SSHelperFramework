//
//  BasicModel.m
//  JHTDoctor
//
//  Created by yangsq on 16/6/3.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "BasicModel.h"

@implementation BasicModel

- (id)init{
    self = [super init];
    
    if (self) {
        if ([self respondsToSelector:@selector(ss_replacedKeyFromPropertyName)]&&[self ss_replacedKeyFromPropertyName]) {
            [self.class mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return [self ss_replacedKeyFromPropertyName];
            }];
        }
        if ([self respondsToSelector:@selector(ss_setupObjectClassInArray)]&&[self ss_setupObjectClassInArray]) {
            [self.class mj_setupObjectClassInArray:^NSDictionary *{
                return [self ss_setupObjectClassInArray];
            }];
        }
        
        [self setupObject];
    }
    
    return self;
}

- (void)setupObject{
 //子类重写
}
- (NSDictionary *)ss_replacedKeyFromPropertyName{
    //子类重写
    return nil;
}

- (NSDictionary *)ss_setupObjectClassInArray{
    //子类重写
    return nil;
}

+ (void)getRequestURLStr:(NSString *)urlStr
               paramDict:(id)paramDict
                  isCash:(BOOL)isCash
           responseBlock:(responseHandler)responseDataBlock{
    SSHttpRequestConfig *config = [[SSHttpRequestConfig alloc]init];
    config.requestUrl = urlStr;
    config.paramDict = paramDict;
    config.requestType = RequestTypeGet;
    config.cacheTimeInSeconds = isCash?0:-1;
    [self requestConfig:config responseBlock:responseDataBlock];
}

+ (void)postRequestURLStr:(NSString *)urlStr
                paramDict:(id)paramDict
                   isCash:(BOOL)isCash
            responseBlock:(responseHandler)responseDataBlock{
    SSHttpRequestConfig *config = [[SSHttpRequestConfig alloc]init];
    config.requestUrl = urlStr;
    config.requestType = RequestTypePost;
    config.paramDict = paramDict;
    config.cacheTimeInSeconds = isCash?0:-1;
    [self requestConfig:config responseBlock:responseDataBlock];
    
}

+ (void)postRequestURLStr:(NSString *)urlStr paramDict:(id)paramDict isCash:(BOOL)isCash isNotShowLogin:(BOOL)isNotShowLogin responseBlock:(responseHandler)responseDataBlock{
    SSHttpRequestConfig *config = [[SSHttpRequestConfig alloc]init];
    config.requestUrl = urlStr;
    config.requestType = RequestTypePost;
    config.paramDict = paramDict;
    config.cacheTimeInSeconds = isCash?0:-1;
    config.isNotShowLogin = isNotShowLogin;
    [self requestConfig:config responseBlock:responseDataBlock];
}


+ (void)uploadDataWithURLStr:(NSString *)urlStr
                   paramDict:(id)paramDict
                   imageKeys:(NSArray *)attachs
                   withDatas:(NSArray *)datas
              uploadProgress:(LoadProgress)loadProgress
               responseBlock:(responseHandler)responseDataBlock{
    SSHttpRequestConfig *config = [[SSHttpRequestConfig alloc]init];
    config.requestUrl = urlStr;
    config.requestType = RequestTypeUpLoad;
    config.paramDict = paramDict;
    config.fileDatas = datas;
    config.names = attachs;
    [self uploadRequestConfig:config  responseBlock:responseDataBlock uploadProgress:loadProgress];
 
}


//
+ (void)requestConfig:(SSHttpRequestConfig *)requestConfig
        responseBlock:(responseHandler)responseDataBlock{
    [[SSHttpRequest sharedManager]requestWithConfig:requestConfig responseResult:^(NSDictionary *resuestDict, SSHttpRequestConfig *requestConfig, NSError *error, BOOL isCacheData) {
        if (resuestDict) {
            
            id data = [self mj_objectWithKeyValues:resuestDict];
            !responseDataBlock?:responseDataBlock(data,nil,isCacheData);
        }else{
            !responseDataBlock?:responseDataBlock(nil,error,isCacheData);
        }
    }];
   
}

+ (void)uploadRequestConfig:(SSHttpRequestConfig *)requestConfig
              responseBlock:(responseHandler)responseDataBlock
             uploadProgress:(LoadProgress)progress{
    [[SSHttpRequest sharedManager]upLoadWithConfig:requestConfig responseResult:^(NSDictionary *resuestDict, SSHttpRequestConfig *requestConfig, NSError *error, BOOL isCacheData) {
        if (resuestDict) {
            id data = [self mj_objectWithKeyValues:resuestDict];
            !responseDataBlock?:responseDataBlock(data,nil,isCacheData);
        }else{
            !responseDataBlock?:responseDataBlock(nil,error,isCacheData);
        }
    } progress:^(NSProgress *uploadProgress) {
        !progress?:progress(uploadProgress);
    }];
}


@end
