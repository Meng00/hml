//
//  HMViewController.m
//  hmArt
//
//  Created by 刘学 on 2018/1/13.
//  Copyright © 2018年 hanmoqianqiu. All rights reserved.
//

#import "HMViewController.h"
#import <WebKit/WebKit.h>
#import "LCLoginOrRegistVC.h"
#import "HMUserPwdController.h"
#import "NSArray+HJImages.h"
#import "HMUUIDManager.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface HMViewController () <WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate,LCLoginOrRegistVCDelegate>
{
    NSString *_loginOrRegCallback;
}

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UIBarButtonItem *leftBarButton;
@property (nonatomic,strong) UIBarButtonItem *leftBarButtonSecond;
@property (nonatomic,strong) UIBarButtonItem *negativeSpacer;
@property (nonatomic,strong) UIBarButtonItem *negativeSpacer2;
@property (nonatomic) BOOL refresh;

@end

@implementation HMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden=YES;
    /** 设置背景 */
    self.bgImageView.animationImages = [NSArray hj_imagesWithLocalGif:@"bg_webview" expectSize:self.bgImageView.bounds.size];
    
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    [self LoadRequest];
    self.refresh = NO;
    [self addObserver];
    [self setBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if(@available(iOS 11.0, *)){
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBarHidden = YES;
    
    if(self.refresh){
        [self.webView reload];
    }else{
        
    }
    self.refresh = NO;
    
    
}

#pragma mark 加载网页
- (void)LoadRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    //[request addValue:[self getCookieValue] forHTTPHeaderField:@"Cookie"];
    //TODO:加载
    [self.webView loadRequest:request];
}
#pragma mark 添加KVO观察者
- (void)addObserver
{
    //TODO:kvo监听，获得页面title和加载进度值，以及是否可以返回
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark 设置BarButtonItem
- (void)setBarButtonItem
{
    
    //设置距离左边屏幕的宽度距离
    self.leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_item.png"] style:UIBarButtonItemStylePlain target:self action:@selector(selectedToBack)];
    self.negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    self.negativeSpacer.width = -5;
    
    //设置关闭按钮，以及关闭按钮和返回按钮之间的距离
    self.leftBarButtonSecond = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close_item"] style:UIBarButtonItemStylePlain target:self action:@selector(selectedToClose)];
    self.leftBarButtonSecond.imageInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    self.navigationItem.leftBarButtonItems = @[self.negativeSpacer,self.leftBarButton];
    
    
    //设置刷新按妞
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reload_item"] style:UIBarButtonItemStylePlain target:self action:@selector(selectedToReloadData)];
    self.navigationItem.rightBarButtonItem = reloadItem;
    
}
#pragma mark 关闭并返回上一界面
- (void)selectedToClose
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 返回上一个网页还是上一个Controller
- (void)selectedToBack
{
    if (self.webView.canGoBack == 1)
    {
        [self.webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark reload
- (void)selectedToReloadData
{
    [self.webView reload];
}

#pragma mark - lazy
-(WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        // web内容处理池
        config.processPool = [[WKProcessPool alloc] init];
        
        // 通过JS与webview内容交互
//        config.userContentController = [[WKUserContentController alloc] init];
        // 将所有cookie以document.cookie = 'key=value';形式进行拼接
        NSString *cookieValue = [NSString stringWithFormat:@"document.cookie = 'fromapp=ios';document.cookie = 'client=app';document.cookie = 'uuid=%@';document.cookie = 'ran=%d';document.cookie = 'token=%@';", [HMUUIDManager getUUID], [HMUtility getRandomNumber:0 to:10000],[HMGlobalParams sharedInstance].loginToken];
        //NSLog(@"cookieValue: %@",cookieValue);
        WKUserContentController* userContentController = WKUserContentController.new;
        WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: cookieValue injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        [userContentController addUserScript:cookieScript];
        config.userContentController = userContentController;
        
        // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
        // 我们可以在WKScriptMessageHandler代理中接收到
        [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-22) configuration:config];
        
        // 设置代理
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}


- (NSMutableString*)getCookieValue{
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    [cookieDic setObject:[HMUUIDManager getUUID] forKey:@"uuid"];
    [cookieDic setObject:@"app" forKey:@"client"];
    [cookieDic setObject:@"ios22" forKey:@"fromapp"];
    [cookieDic setObject:[HMGlobalParams sharedInstance].loginToken forKey:@"token"];
    
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    //NSLog(@"cookieValue: %@",cookieValue);
    return cookieValue;
}


-(UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        [_progressView setFrame:CGRectMake(0, 21, self.view.frame.size.width, 1)];
        
        //设置进度条颜色
        [_progressView setTintColor:[UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
        //_progressView.hidden = YES;
    }
    return _progressView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == self.webView)
        {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            if(self.webView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:1.5f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progressView setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progressView setProgress:0.0f animated:NO];
                                 }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView)
        {
            //self.navigationItem.title = self.webView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //是否可以返回
    else if ([keyPath isEqualToString:@"canGoBack"])
    {
        if (object == self.webView)
        {
            if (self.webView.canGoBack == 1)
            {
                self.navigationItem.leftBarButtonItems = @[self.negativeSpacer,self.leftBarButton,self.leftBarButtonSecond];
            }
            else
            {
                self.navigationItem.leftBarButtonItems = @[self.negativeSpacer,self.leftBarButton];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //NSLog(@"页面开始加载");
    [self.bgImageView startAnimating];
    
    
}
// 加载完成
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //NSLog(@"加载完成");
   
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //NSLog(@"当内容开始返回时调用");
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"document.cookie = 'token=%@';", [HMGlobalParams sharedInstance].loginToken] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
    }];
}
// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    //NSLog(@"页面加载超时");
    [self selectedToBack];
}
//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    //NSLog(@"跳转失败");
    [self selectedToBack];
}
//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //NSLog(@"在发送请求之前，决定是否跳转");
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    //NSLog(@"url: %@", [url absoluteString]);
    if ([scheme isEqualToString:@"appaction"]) {
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([scheme isEqualToString:@"hml"]) {
        [self handleCustomAction:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - private method
- (void)handleCustomAction:(NSURL *)url
{
    NSString *host = [url host];
//    NSLog(@"Host: %@", [url host]);
//    NSLog(@"Port: %@", [url port]);
//    NSLog(@"Path: %@", [url path]);
//    NSLog(@"Relative path: %@", [url relativePath]);
//    NSLog(@"Query: %@", [url query]);
    if ([host isEqualToString:@"Login"]) {
        //登录
        LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([host isEqualToString:@"Regist"]) {
        //注册
        LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
        vc.delegate = self;
        vc.type=1;
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([host isEqualToString:@"HMMain"]) {
        //首页
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else if ([host isEqualToString:@"HMPass"]) {
        //修改密码
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdatePwd"] animated:YES];
    }
    
}

#pragma mark - WKScriptMessageHandler
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"AppModel"]) {
        NSLog(@"%@",message.body);
        NSString *method = [message.body objectForKey:@"method"];
        if([method isEqualToString:@"close"]){
            //关闭
            [self selectedToClose];
            
        }else if([method isEqualToString:@"goBack"]){
            //返回
            [self selectedToBack];
            
        }else if([method isEqualToString:@"refresh"]){
            //开启回退刷新页面
            self.refresh = YES;
        }else if([method isEqualToString:@"toLogin"]){
            _loginOrRegCallback = [message.body objectForKey:@"callback"];
            //登录
            LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }else if([method isEqualToString:@"toRegist"]){
            _loginOrRegCallback = [message.body objectForKey:@"callback"];
            //登录
            LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
            vc.delegate = self;
            vc.type=1;
            [self presentViewController:vc animated:YES completion:nil];
        }else if([method isEqualToString:@"signout"]){
            //退出登录
            [HMUtility resetUserInfo];
            NSString *callback = [message.body objectForKey:@"callback"];
            [self.webView evaluateJavaScript:[NSString stringWithFormat:@"%@('%i')", callback, 1] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            }];
            //首页
            //[self.navigationController popToRootViewControllerAnimated:NO];
        }else if([method isEqualToString:@"logout"]){
            //已退出登录
            [HMUtility resetUserInfo];
            NSString *msg = [message.body objectForKey:@"message"];
            _loginOrRegCallback = [message.body objectForKey:@"callback"];
            [self.webView evaluateJavaScript:[NSString stringWithFormat:@"document.cookie = 'token=%@';", [HMGlobalParams sharedInstance].loginToken] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            }];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"立即登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
                vc.delegate = self;
                [self presentViewController:vc animated:YES completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else if([method isEqualToString:@"share"]){
            NSString *image = [message.body objectForKey:@"image"];
            NSString *title = [message.body objectForKey:@"title"];
            NSString *subtitle = [message.body objectForKey:@"subtitle"];
            NSString *text = [message.body objectForKey:@"text"];
            NSString *url = [message.body objectForKey:@"url"];
            NSString *callback = [message.body objectForKey:@"callback"];
            
            NSArray* imageArray = @[image];
            [HMUtility showShareActionSheetByText:text
                    images:imageArray
                    url:[NSURL URLWithString:url]
                    title:title
                    subtitle:subtitle
                    callBlock:^(bool b){
                        if(b){
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"分享成功" preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                if(callback){
                                    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"%@('%i')", callback, 1] completionHandler:nil];
                                }
                            }]];
                            [self presentViewController:alert animated:YES completion:nil];
                        }else{
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"分享失败" preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                if(callback){
                                    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"%@('%i')", callback, 0] completionHandler:nil];
                                }
                            }]];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
            }];
        }else if([method isEqualToString:@"appPay"]){
            int payType = [[message.body objectForKey:@"payType"] intValue];
            
            if(payType == 1){
                NSString *data = [message.body objectForKey:@"data"];
                [[AlipaySDK defaultService] payOrder:data fromScheme:@"hmlAlipayNotify" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }else if(payType == 3){
                NSDictionary *dict = [message.body objectForKey:@"data"];
                
                //调起微信支付
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
            }
            
            
        }
    }
}

#pragma mark 移除观察者
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"AppModel"];
    [self.bgImageView stopAnimating];
}

#pragma mark --- LCLoginOrRegistVCDelegate
- (void) LCLoginOrRegistVC:(NSInteger )tag
{
    //登录成功处理 通知页面
    if(_loginOrRegCallback){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.webView evaluateJavaScript:[NSString stringWithFormat:@"%@('%@')", _loginOrRegCallback, [HMGlobalParams sharedInstance].loginToken] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            }];
        });
    }
}


@end
