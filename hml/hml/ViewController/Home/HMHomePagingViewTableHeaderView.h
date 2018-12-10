//
//  HMHomePagingViewTableHeaderView.h
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHomePagingViewTableHeaderView : UIView

@property (nonatomic, strong) UIView *billboadrView;
- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;
@end
