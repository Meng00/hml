//
//  UIColor+CFColor.h
//  hml
//
//  Created by 刘学 on 2018/9/12.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CFColor)

//根据颜色值获取颜色
+ (UIColor *)colorOfHex:(int)value;

@end
