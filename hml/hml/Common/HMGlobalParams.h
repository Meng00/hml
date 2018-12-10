//
//  HMGlobalParams.h
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGlobalParams : NSObject

@property (nonatomic)BOOL anonymous;
@property (nonatomic)NSInteger uid;
@property (copy, nonatomic)NSString *mobile;
@property (copy, nonatomic)NSString *password;
@property (copy, nonatomic)NSString *name;
@property (copy, nonatomic)NSString *loginToken;

//微信unionid
@property (copy, nonatomic)NSString *unionid;
@property (copy, nonatomic)NSString *openid;

@property (nonatomic)float softVerson;

/*!
 @method
 @abstract 单实例对象
 */
+ (HMGlobalParams *)sharedInstance;

@end
