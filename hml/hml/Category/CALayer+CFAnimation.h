//
//  CALayer+CFAnimation.h
//  hml
//
//  Created by 刘学 on 2018/9/13.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (CFAnimation)
//动画
- (void)startAnimationWithKeyPath:(NSString *)keyPath andValues:(NSArray *)values andDuration:(CFTimeInterval)duration;
@end
