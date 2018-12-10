//
//  HMTextChecker.m
//  hmArt
//
//  Created by wangyong on 13-7-9.
//  Copyright (c) 2013年 hanmoqianqiu. All rights reserved.
//

#import "HMTextChecker.h"
#import "HMUtility.h"

@implementation HMTextChecker

+ (BOOL)checkEmail:(NSString *)txt
{
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:txt];
}

+ (BOOL)checkIsEmpty:(NSString *)txt
{
    if (txt && txt.length > 0) return NO;
    else return YES;
}

+ (BOOL)checkLength:(NSString *)txt min:(NSUInteger)min max:(NSUInteger)max
{
    if (!txt) {
        return min == 0;
    }
    
    NSUInteger len = txt.length;
    return (len >= min && len <= max);
}

+ (BOOL)checkIsNumber:(NSString *)txt
{
    NSString *regex = @"^[0-9]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:txt];
}

+ (BOOL)checkIsNumber:(NSString *)txt withLength:(NSUInteger)len
{
    NSString *regex = [NSString stringWithFormat:@"^[0-9]{%lu}$", (unsigned long)len];
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:txt];
}

+ (BOOL)checkIsMobile:(NSString *)txt
{
    NSString *regex = @"^[1][3-8]+\\d{9}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:txt];
}

+ (BOOL)checkIsCardID:(NSString *)txt
{
    NSString *regex = @"(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:txt];
}

@end
