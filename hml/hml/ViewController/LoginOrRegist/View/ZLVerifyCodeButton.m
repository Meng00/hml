//
//  ZLVerifyCodeButton.m
//  hml
//
//  Created by 刘学 on 2018/9/17.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "ZLVerifyCodeButton.h"

@interface ZLVerifyCodeButton ()

@property(nonatomic, assign) NSInteger count;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation ZLVerifyCodeButton

- (void)setup {
    
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3.0;
    self.clipsToBounds = YES;
    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //self.layer.borderColor = [UIColor redColor].CGColor;
    //self.layer.borderWidth = 0.5;
}

- (void)timeFailBeginFrom:(NSInteger)timeCount {
    
    self.count = timeCount;
    self.enabled = NO;
    
    // 加1个计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired {
    if (self.count != 1) {
        self.count -= 1;
        self.enabled = NO;
        [self setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateNormal];
        //       [self setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateDisabled];
    } else {
        
        self.enabled = YES;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        //self.count = 60;
        
        // 停掉定时器
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
