//
//  AppDelegate.m
//  hml
//
//  Created by 刘学 on 2018/9/12.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "AppDelegate.h"
#import "HMUtility.h"
#import "MainController.h"
#import <ShareSDK/ShareSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
//#import <ShareSDKConnector/ShareSDKConnector.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    //初始化window
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
//
//    [self.window makeKeyAndVisible];
////
//    //根控制器
//    UINavigationController *nav = [[UINavigationController alloc] init];
//    self.window.rootViewController = nav;
//
//    MainController *main = [[MainController alloc] init];
    [HMUtility readUserInfo];
    [self autoLogin];
    
    //修改app默认UA
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    //NSLog(@"------%@",userAgent);
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *ua = [NSString stringWithFormat:@"%@ hmqq_app_ios %@/%@ ", userAgent, executableFile,version];
    //NSLog(@"------%@",ua);
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
    
    //微信初始化
    [WXApi registerApp:@"wxfaadbcf0bb9fcff5" enableMTA:YES];
    
    /**初始化ShareSDK应用 */
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //微信
        [platformsRegister setupWeChatWithAppId:@"wxfaadbcf0bb9fcff5" appSecret:@"787bb25cf46a8f52cee17718dfa5d2f6"];
        
    }];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"result = %@",resultDic);
        }];
    }
    
//    return [WXApi handleOpenURL:url delegate:self];
    return YES;
}

#pragma mark -
#pragma mark auto login
- (void)autoLogin
{
    HMGlobalParams *params = [HMGlobalParams sharedInstance];
    params.anonymous = YES;
    if (params.mobile && params.password) {
        [HMUtility POST:HM_API_Login parameters:@{@"username":params.mobile,@"password":params.password}  success:^(id responseObject) {
            //NSLog(@"responseObject = %@", responseObject);
            HMApiResult *ar = responseObject;
            
            HMGlobalParams *params = [HMGlobalParams sharedInstance];
            params.anonymous = NO;
            params.uid = [[ar.data objectForKey:@"id"] integerValue];//后台 没有返回id
            params.loginToken = [ar.data objectForKey:@"token"];
            params.name = [ar.data objectForKey:@"real_name"];
            
            //数据存到手机上
            [HMUtility writeUserInfo];
        } failure:^(NSError *error) {
            NSLog(@"error = %@", error);
        } error:nil];
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];

        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;

            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else {
    }
}

- (void)onReq:(BaseReq *)req {

}


@end
