//
//  BasicModel.h
//  JHTDoctor
//
//  Created by yangsq on 16/6/3.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSHttpRequest.h"
#import "MJExtension.h"



typedef void (^responseHandler)(id dataObj, NSError *error,BOOL isCache);

@interface BasicModel : NSObject
@property (assign, nonatomic) NSInteger code;


@property (copy, nonatomic) NSString *message;


- (void)setupObject;

//返回要替换的字段字典
- (NSDictionary *)ss_replacedKeyFromPropertyName;
//返回对应的数组字段
- (NSDictionary *)ss_setupObjectClassInArray;
/**
 *  get请求
 *
 *  @param urlStr            url
 *  @param paramDict        参数
 *  @param isCash            是否做缓存
 *  @param responseDataBlock 结果回调
 */
+ (void)getRequestURLStr:(NSString *)urlStr
               paramDict:(id)paramDict
                  isCash:(BOOL)isCash
           responseBlock:(responseHandler)responseDataBlock;
/**
 *  post请求
 *
 *  @param urlStr            url
 *  @param paramDict        参数
 *  @param isCash            是否做缓存
 *  @param responseDataBlock 结果回调
 */

+ (void)postRequestURLStr:(NSString *)urlStr
                paramDict:(id)paramDict
                   isCash:(BOOL)isCash
            responseBlock:(responseHandler)responseDataBlock;


+ (void)postRequestURLStr:(NSString *)urlStr
                paramDict:(id)paramDict
                   isCash:(BOOL)isCash
           isNotShowLogin:(BOOL)isNotShowLogin
            responseBlock:(responseHandler)responseDataBlock;


/**
 *  上传多个个文件,单个个文件
 *
 *  @param urlStr            url
 *  @param paramDict        参数
 *  @param attachs         文件key数组
 *  @param datas         文件数组
 *  @param loadProgress      进程
 *  @param responseDataBlock 结果回调
 */
+ (void)uploadDataWithURLStr:(NSString *)urlStr
                     paramDict:(id)paramDict
                   imageKeys:(NSArray *)attachs
                   withDatas:(NSArray *)datas
              uploadProgress:(LoadProgress)loadProgress
               responseBlock:(responseHandler)responseDataBlock;



+ (void)requestConfig:(SSHttpRequestConfig *)requestConfig
            responseBlock:(responseHandler)responseDataBlock;


+ (void)uploadRequestConfig:(SSHttpRequestConfig *)requestConfig
             responseBlock:(responseHandler)responseDataBlock
            uploadProgress:(LoadProgress)progress;



@end
