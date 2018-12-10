//
//  HMUUIDManager.m
//  hml
//
//  Created by 刘学 on 2018/9/17.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMUUIDManager.h"
#import "ZZKeyChainManager.h"

@implementation HMUUIDManager

static NSString * const KEY_IN_KEYCHAIN = @"com.zzuuid.uuid";


+(void)saveUUID:(NSString *)uuid{
    if (uuid && uuid.length > 0) {
        [ZZKeyChainManager save:KEY_IN_KEYCHAIN data:uuid];
    }
}

+(NSString *)getUUID{
    NSString *getUDIDInKeychain = (NSString *)[ZZKeyChainManager load:KEY_IN_KEYCHAIN];
    if (!getUDIDInKeychain || [getUDIDInKeychain isEqualToString:@""] || [getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        CFUUIDRef puuid = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString(nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        getUDIDInKeychain = result;
        [ZZKeyChainManager save:KEY_IN_KEYCHAIN data:result];
        getUDIDInKeychain = (NSString *)[ZZKeyChainManager load:KEY_IN_KEYCHAIN];
    }
    return getUDIDInKeychain;
}

+(void)deleteUUID{
    [ZZKeyChainManager deleteUUID:KEY_IN_KEYCHAIN];
}

@end
