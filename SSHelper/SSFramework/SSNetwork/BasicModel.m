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
        [self setupObject];
    }
    
    return self;
}

- (void)setupObject{
 //子类重写
}

+ (void)getRequestURLStr:(NSString *)urlStr
               paramDict:(id)paramDict
                  isCash:(BOOL)isCash
           responseBlock:(responseHandler)responseDataBlock{
    HttpRequestConfig *config = [[HttpRequestConfig alloc]init];
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
    HttpRequestConfig *config = [[HttpRequestConfig alloc]init];
    config.requestUrl = urlStr;
    config.requestType = RequestTypePost;
    config.paramDict = paramDict;
    config.cacheTimeInSeconds = isCash?0:-1;
    [self requestConfig:config responseBlock:responseDataBlock];
    
}

+ (void)postRequestURLStr:(NSString *)urlStr paramDict:(id)paramDict isCash:(BOOL)isCash isNotShowLogin:(BOOL)isNotShowLogin responseBlock:(responseHandler)responseDataBlock{
    HttpRequestConfig *config = [[HttpRequestConfig alloc]init];
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
    HttpRequestConfig *config = [[HttpRequestConfig alloc]init];
    config.requestUrl = urlStr;
    config.requestType = RequestTypeUpLoad;
    config.paramDict = paramDict;
    config.fileDatas = datas;
    config.names = attachs;
    [self uploadRequestConfig:config  responseBlock:responseDataBlock uploadProgress:loadProgress];
 
}


//
+ (void)requestConfig:(HttpRequestConfig *)requestConfig
        responseBlock:(responseHandler)responseDataBlock{
    
    [[HttpRequest sharedManager]requestWithConfig:requestConfig responseResult:^(NSDictionary *resuestDict, NSError *error, BOOL isCacheData) {
        if (resuestDict) {
        
            id data = [self mj_objectWithKeyValues:resuestDict];
            !responseDataBlock?:responseDataBlock(data,nil,isCacheData);
        }else{
            !responseDataBlock?:responseDataBlock(nil,error,isCacheData);
        }
    }];
 
}

+ (void)uploadRequestConfig:(HttpRequestConfig *)requestConfig
              responseBlock:(responseHandler)responseDataBlock
             uploadProgress:(LoadProgress)progress{
    [[HttpRequest sharedManager]upLoadWithConfig:requestConfig responseResult:^(NSDictionary *resuestDict, NSError *error, BOOL isCacheData) {
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
