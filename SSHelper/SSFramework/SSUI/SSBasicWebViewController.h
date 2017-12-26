//
//  SSBasicWebViewController.h
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/20.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "SSBasicViewController.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"

@interface SSBasicWebViewController : SSBasicViewController
@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) NSString *webUrl;
@property (strong, nonatomic) NSString *htmlUrl;

@property (copy, nonatomic) void(^backAction)(SSBasicWebViewController *web);

@property (assign, nonatomic) CGFloat toBottomHeight;

@property (copy, nonatomic) void(^webHandler)(NSInteger nativeCode,id data,WVJBResponseCallback responseCallback);

@property (nonatomic, assign) BOOL isAutoChangeTitle;//是否根据网页title变化导航栏的title


- (void)basic_registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler;
- (void)backAction:(void(^)(SSBasicWebViewController *web))block;
- (void)basic_registerDefaultHandler:(void(^)(NSInteger nativeCode,id data,WVJBResponseCallback responseCallback))handler;
- (void)loadWWEB;
- (void)clearWebCacheCompletion:(dispatch_block_t)completion;
@end
