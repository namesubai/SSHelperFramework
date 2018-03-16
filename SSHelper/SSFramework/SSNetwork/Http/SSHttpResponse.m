//
//  SSHttpResponse.m
//  SSHelper
//
//  Created by quanminqianbao on 2018/3/16.
//  Copyright © 2018年 yangshuquan. All rights reserved.
//

#import "SSHttpResponse.h"

@implementation SSHttpResponse
+ (void)showTipWithError:(NSError *)error{
    switch (error.code) {
        case NSURLErrorTimedOut:
        {
            NSLog(@"网络请求超时，请检查网络！");
        }
            break;
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorBadURL:
            
        {
            NSLog(@"当前网络不稳定，请检查网络!");
        }
            break;
            
        default:
            NSLog(@"发生错误，请稍后再试！");
            break;
    }
}
@end
