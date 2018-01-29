//
//  SSBasicWebViewController.m
//  qmwalle
//
//  Created by quanminqianbao on 2017/11/20.
//  Copyright © 2017年 www.qmwalle.com. All rights reserved.
//

#import "SSBasicWebViewController.h"
#import "Masonry.h"
#import "SSHelperDefine.h"
#import "Categorise.h"
#import "SSCookiesManager.h"


@interface SSBasicWebViewController () <WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

{
    WebViewJavascriptBridge* bridge;
}

@property (strong, nonatomic) UIView *progress;
@property (strong, nonatomic) CALayer *layer;
@property (strong, nonatomic) UIButton *reLoadButton;

@property (strong, nonatomic) UIButton *close_button;
@property (strong, nonatomic) WKNavigation *gobackNavigation;

@end

@implementation SSBasicWebViewController

- (void)dealloc{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView removeObserver:self forKeyPath:@"title"];
}


- (BOOL)navigationShouldPopOnBackButton{
    if (self.wkWebView.canGoBack) {
         self.gobackNavigation = [self.wkWebView goBack];
        return NO;
        
    }else{
        if (self.backAction) {
            self.backAction(self);
        }
        return YES;
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setleftButtons];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;


    self.isAutoChangeTitle = YES;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 9.0;
    
    if ([config respondsToSelector:@selector(setAllowsInlineMediaPlayback:)]) {
        [config setAllowsInlineMediaPlayback:YES];
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        if ([config respondsToSelector:@selector(setApplicationNameForUserAgent:)]) {
            [config setApplicationNameForUserAgent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        }
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0 && [config respondsToSelector:@selector(setMediaTypesRequiringUserActionForPlayback:)]) {
        [config setMediaTypesRequiringUserActionForPlayback:WKAudiovisualMediaTypeNone];
    } else if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0 && [config respondsToSelector:@selector(setRequiresUserActionForMediaPlayback:)]) {
        [config setRequiresUserActionForMediaPlayback:NO];
    } else if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0 && [config respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]) {
        [config setMediaPlaybackRequiresUserAction:NO];
    }
    
    //通过 document.cookie 设置 Cookie 解决后续页面(同域)Ajax、iframe 请求的 Cookie 问题；
    //取出 storage 中的cookie并将其拼接成正确的形式
    NSArray<NSHTTPCookie *> *tmp = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSMutableString *jscode_Cookie = [@"" mutableCopy];
    [tmp enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@=%@", obj.name, obj.value);
        [jscode_Cookie appendString:[NSString stringWithFormat:@"document.cookie='%@=%@';", obj.name, obj.value]];
    }];
    
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: jscode_Cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    
    [userContentController addUserScript:cookieScript];
    WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
    webViewConfig.userContentController = userContentController;
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    [_wkWebView sizeToFit];
    _wkWebView.navigationDelegate = self;
    [self.view addSubview:_wkWebView];
    _wkWebView.scrollView.contentInset = UIEdgeInsetsMake(self.navHeight, 0, 49, 0);
    //史诗级神坑，为何如此写呢？参考https://opensource.apple.com/source/WebKit2/WebKit2-7600.1.4.11.10/ChangeLog
    [_wkWebView setValue:[NSValue valueWithUIEdgeInsets:self.wkWebView.scrollView.contentInset] forKey:@"_obscuredInsets"]; //kvc给WKWebView的私有变量_obscuredInsets设置值
    
  
    
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(self.navHeight,0, _toBottomHeight, 0));
    }];
    
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self setprogressView];
   
    [self loadWWEB];

    
    _reLoadButton = [UIButton returnButtonFram:CGRectZero
                                          type:UIButtonTypeCustom
                                         title:@"加载失败，请点击重新加载"
                                    titleColor:Color_Text_Detail
                                  cornerRadius:0
                                      textFont:[UIFont systemFontOfSize:15]
                                backgroudColor:nil];
    [self.view addSubview:_reLoadButton];
    
    [_reLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    [_reLoadButton setHidden:YES];
   
 
    [WebViewJavascriptBridge enableLogging];
    bridge = [WebViewJavascriptBridge bridgeForWebView:_wkWebView];
    [bridge setWebViewDelegate:self];
    [bridge registerHandler:@"gotoLoginIos" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //返回给服务器
       // responseCallback();
        
    }];
    
    // Do any additional setup after loading the view.
}


- (void)setleftButtons{
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTitleColor:Color_Text_Standard forState:UIControlStateNormal];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton sizeToFit];
    self.close_button = closeButton;
    [self.close_button setHidden:YES];
    UIBarButtonItem *buttonitem1 = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    @weakify(self);
    [closeButton buttonClick:^(UIButton *button) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];

    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItems = @[buttonitem1];
    
}




- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear: animated];
}


- (void)setprogressView{
    UIView *progress = [[UIView alloc]initWithFrame:CGRectZero];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    [self.view bringSubviewToFront:progress];
    [progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.navHeight));
        make.left.right.equalTo(@0);
        make.height.equalTo(@3);
    }];
    self.progress = progress;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = Color_Blue.CGColor;
    [progress.layer addSublayer:layer];
    self.layer = layer;
    
}

//- (WKWebView *)wkWebView{
//    if (_wkWebView) {
//        return _wkWebView;
//    }
//
//    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero];
//    _wkWebView.navigationDelegate = self;
//
//    [self.view addSubview:_wkWebView];
//
//    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(64,0, _toBottomHeight, 0));
//    }];
//
//
//    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//    [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
//
//    [self setprogressView];
//    return _wkWebView;
//}


- (void)basic_registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler{
//    [WebViewJavascriptBridge enableLogging];
//    bridge = [WebViewJavascriptBridge bridgeForWebView:self.wkWebView];
//    [bridge setWebViewDelegate:self];
    
    [bridge registerHandler:handlerName handler:^(id data, WVJBResponseCallback responseCallback) {
        //        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
        if (handler) {
            handler(data,responseCallback);
        }
    }];
    
    [bridge callHandler:handlerName data:@{ @"foo":@"before ready" }];
    
    
    
}

- (void)basic_registerDefaultHandler:(void (^)(NSInteger, id, WVJBResponseCallback))handler{
//    [WebViewJavascriptBridge enableLogging];
//    bridge = [WebViewJavascriptBridge bridgeForWebView:self.wkWebView];
//    [bridge setWebViewDelegate:self];
    
    [bridge registerHandler:@"callNativeApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        //        responseCallback(@"Response from testObjcCallback");
        if (handler) {
            handler([data[@"nativeCode"] integerValue],data,responseCallback);
        }
        
    }];
    
    
}

- (void)basic_callHandlerbasic_registerDefaultHandlerWithData:(id)data{
    [bridge callHandler:@"pleaseCallMe" data:data];
}



//
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    //解决内存过高问题
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"%@,%@",message.name,message.body);
    
}






//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [_reLoadButton setHidden:YES];
//    [_wkWebView setHidden:NO];
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [_reLoadButton setHidden:NO];
//    [_wkWebView setHidden:YES];
//
//}


- (void)loadWWEB{
    if (_webUrl.length) {
        NSLog(@"%@",_webUrl);
        

        if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) {
            //清楚缓存
            NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                
            }];
            
        }
        
        NSString *urlStr =[_webUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`%^{}\"[]|\\<> "].invertedSet];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        
        NSString *value = [[SSCookiesManager sharedInstance] getRequestCookieHeaderForURL:[NSURL URLWithString:urlStr]];
        [request setValue:value forHTTPHeaderField:@"Cookie"];
        
//        //解决首次加载Cookie带不上问题
//        NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
//        //Cookies数组转换为requestHeaderFields
//        NSDictionary *requestHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//        //设置请求头
//        request.allHTTPHeaderFields = requestHeaderFields;
        
        [self.wkWebView loadRequest:request];
        
        
    }
    
    if (_htmlUrl.length) {
        
        
        [self.wkWebView loadHTMLString:_htmlUrl baseURL:nil];
        
        
    }
    
    
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.layer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.layer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.layer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.layer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else if([keyPath isEqualToString:@"title"]){
        if (object == self.wkWebView) {
            if (self.isAutoChangeTitle) {
                self.title = self.wkWebView.title;
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    
    
    if (_wkWebView.canGoBack&&self.navigationController.viewControllers.count>1) {
        [self.close_button setHidden:NO];
        
        
    }else{
        [self.close_button setHidden:YES];
        
    }
    
    //    if (self.navigationController.viewControllers.count>1) {
    //        [self.back_button setHidden:NO];
    //    }else{
    //        if (_wkWebView.canGoBack) {
    //            [self.back_button setHidden:NO];
    //
    //        }else{
    //            [self.back_button setHidden:YES];
    //
    //        }
    //
    //    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [_reLoadButton setHidden:YES];
    [_wkWebView setHidden:NO];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [_reLoadButton setHidden:NO];
    [_wkWebView setHidden:YES];
    
    if (webView.canGoBack&&self.navigationController.viewControllers.count>1) {
        [self.close_button setHidden:NO];
        
    }else{
        [self.close_button setHidden:YES];
    }
    
    //    if (self.navigationController.viewControllers.count>1) {
    //        [self.back_button setHidden:NO];
    //    }else{
    //        if (webView.canGoBack) {
    //            [self.back_button setHidden:NO];
    //
    //        }else{
    //            [self.back_button setHidden:YES];
    //
    //        }
    //
    //    }
    
    
    
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
  
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    if ([self.gobackNavigation isEqual:navigation]) {
        
        // 这次的加载是点击返回产生的，刷新
        [webView reload];
        self.gobackNavigation = nil;
    }
    
    if (webView.canGoBack&&self.navigationController.viewControllers.count>1) {
        [self.close_button setHidden:NO];
        
    }else{
        [self.close_button setHidden:YES];
        
    }
    
    //    if (self.navigationController.viewControllers.count>1) {
    //        [self.back_button setHidden:NO];
    //    }else{
    //        if (webView.canGoBack) {
    //            [self.back_button setHidden:NO];
    //
    //        }else{
    //            [self.back_button setHidden:YES];
    //
    //        }
    //
    //    }
    
}
//js alert方法不弹窗
//之前提过WKUIDelegate所有的方法都是Optional，但如果你不实现，它就会
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
}

//当WKWebView加载的网页占用内存过大时，会出现白屏现象
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];   //刷新就好了
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    //  在发送请求之前，决定是否跳转
//
//    NSLog(@"%@",[webView.URL absoluteString]);
//    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[webView.URL absoluteString]];
//    if (orderInfo.length > 0) {
//        // 调用支付接口进行支付
//        [[AlipaySDK defaultService]payUrlOrder:orderInfo fromScheme:@"alisdkdemo" callback:^(NSDictionary* result) {
//            // 处理返回结果
//            NSString* resultCode = result[@"resultCode"];
//            //建议操作: 根据resultCode做处理
//
//            // returnUrl 代表 第三方App需要跳转的成功页URL
//            NSString* returnUrl = result[@"returnUrl"];
//            //建议操作: 打开returnUrl
//        }];
//
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }
//
//
//    decisionHandler(WKNavigationActionPolicyAllow);
//}


//- (void)setWebUrl:(NSString *)webUrl{
//    _webUrl = webUrl;
//    [self loadWWEB];
//
//}
//
//- (void)setHtmlUrl:(NSString *)htmlUrl{
//    _htmlUrl = htmlUrl;
//    [self loadWWEB];
//}

- (void)setToBottomHeight:(CGFloat)toBottomHeight{
    _toBottomHeight = toBottomHeight;
}
- (void)backAction:(void (^)(SSBasicWebViewController *))block{
    self.backAction = block;
}



- (void)clearWebCacheCompletion:(dispatch_block_t)completion {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:completion];
    } else {
        NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        
        NSError *error;
        /* iOS8.0 WebView Cache path */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        
        if (completion) {
            completion();
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
