//
//  HMHomeController.m
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//
#import "HMHomeController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "HMGlobalParams.h"
#import "MJRefresh.h"
#import "HMHomeController.h"
#import "JXPagerListRefreshView.h"
#import "JXCategoryView.h"
#import "CQSideBarManager.h"
#import "SideBarViewController.h"
#import "LCLoginOrRegistVC.h"
#import "HMViewController.h"



@interface HMHomeController () <JXCategoryViewDelegate,CQSideBarManagerDelegate,SideBarViewControllerDelegate,LCLoginOrRegistVCDelegate,HMHomeTableViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) SideBarViewController *sideBarVC;

@end

@implementation HMHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏不透明
    self.navigationController.navigationBar.translucent = false;
    _titles = @[@"THD交易精选平台"];
    
    HMHomeTableView *powerListView = [[HMHomeTableView alloc] init];
    powerListView.delegate = self;
    powerListView.isNeedHeader=YES;
    _listViewArray = @[powerListView];
    
    _userHeaderView = [[HMHomePagingViewTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXTableHeaderViewHeight)];
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection)];
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:255/255.0 green:54/255.0 blue:8/255.0 alpha:1];
    self.categoryView.titleColor = [UIColor colorWithRed:255/255.0 green:54/255.0 blue:8/255.0 alpha:1];
//    self.categoryView.titleColorGradientEnabled = YES;
//    self.categoryView.titleLabelZoomEnabled = YES;
//    self.categoryView.titleLabelZoomEnabled = YES;
    
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorLineViewColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
//    lineView.indicatorLineWidth = [UIScreen mainScreen].bounds.size.width;
//    self.categoryView.indicators = @[lineView];
    
    _pagerView = [self preferredPagingView];
    [self.view addSubview:self.pagerView];
    
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - actions
- (IBAction)showAction:(id)sender {
    NSInteger tag = [sender tag];
    if(tag == 1){
        
    }else if(tag == 2){
        //[[CQSideBarManager sharedInstance] openSideBar:self];
        if(![HMGlobalParams sharedInstance].anonymous){
            //设置
            HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
            webVC.urlString = [NSString stringWithFormat:@"%@member/HMMySets.do", HM_WEB_URL];
            [self.navigationController pushViewController:webVC animated:YES];
        }else {
            //登录
            LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else if(tag == 101){
        //动态
        HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
        webVC.urlString = [NSString stringWithFormat:@"%@primary/HMSubChain.do", HM_WEB_URL];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if(tag == 102){
        if(![HMGlobalParams sharedInstance].anonymous){
            //寻宝
            HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
            webVC.urlString = [NSString stringWithFormat:@"%@member/HMMyRobot.do", HM_WEB_URL];
            [self.navigationController pushViewController:webVC animated:YES];
        }else {
            //登录
            LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }
        
    }else if(tag == 103){
        //我的
        HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
        webVC.urlString = [NSString stringWithFormat:@"%@member/HMUserCenter.do", HM_WEB_URL];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (JXPagerView *)preferredPagingView {
    //return [[JXPagerView alloc] initWithDelegate:self];
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
    return self.categoryView;
}

- (NSArray<UIView<JXPagerViewListViewDelegate> *> *)listViewsInPagerView:(JXPagerView *)pagerView {
    return self.listViewArray;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}


#pragma mark - CQSideBarManagerDelegate
- (UIView *)viewForSideBar
{
    /*
     *  如果使用VC的view作为侧边栏视图，那么需要注意在ARC模式下控制器出了作用域会被释放掉这种情况，导致无法响应点击事件，个别同学已经碰到这种问题，现已作出解释。比如以下这个写法:
     *  SideBarViewController *sideBarVC = [[SideBarViewController alloc] init];
     *  sideBarVC.view.cq_width = self.view.cq_width - 35.f;
     *  return sideBarVC.view;
     */
    return self.sideBarVC.view;
}

- (BOOL)canCloseSideBar
{
    return YES;
}

#pragma mark ---Getter
- (SideBarViewController *)sideBarVC
{
    if (!_sideBarVC) {
        _sideBarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SideBar"];
        _sideBarVC.delegate = self;
        _sideBarVC.view.cq_width = self.view.cq_width - 135.f;
    }
    return _sideBarVC;
}

#pragma mark --- SideBarViewControllerDelegate
- (void)sideBarDown:(NSInteger )tag
{
    [[CQSideBarManager sharedInstance] closeSideBar];
    if(tag == 0){
        LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
        vc.delegate = self;
        vc.type = 1;
        [self presentViewController:vc animated:YES completion:nil];
    }else if(tag == 1){
        LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark --- LCLoginOrRegistVCDelegate
- (void) LCLoginOrRegistVC:(NSInteger )tag
{
//    HMGlobalParams *params = [HMGlobalParams sharedInstance];
//    _sideBarVC.loginView.hidden = YES;
//    _sideBarVC.infoView.hidden = NO;
//    _sideBarVC.mobileLabel.text = params.mobile;
}

#pragma mark --- HMHomeTableViewDelegate
- (void) downCell:(NSDictionary *)dic
{
    HMViewController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"HMWebView"];
    webVC.urlString = [NSString stringWithFormat:@"%@integralHall/HMHall.do?id=%@", HM_WEB_URL, [dic objectForKey:@"id"]];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

@end
