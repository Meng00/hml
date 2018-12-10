//
//  HMMainTableView.m
//  hml
//
//  Created by 刘学 on 2018/10/3.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMMainTableView.h"
#import "HMMainTableViewCell.h"
#import "MJRefresh.h"
#import "HMUtility.h"
#import "YYWebImage.h"

@interface HMMainTableView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

//分页参数
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) NSInteger pageCount;

@end

@implementation HMMainTableView

- (void)dealloc
{
    self.scrollCallback = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        self.tableView.separatorStyle = NO;//cell间隔线条隐藏
        
        self.tableView.tableFooterView = [UIView new];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"HMMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainTableCell"];
//        [self.tableView registerClass:[HMMainTableViewCell class] forCellReuseIdentifier:@"mainTableCell"];
        [self addSubview:self.tableView];
        _dataSource = @[].mutableCopy;
        _pageSize = 3;
        _pageIndex = 0;
    }
    return self;
}

#pragma mark -
#pragma mark query methods
- (void)query
{
    
    NSInteger page = self.pageIndex;
    if(page == 0){
        page = 1;
    }
    __weak typeof(self)weakSelf = self;
    NSDictionary *parame = [[NSMutableDictionary alloc] init];
    [parame setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parame setValue:[NSNumber numberWithInteger:_pageSize] forKey:@"size"];
    if(self.classifyId){
        [parame setValue:@{@"classifyId":[NSNumber numberWithInteger:[weakSelf.classifyId integerValue]]} forKey:@"query"];
    }
    //NSLog(@"=-----------classifyId: %@--------======", self.classifyId);
    [HMUtility POST:HM_API_ArtList parameters:parame success:^(id responseObject) {
        if(self.pageIndex < 2){
            weakSelf.dataSource = [[NSMutableArray alloc] init];
        }
        HMApiResult *ar = responseObject;
        NSArray *array = ar.list;
        if([array count] > 0){
            for (NSDictionary *obj in array) {
                [weakSelf.dataSource addObject:obj];
            }
        }
        weakSelf.pageCount = ar.totalPage;
        if(weakSelf.pageIndex == 0){
            if(weakSelf.pageCount > page && !self.isNeedFooter){
                weakSelf.isNeedFooter = YES;
                weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    weakSelf.pageIndex += 1;
                    [weakSelf query];
                }];
            }
        }else{
            if(weakSelf.pageCount > page){
                [weakSelf.tableView.mj_footer endRefreshing];
                //weakSelf.tableView.mj_footer.hidden = NO;
            }else{
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [weakSelf.tableView reloadData];
        
    } failure: ^(id resObj){
        [weakSelf.tableView.mj_footer endRefreshing];
    } error:^(NSError *err) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview != nil) {
        __weak typeof(self)weakSelf = self;
        if (self.isNeedHeader) {
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                weakSelf.pageIndex = 1;
                [weakSelf query];
                [weakSelf.tableView.mj_header endRefreshing];
            }];
        }
        
        if (self.isNeedFooter) {
            //MJRefreshBackNormalFooter
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                weakSelf.pageIndex += 1;
                [weakSelf query];
            }];
            
        }
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"====------------indexPath.row: %ld----======", indexPath.row);
//    NSString *CellIdentifier = [NSString stringWithFormat:@"mainTableCell%ld%ld", [indexPath section], [indexPath row]];
//    HMMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    HMMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainTableCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMMainTableViewCell" owner:nil options:nil] firstObject];
        //[tableView registerNib:[UINib nibWithNibName:@"HMMainTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
//        cell = [[HMMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    
    //    HMMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainTableCell" forIndexPath:indexPath];
    //cell.textLabel.text = self.dataSource[indexPath.row];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.contentView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    cell.name.text = [dic objectForKey:@"name"];
    cell.price.text = [NSString stringWithFormat:@"￥ %@", [dic objectForKey:@"selling_Price"]];
    cell.time.text = [NSString stringWithFormat:@"时间：%@", [dic objectForKey:@"createDate"]];
    cell.imgView.yy_imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HM_IMGSRV_PREFIX, [dic objectForKey:@"image"]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.row];
    [self.delegate downCell:dic];
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView{
    return self;
}
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

@end
