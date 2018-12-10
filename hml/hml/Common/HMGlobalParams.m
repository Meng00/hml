//
//  HMGlobalParams.m
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMGlobalParams.h"

static HMGlobalParams *single;

@implementation HMGlobalParams

+ (HMGlobalParams *)sharedInstance
{
    if (single == nil) {
        single = [[super allocWithZone:nil] init];
        single.anonymous = YES;
        
    }
    
    return single;
    
}

+ (id)alloc
{
    return nil;
}

+ (id)new
{
    return [self alloc];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self alloc];
}


@end
