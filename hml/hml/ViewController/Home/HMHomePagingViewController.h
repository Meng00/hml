//
//  HMHomePagingViewController.h
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "HMHomePagingViewTableHeaderView.h"
#import "HMHomeTableView.h"

static const CGFloat JXTableHeaderViewHeight = 200;
static const CGFloat JXheightForHeaderInSection = 50;

@interface HMHomePagingViewController : UIViewController<JXPagerViewDelegate>

@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) HMHomePagingViewTableHeaderView *userHeaderView;
@property (nonatomic, strong) NSArray <HMHomeTableView *> *listViewArray;
- (JXPagerView *)preferredPagingView;

@end
