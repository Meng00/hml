//
//  HMHomePageViewController.m
//  hml
//
//  Created by 刘学 on 2018/10/13.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMHomePageViewController.h"
#import "KHAdView.h"
#import "HMUtility.h"
#import "YYWebImage.h"
#import "HMViewController.h"
#import "UIView+MJExtension.h"
#import "MJRefresh.h"
#import "HMMainTableViewCell.h"
#import "KNBillboadrView.h"

@interface HMHomePageViewController ()<KNBillboadrViewDelegate>

@property(nonatomic, retain) UITableView *tableView;

@property (nonatomic, strong) UIView *userHeaderView;
@property (nonatomic, strong) KNBillboadrView *billboadrView;
@property (nonatomic, strong) KHAdView *adView;
@property (nonatomic, strong) UIScrollView *scrollView;


@property(nonatomic,copy) NSArray *classifyArray;
@property(nonatomic,copy) NSDictionary *fengxiangDic;


//分页参数
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataSource;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) NSInteger pageCount;

@end

static const CGFloat TableHeaderViewHeight = 150;
static const CGFloat ForHeaderInSection = 100;

@implementation HMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"甘肃文交中心翰墨链销售平台";
    
    self.navigationController.navigationBar.translucent = NO;
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
//    _adView = [[KHAdView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TableHeaderViewHeight)];
//    _adView.backgroundColor = [UIColor whiteColor];
//    _tableView.tableHeaderView = _adView;
    
    _userHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TableHeaderViewHeight)];
    _userHeaderView.backgroundColor = [UIColor whiteColor];
//    UIImageView *imageView=[[UIImageView alloc]initWithFrame:_userHeaderView.bounds]; imageView.image=[UIImage imageNamed:@"ad2"];
//    [_userHeaderView insertSubview:imageView atIndex:0];
    
    _tableView.tableHeaderView = _userHeaderView;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, ForHeaderInSection)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    // 隐藏水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    //_tableView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = NO;//cell间隔线条隐藏
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HMMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainTableCell"];
    
    _dataSource = @[].mutableCopy;
    _pageSize = 20;
    _pageIndex = 1;
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    [self.tableView.mj_footer beginRefreshing];
    
    [self setUpAdImages];
    [self setUpClassify];
    //[self initAdImages:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)setUpAdImages{
    //广告栏
    __weak typeof(self) weakSelf = self;
    //网络图片
    [HMUtility POST:HM_API_Adlist parameters:@{@"adPost":@"089"} success:^(id responseObject) {
        HMApiResult *ar = responseObject;
        NSArray *array = ar.value;
        if([array count] > 0){
            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            NSMutableArray *descArray = [[NSMutableArray alloc] init];
            for (NSDictionary *ad in array) {
                [imageArray addObject:[NSString stringWithFormat:@"%@%@", HM_IMGSRV_PREFIX, [ad objectForKey:@"image"]]];
                [descArray addObject: [ad objectForKey:@"title"]];
            }
#if 1
//            [weakSelf.adView setUpOnlineImagesWithSource:imageArray PlaceHolder:[UIImage imageNamed:@"ad1"] ClickHandler:^(NSInteger index, NSString *imgSrc, UIImage *img){}];
#endif
            
            [weakSelf initAdImages:imageArray];
            
            
        }
    } failure: nil];
}

- (void)initAdImages:(NSMutableArray *)imageArray{
     dispatch_async(dispatch_get_main_queue(), ^{
    self.billboadrView = [[KNBillboadrView alloc]initKNBillboadrViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TableHeaderViewHeight) andImageArray:imageArray andDescArray:nil andplaceholdImage:nil];
    
//    _billboadrView = [[KNBillboadrView alloc]initKNBillboadrViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TableHeaderViewHeight) andplaceholdImage:[UIImage imageNamed:@"KNBilboardDefalutImge.png"]];
    
    [self.billboadrView setBackgroundColor:[UIColor whiteColor]];
    
    //设置代理
    self.billboadrView.delegate = self;
    self.billboadrView.KNPageCotrollPostion = KNPostionBottomLeft;
    //[_bollboadrView setPageImage:[UIImage imageNamed:@"4"] andCurrentPageImage:[UIImage imageNamed:@"5"]];
    self.billboadrView.time = 3.f;
    
    // 设置滑动时gif停止播放
    self.billboadrView.gifPlayMode = KNGifPlayModePauseWhenScroll;
    [self.userHeaderView addSubview:self.billboadrView];
    
//    [_billboadrView setImageArray:imageArray andDescArray:nil];
//    imageArray = @[
//                            @"https://www.hanmolian.com/uploadfiles/upload/hml/adv/201809110844035_10e28711.jpg",
//                            @"https://www.hanmolian.com/uploadfiles/upload/hml/adv/201809110844035_10e28711.jpg",
//                            //使用本地gif图片的时候。需要调用这个方法,
//                            @"https://www.hanmolian.com/uploadfiles/upload/hml/adv/201809110844035_10e28711.jpg",
//                            @"https://www.hanmolian.com/uploadfiles/upload/hml/adv/201809110844035_10e28711.jpg"
//                            ].mutableCopy;
//
//    [_billboadrView setImageArray:imageArray andDescArray:nil];
//    [self.tableView reloadData];
    
//    [_billboadrView startTimer];
         
          });
}

- (void)setUpClassify{
    //分类栏
    [HMUtility POST:HM_API_Classify parameters:@{} success:^(id responseObject) {
        HMApiResult *ar = responseObject;
        [self initClassifyView: ar];
        
    } failure: nil];
    
}
- (void)initClassifyView:(HMApiResult *)result
{
    NSArray *array = result.data;
    if([array count] > 0){
       _classifyArray = array;
    }
    
    if(_classifyArray){
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat buttonX = 0;
            for (NSInteger index = 0; index < self.classifyArray.count; index++) {
                NSDictionary *ad = self.classifyArray[index];
                
                UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(buttonX, 0, 70, 100)];
                cell.userInteractionEnabled = YES;
//                cell.backgroundColor = [UIColor redColor];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                imageView.yy_imageURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", HM_IMGSRV_PREFIX, [ad objectForKey:@"icon"]]];
                
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = [ad objectForKey:@"name"];
                label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
                label.font = [UIFont systemFontOfSize:14];
                label.textAlignment = NSTextAlignmentCenter;
                
                [cell addSubview:imageView];
                [cell addSubview:label];
                
                imageView.translatesAutoresizingMaskIntoConstraints = NO;
                label.translatesAutoresizingMaskIntoConstraints = NO;
                
                [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[imageView]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(imageView)]];
                [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[label]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(label)]];
                
                [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[imageView(50)]-10-[label]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(imageView,label)]];
                
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemPressed:)];
                [tap view].tag = index;
                [cell addGestureRecognizer:tap];
                cell.tag = index;
                [self.scrollView addSubview:cell];
                
                //[_items addObject:cell];
                buttonX += cell.frame.size.width;
            }
            self.scrollView.contentSize = CGSizeMake(buttonX, 0);
            
        });
        
    }
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    NSInteger page = self.pageIndex;
    
    NSDictionary *parame = [[NSMutableDictionary alloc] init];
    [parame setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parame setValue:[NSNumber numberWithInteger:_pageSize] forKey:@"size"];
    
    [HMUtility POST:HM_API_ArtList parameters:parame success:^(id responseObject) {
        HMApiResult *ar = responseObject;
        [self resetLoadData:ar];
    } failure: ^(id resObj){
        [self.tableView.mj_footer endRefreshing];
    } error:^(NSError *err) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void) resetLoadData:(HMApiResult *)result
{
    if(self.pageIndex < 2){
        self.dataSource = [[NSMutableArray alloc] init];
    }
    NSArray *array = result.list;
    if([array count] > 0){
        for (NSDictionary *obj in array) {
            [self.dataSource addObject:obj];
        }
    }
    
    [self.tableView reloadData];
    self.pageCount = result.totalPage;
    if(self.pageCount > self.pageIndex){
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    self.pageIndex += 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ForHeaderInSection;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.scrollView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [_dataSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    
    HMMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainTableCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HMMainTableViewCell" owner:nil options:nil] firstObject];
    }

    cell.contentView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    cell.name.text = [dic objectForKey:@"name"];
    cell.price.text = [NSString stringWithFormat:@"￥ %@", [dic objectForKey:@"selling_Price"]];
    //cell.time.text = [NSString stringWithFormat:@"时间：%@", [dic objectForKey:@"createDate"]];
    cell.time.text = [NSString stringWithFormat:@"作者 %@", [dic objectForKey:@"issuerName"]];
    cell.imgView.yy_imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HM_IMGSRV_PREFIX, [dic objectForKey:@"image"]]];
    
//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    cell.textLabel.text = [dic objectForKey:@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
//    if([indexPath row]%2==0)
//    {
//        cell.backgroundColor=[UIColor greenColor];
//    }
//    else{
//        cell.backgroundColor=[UIColor blueColor];
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [self.dataSource objectAtIndex: [indexPath row]];
    HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
    webVC.urlString = [NSString stringWithFormat:@"%@seller/HMSellerInfo.html?shopid=%@", HM_WEB_URL, [dic objectForKey:@"issuerId"]];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.bounds;
    frame.size.height -= 51;
    self.tableView.frame = frame;
}

#pragma mark - actions
- (IBAction)showAction:(id)sender {
    NSInteger tag = [sender tag];
    if(tag == 1){
        
    }else if(tag == 10){
        [self fengxiang];
        
    }else if(tag == 11){
        //规则
        HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
        webVC.urlString = [NSString stringWithFormat:@"%@primary/HMRule.do", HM_WEB_URL];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if(tag == 101){
        //产品方
        HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
        webVC.urlString = [NSString stringWithFormat:@"%@seller/HMSellerList.do", HM_WEB_URL];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if(tag == 102){
        //我的
        HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
        webVC.urlString = [NSString stringWithFormat:@"%@member/HMUserCenter.do", HM_WEB_URL];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - KNBillboadrViewDelegate
-(void)KNBillboadrView:(KNBillboadrView *)BillboadrView ClickImageForIndex:(NSInteger)index
{
    NSLog(@"index %ld",index);
}

- (void)itemPressed:(id)sender {
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSInteger tag = [[singleTap view] tag];
    NSLog(@"tag:%ld", tag);
    
    NSDictionary *dict = [self.classifyArray objectAtIndex:tag];
    HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
    webVC.urlString = [NSString stringWithFormat:@"%@seller/HMArtList.do?classify=%@", HM_WEB_URL, [dict objectForKey:@"id"]];
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void) fengxiang
{
    if(_fengxiangDic){
        NSArray* imageArray = @[[NSString
                                 stringWithFormat:@"%@%@", HM_IMGSRV_PREFIX, [_fengxiangDic objectForKey:@"imageUrl"] ]];
        
        [HMUtility showShareActionSheetByText:[_fengxiangDic objectForKey:@"content"]
                                       images:imageArray
                                          url:[NSURL URLWithString:[_fengxiangDic objectForKey:@"url"]]
                                        title:[_fengxiangDic objectForKey:@"title"]
                                     subtitle:[_fengxiangDic objectForKey:@"title_circle"]
                                    callBlock:^(bool b){
                                        if(b){
                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"分享成功" preferredStyle:UIAlertControllerStyleAlert];
                                            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
                                            
                                            [self presentViewController:alert animated:YES completion:nil];
                                        }else{
                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"分享失败" preferredStyle:UIAlertControllerStyleAlert];
                                            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                
                                            }]];
                                            
                                            [self presentViewController:alert animated:YES completion:nil];
                                        }
                                        
                                    }];
    }else{
        [HMUtility POST:HM_API_FXText parameters:@{@"type":@"1", @"hmlapp":@"1"} success:^(id responseObject) {
            HMApiResult *ar = responseObject;
            self.fengxiangDic = [ar.value objectForKey:@"data"];
            [self fengxiang];
        } failure: nil];
    }
}
@end
