//
//  CALayer+CFAnimation.m
//  hml
//
//  Created by 刘学 on 2018/9/13.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "CALayer+CFAnimation.h"

@implementation CALayer (CFAnimation)

- (void)startAnimationWithKeyPath:(NSString *)keyPath andValues:(NSArray *)values andDuration:(CFTimeInterval)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = keyPath;
    animation.values = values;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.calculationMode = kCAAnimationCubic;
    animation.fillMode = kCAFillModeForwards;
    [self addAnimation:animation forKey:nil];
}


@end
