//
//  HMMainController.m
//  hml
//
//  Created by 刘学 on 2018/10/3.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMMain2Controller.h"
#import "HMViewController.h"
#import "JXCategoryView.h"
#import "HMUtility.h"
#import "YYWebImage.h"
//#import <YYWebImage/YYWebImage.h>

@interface HMMain2Controller () <JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleImageView *categoryView;
@property(nonatomic, assign) NSInteger index;


@end

@implementation HMMain2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = false;
    
    _userHeaderView = [[HMMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXTableHeaderViewHeight)];
    self.userHeaderView.backgroundColor = [UIColor whiteColor];
    
    [self setUpAdImages];
    [self setUpClassify];
}
- (void)setUpClassify{
    //广告栏
    __weak typeof(self) weakSelf = self;
    weakSelf.index = 0;
    //网络图片
    [HMUtility POST:HM_API_Classify parameters:@{} success:^(id responseObject) {
        HMApiResult *ar = responseObject;
        NSArray *array = ar.data;
        
        if([array count] > 0){
            weakSelf.categoryView = [[JXCategoryTitleImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection)];
            
            NSMutableArray *titlesArray = [[NSMutableArray alloc] init];
            NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
            NSMutableArray *imageTypesArray = [[NSMutableArray alloc] init];
            NSMutableArray *tableViewArray = [[NSMutableArray alloc] init];
            for (NSDictionary *ad in array) {
                [imagesArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HM_IMGSRV_PREFIX, [ad objectForKey:@"icon"]]]];
                [titlesArray addObject: [ad objectForKey:@"name"]];
                [imageTypesArray addObject: [NSNumber numberWithInteger: 0]];
                HMMainTableView *tableView = [[HMMainTableView alloc] init];
                tableView.classifyId = [ad objectForKey:@"id"];
                tableView.delegate = self;
                //tableView.isNeedHeader=YES;
                [tableView query];
                [tableViewArray addObject:tableView];
            }
            weakSelf.listViewArray = tableViewArray;
            weakSelf.categoryView.titles = titlesArray;
            weakSelf.categoryView.imageURLs = imagesArray;
            weakSelf.categoryView.imageTypes = imageTypesArray;
            weakSelf.categoryView.imageSize = CGSizeMake(40, 40);
            
            weakSelf.categoryView.backgroundColor = [UIColor whiteColor];
            weakSelf.categoryView.delegate = self;
            weakSelf.categoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
            weakSelf.categoryView.titleColor = [UIColor blackColor];
            
            weakSelf.categoryView.loadImageCallback = ^(UIImageView *imageView){
                if(!imageView.image){
                    NSLog(@"%ld ----=imageUrl: %ld", weakSelf.index, imagesArray.count);
                    NSURL *imageUrl = imagesArray[weakSelf.index];
                    imageView.yy_imageURL = imageUrl;
                    weakSelf.index ++;
                }
            };
            
            weakSelf.pagerView = [self preferredPagingView];
            [weakSelf.view addSubview:weakSelf.pagerView];
            
            weakSelf.categoryView.contentScrollView = weakSelf.pagerView.listContainerView.collectionView;
            
            weakSelf.navigationController.interactivePopGestureRecognizer.enabled = (weakSelf.categoryView.selectedIndex == 0);
            
        }
    } failure: nil];
    
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
            [weakSelf.userHeaderView setUpOnlineImagesWithSource:imageArray
                                                     PlaceHolder:[UIImage imageNamed:@"KNBilboardDefalutImge"]
                                                    ClickHandler:^(NSInteger index, NSString *imgSrc, UIImage *img) {
                                                        
                                                    }];
#endif
            
            
        }
    } failure: nil];
}
#pragma mark - actions
- (IBAction)showAction:(id)sender {
    NSInteger tag = [sender tag];
    if(tag == 1){
        
    }else if(tag == 2){
        
    }else if(tag == 101){
        //商家
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
    return self.categoryView;
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
    webVC.urlString = [NSString stringWithFormat:@"%@seller/HMArtInfo.do?artid=%@", HM_WEB_URL, [dic objectForKey:@"id"]];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

@end
