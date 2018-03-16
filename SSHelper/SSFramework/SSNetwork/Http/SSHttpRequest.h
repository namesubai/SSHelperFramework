
//
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSHttpRequestConfig.h"
#import "SSHttpResponse.h"




@interface SSHttpRequest : NSObject

typedef void (^ResponseResult)(NSDictionary *resuestDict,SSHttpRequestConfig *requestConfig,NSError *error,BOOL isCacheData);
typedef void (^LoadProgress)(NSProgress *uploadProgress);

+ (instancetype)sharedManager;

- (void)requestWithConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult;
- (void)upLoadWithConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress;
- (void)downLoadWithConfig:(SSHttpRequestConfig *)requestConfig responseResult:(ResponseResult)responseResult progress:(LoadProgress)progress;
@end
