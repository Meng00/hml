//
//  HMUUIDManager.h
//  hml
//
//  Created by 刘学 on 2018/9/17.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMUUIDManager : NSObject

+(void)saveUUID:(NSString *)uuid;
+(NSString *)getUUID;
+(void)deleteUUID;

@end
