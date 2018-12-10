//
//  HMHomeTableView.h
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"

@protocol HMHomeTableViewDelegate <NSObject>

@required
- (void) downCell:(NSDictionary *)dic;
@end

@interface HMHomeTableView : UIView<JXPagerViewListViewDelegate>
@property (nonatomic, weak) id<HMHomeTableViewDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataSource;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;

@end
