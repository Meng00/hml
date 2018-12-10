//
//  HMMainController.m
//  hml
//
//  Created by 刘学 on 2018/10/3.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMMainController.h"
#import "HMViewController.h"
#import "JXCategoryView.h"
#import "HMUtility.h"
#import "YYWebImage.h"
#import "XBYScrollerMenuView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "XBYScrollerMenuTitleCell.h"
#import "HMHomePageViewController.h"

@interface HMMainController () <JXCategoryViewDelegate,XBYScrollerMenuDelegate>

@property (nonatomic, strong) JXCategoryTitleImageView *categoryView;
@property(nonatomic, assign) NSInteger index;
@property (nonatomic, strong) XBYScrollerMenuView *vc;
@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic,copy)NSArray *classifyArray;
@property(nonatomic,copy)NSDictionary *fengxiangDic;

@end

@implementation HMMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = false;
    
//    _userHeaderView = [[HMMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXTableHeaderViewHeight)];
    _userHeaderView = [[HMHomePagingViewTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXTableHeaderViewHeight)];
    
    self.userHeaderView.backgroundColor = [UIColor whiteColor];
    
    HMMainTableView *tableView = [[HMMainTableView alloc] init];
    tableView.delegate = self;
    tableView.isNeedHeader=YES;
    [tableView query];
    _listViewArray = @[tableView];
    
    _vc = [[XBYScrollerMenuView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 120) showArrayButton:NO];
    _vc.delegate = self;
    _vc.backgroundColor=[UIColor whiteColor];
    _vc.selectedColor=[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    _vc.noSlectedColor=[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    
    _pagerView = [self preferredPagingView];
    [self.view addSubview:self.pagerView];
    
    [self setUpClassify];
    [self fengxiang];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setUpClassify{
    //分类栏
    __weak typeof(self) weakSelf = self;
    weakSelf.index = 0;
    //
    [HMUtility POST:HM_API_Classify parameters:@{} success:^(id responseObject) {
        HMApiResult *ar = responseObject;
        NSArray *array = ar.data;
        
        if([array count] > 0){
            weakSelf.classifyArray = array;
            NSMutableArray *titlesArray = [[NSMutableArray alloc] init];
            NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
            for (NSDictionary *ad in array) {
                [imagesArray addObject:[NSString stringWithFormat:@"%@%@", HM_IMGSRV_PREFIX, [ad objectForKey:@"icon"]]];
                [titlesArray addObject: [ad objectForKey:@"name"]];

            }
            weakSelf.vc.myImageUrlArray = imagesArray;
            weakSelf.vc.myTitleArray= titlesArray;
            
            [weakSelf.pagerView reloadData];
            
            
        }
    } failure: nil];
    
}

#pragma mark - actions
- (IBAction)showAction:(id)sender {
    NSInteger tag = [sender tag];
    if(tag == 11){
        HMHomePageViewController *page = [[HMHomePageViewController alloc] init];
        [self.navigationController pushViewController:page animated:YES];
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
- (JXPagerView *)preferredPagingView {
//    return [[JXPagerView alloc] initWithDelegate:self];
    return [[JXPagerListRefreshView alloc] initWithDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.bounds;
    frame.size.height -= 51;
    self.pagerView.frame = frame;
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (CGFloat)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return JXTableHeaderViewHeight;
}

- (CGFloat)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return JXheightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.vc;
}

- (NSArray<UIView<JXPagerViewListViewDelegate> *> *)listViewsInPagerView:(JXPagerView *)pagerView {
    return self.listViewArray;
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //NSLog(@"============:%ld", index);
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    
}

#pragma mark --- HMHomeTableViewDelegate
- (void) downCell:(NSDictionary *)dic
{
    
    HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
    webVC.urlString = [NSString stringWithFormat:@"%@seller/HMSellerInfo.html?shopid=%@", HM_WEB_URL, [dic objectForKey:@"issuerId"]];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

#pragma mark --- XBYScrollerMenuDelegate
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    NSDictionary *dict = [self.classifyArray objectAtIndex:index];
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
            
        } failure: nil];
    }
}

@end
