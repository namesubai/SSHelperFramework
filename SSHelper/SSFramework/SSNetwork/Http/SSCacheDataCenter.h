//
//  Created by quanminqianbao on 2018/3/12.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSCacheBaseData.h"



@interface SSCacheDataCenter : NSObject


+ (instancetype)sharedManager;
- (NSString *)md5StringFromString:(NSString *)string;
//保存网络缓存到指定的文件夹
- (void)saveHttpCacheData:(NSData *)cacheData  cachePath:(NSString *)cachePath;
//网络读取缓存
- (void)getHttpCacheDataFromCachePath:(NSString *)cachePath success:(void(^)(NSData *cacheData))success;
//读取基本缓存配置信息
- (SSCacheBaseData *)loadBaseCachePath:(NSString *)cachePath;
@end
