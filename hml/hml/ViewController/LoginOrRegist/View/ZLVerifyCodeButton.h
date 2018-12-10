//
//  ZLVerifyCodeButton.h
//  hml
//
//  Created by 刘学 on 2018/9/17.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLVerifyCodeButton : UIButton
- (void)setup;
// 由于有些时间需求不同，特意露出方法，倒计时时间次数
- (void)timeFailBeginFrom:(NSInteger)timeCount;
@end
