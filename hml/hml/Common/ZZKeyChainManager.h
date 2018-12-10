//
//  ZZKeyChainManager.h
//  hml
//
//  Created by 刘学 on 2018/9/17.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZKeyChainManager : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteUUID:(NSString *)service;
@end
