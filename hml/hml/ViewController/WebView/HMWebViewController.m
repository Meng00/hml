//
//  HMWebViewController.m
//  hml
//
//  Created by 刘学 on 2018/9/21.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMWebViewController.h"
#import "XMWebView.h"
#import "LCLoginOrRegistVC.h"

@interface HMWebViewController ()<XMWebViewDelegate,LCLoginOrRegistVCDelegate>

@property (nonatomic, strong) XMWebView *webView;
@property (nonatomic, copy) NSString *urlStr;

@end

@implementation HMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[XMWebView alloc] initWithFrame:self.view.bounds viewType:WebViewTypeWkWebView];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    //此处链接要写全
    self.urlStr = @"https://www.baidu.com";
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


#pragma maek - 子类重写
- (void)webViewDidStartLoad:(XMWebView *)webview {
    
}

- (void)webView:(XMWebView *)webview shouldStartLoadWithURL:(NSURL *)URL {
    NSString *requestString = [URL absoluteString];
    requestString= [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(!requestString){
        requestString = [URL absoluteString];
        [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    //NSLog(@"===%@",requestString);
    //js与原生交互(原生捕捉js事件)
    //捕捉事件:goback:// 是js里的方法名:location.href="goback://";
    if ([requestString hasPrefix:@"hml://Login"]) {
        //登录
        LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([requestString hasPrefix:@"hml://Regist"]) {
        //登录
        LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
        vc.delegate = self;
        vc.type=1;
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([requestString hasPrefix:@"hml://HMMain"]) {
        //首页
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else if ([requestString hasPrefix:@"hml://HMPass"]) {
        //忘记密码
        
    }
    
}
- (void)webView:(XMWebView *)webview didFinishLoadingURL:(NSURL *)URL {
    
}
- (void)webView:(XMWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error {
    NSLog(@"error=%@",error);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
