//
//  HMUtility.h
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGNetworkHelper.h"
#import "HMGlobal.h"
#import "HMGlobalParams.h"
#import "HMApiResult.h"

@interface HMUtility : NSObject

+ (void)readUserInfo;
+ (void)writeUserInfo;
+ (void)resetUserInfo;

+ (NSURLSessionTask *)POST:(NSString *)URI
                parameters:(id)parameters
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestSuccess)failure;

+ (NSURLSessionTask *)POST:(NSString *)URI
                parameters:(id)parameters
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestSuccess)failure
                   error:(HttpRequestFailed)error;

/**
 *  POST请求
 *  @param URI          请求地址
 *  @param parameters    请求参数
 *  @param cache         是否缓存数据
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (NSURLSessionTask *)POST:(NSString *)URI
                parameters:(id)parameters
                     cache:(BOOL)cache
             responseCache:(HttpRequestCache)responseCache
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestSuccess)failure
                     error:(HttpRequestFailed)error;


+(int)getRandomNumber:(int)from to:(int)to;

+(void)showShareActionSheetByText:(NSString *)text images:(NSArray *)imageArray url:(NSURL*)url title:(NSString *)title subtitle:(NSString *)subtitle callBlock:(void (^)(bool)) callBlock;

@end
