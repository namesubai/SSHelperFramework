//
//  SSHttpResponse.h
//  SSHelper
//
//  Created by quanminqianbao on 2018/3/16.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, HttpResponse) {
    HttpResponseSuccess  =  -1,//请求成功
    HttpResponseTip,
};
@interface SSHttpResponse : NSObject
+ (void)showTipWithError:(NSError *)error;

@end
