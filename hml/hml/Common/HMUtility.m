//
//  HMUtility.m
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMUtility.h"
#import "BIDObjectToNsDictionary.h"
#import "HMUUIDManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define kHMUserInfoId @"com.hanmo.51art.user.id"
#define kHMUserInfoMobile @"com.hanmo.51art.user.mobile"
#define kHMUserInfoPass @"com.hanmo.51art.user.pass"
#define kHMUserInfoName @"com.hanmo.51art.user.name"
#define kHMUserInfoToken @"com.hanmo.51art.user.token"

@implementation HMUtility

+ (void)readUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger uid = [userDefaults integerForKey:kHMUserInfoId];
    NSString *mobile = [userDefaults stringForKey:kHMUserInfoMobile];
    NSString *name = [userDefaults stringForKey:kHMUserInfoName];
    NSString *pass = [userDefaults stringForKey:kHMUserInfoPass];
    NSString *token = [userDefaults stringForKey:kHMUserInfoToken];
    
    HMGlobalParams *params = [HMGlobalParams sharedInstance];
    params.uid = uid;
    params.mobile = mobile;
    params.name = name;
    params.password = pass;
    params.loginToken = token;
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    params.softVerson = [[infoDict objectForKey:@"CFBundleShortVersionString"]floatValue];
    
    
}

+ (void)writeUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    HMGlobalParams *params = [HMGlobalParams sharedInstance];
    [userDefaults setInteger:params.uid forKey:kHMUserInfoId];
    [userDefaults setObject:params.mobile forKey:kHMUserInfoMobile];
    [userDefaults setObject:params.password forKey:kHMUserInfoPass];
    [userDefaults setObject:params.name forKey:kHMUserInfoName];
    [userDefaults setObject:params.loginToken forKey:kHMUserInfoToken];
    [userDefaults synchronize];
    
}

+ (void)resetUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    HMGlobalParams *params = [HMGlobalParams sharedInstance];
    params.anonymous=YES;
    params.uid = 0;
    params.mobile = nil;
    params.name = nil;
    params.password = nil;
    params.loginToken = @"";
    
    [userDefaults setInteger:params.uid forKey:kHMUserInfoId];
    [userDefaults setObject:params.mobile forKey:kHMUserInfoMobile];
    [userDefaults setObject:params.name forKey:kHMUserInfoName];
    [userDefaults setObject:params.password forKey:kHMUserInfoPass];
    [userDefaults setObject:params.loginToken forKey:kHMUserInfoToken];
    [userDefaults synchronize];
    
}

+ (NSURLSessionTask *)POST:(NSString *)URI
                parameters:(id)parameters
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestSuccess)failure
{
    return [HMUtility POST:URI parameters:parameters cache:false responseCache:nil success:success failure:failure error:nil];
}

+ (NSURLSessionTask *)POST:(NSString *)URI
                parameters:(id)parameters
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestSuccess)failure
                     error:(HttpRequestFailed)error
{
    return [HMUtility POST:URI parameters:parameters cache:false responseCache:nil success:success failure:failure error:error];
}

+ (NSURLSessionTask *)POST:(NSString *)URI
                parameters:(id)parameters
                     cache:(BOOL)cache
             responseCache:(HttpRequestCache)responseCache
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestSuccess)failure
                     error:(HttpRequestFailed)error
{
    NSString *URL = [NSString stringWithFormat:@"%@%@", HM_API_SERVER_URL, URI];
    NSString *cacheKey = URL;
    if (parameters) {
        cacheKey = [URL stringByAppendingString:[PGNetworkHelper convertJsonStringFromDictionaryOrArray:parameters]];
    }
    if (responseCache) {
        responseCache([PGNetworkCache getResponseCacheForKey:cacheKey]);
    }
    AFHTTPSessionManager *manager = [PGNetworkHelper manager];
    [manager.requestSerializer setValue:[HMUUIDManager getUUID] forHTTPHeaderField:@"uuid"];  
    [manager.requestSerializer setValue:@"app" forHTTPHeaderField:@"client"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"fromapp"];
    if(![HMGlobalParams sharedInstance].anonymous){
        [manager.requestSerializer setValue:[HMGlobalParams sharedInstance].loginToken forHTTPHeaderField:@"token"];
    }
    //NSLog(@"---->>uuid:%@",[HMUUIDManager getUUID]);
    
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (cache) {
            [PGNetworkCache saveResponseCache:responseObject forKey:cacheKey];
        }
        if (success) {
            NSLog(@"responseObject0000 = %@", responseObject);
            //NSDictionary *dic = [BIDObjectToNsDictionary getObjectData: responseObject];
            int result = [[responseObject objectForKey:@"result"] intValue];
            HMApiResult *ar = [[HMApiResult alloc] init];
            ar.value = [responseObject objectForKey:@"obj"];
            ar.result = result;
            ar.message = [responseObject objectForKey:@"message"];
            ar.data = [responseObject objectForKey:@"data"];
            
            ar.list = [responseObject objectForKey:@"list"];
            if([responseObject objectForKey:@"totalPage"]){
                ar.totalPage = [[responseObject objectForKey:@"totalPage"] intValue];
                ar.totalCount = [[responseObject objectForKey:@"totalCount"] intValue];
            }
            
            if(result == 1){
                if(success){
                    success(ar);
                }
            }else if(result == 100){
                //跳转登录
            }else{
                if(failure){
                    failure(ar);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull err) {
        if (error) {
            error(err);
        }
    }];
    
}

+(int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to-from + 1)));
    //+1,result is [from to]; else is [from, to)!!!!!!!
}
+(void)showShareActionSheetByText:(NSString *)text images:(NSArray *)imageArray url:(NSURL*)url title:(NSString *)title subtitle:(NSString *)subtitle callBlock:(void (^)(bool)) callBlock
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:imageArray
                                        url:url
                                      title:title
                                       type:SSDKContentTypeAuto];
    // 定制微信朋友圈的分享内容
    [shareParams SSDKSetupWeChatParamsByText:text
                                       title:subtitle
                                         url:url
                                        thumbImage:nil
                                       image:imageArray musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    NSArray *platforms =@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)];
    [ShareSDK showShareActionSheet:nil customItems:platforms shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                callBlock(YES);
                break;
            }
            case SSDKResponseStateFail:
            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                message:[NSString stringWithFormat:@"%@",error]
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil, nil];
//                [alert show];
                callBlock(NO);
                break;
            }
            default:
                break;
        }
    }];
}
@end
