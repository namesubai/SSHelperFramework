//
//  HttpRequest.h
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/17.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestConfig.h"

typedef void (^ResponseResult)(NSDictionary *resuestDict,NSError *error,BOOL isCacheData);
typedef void (^LoadProgress)(NSProgress *uploadProgress);

@interface HttpRequest : NSObject

+ (instancetype)sharedManager;

- (void)requestWithConfig:(HttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult;
- (void)upLoadWithConfig:(HttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress;
- (void)downLoadWithConfig:(HttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress;

@end
