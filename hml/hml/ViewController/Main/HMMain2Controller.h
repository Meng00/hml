//
//  HMMainController.h
//  hml
//
//  Created by 刘学 on 2018/10/3.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
#import "HMMainHeaderView.h"
#import "HMMainTableView.h"

static const CGFloat JXTableHeaderViewHeight = 200;
static const CGFloat JXheightForHeaderInSection = 100;

@interface HMMain2Controller : UIViewController<JXPagerViewDelegate,HMMainTableViewDelegate>

@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) HMMainHeaderView *userHeaderView;
@property (nonatomic, strong) NSArray <HMMainTableView *> *listViewArray;
- (JXPagerView *)preferredPagingView;

@end
