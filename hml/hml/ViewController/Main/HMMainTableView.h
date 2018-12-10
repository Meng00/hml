//
//  HMMainTableView.h
//  hml
//
//  Created by 刘学 on 2018/10/3.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"

@protocol HMMainTableViewDelegate <NSObject>

@required
- (void) downCell:(NSDictionary *)dic;
@end

@interface HMMainTableView : UIView<JXPagerViewListViewDelegate>
@property (nonatomic, weak) id<HMMainTableViewDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataSource;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
@property (nonatomic, copy) NSString *classifyId;

- (void)query;
@end
