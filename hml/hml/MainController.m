//
//  MainController.m
//  hml
//
//  Created by 刘学 on 2018/9/12.
//  Copyright © 2018年 翰墨链. All rights reserved.
//
#import <PGNetworkHelper/PGNetworkHelper.h>
#import "MainController.h"
#import "CQSideBarManager.h"
#import "SideBarViewController.h"
#import "HMUtility.h"
#import "HMHomeController.h"
#import "ViewController.h"

@interface MainController ()<CQSideBarManagerDelegate,KNBillboadrViewDelegate>

@property (nonatomic, strong) SideBarViewController *sideBarVC;
@property(nonatomic, strong) KNBillboadrView *bollboadrView;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setUI
{
//    UIImageView *imageView=[[UIImageView alloc] initWithFrame:_billboadrView.bounds];
//    imageView.image=[UIImage imageNamed:@"KNBilboardDefalutImge"];
//    [_billboadrView insertSubview:imageView atIndex:0];
    
    //第二种方式创建广告栏。 图片数据暂时没有的情况下
    _bollboadrView = [[KNBillboadrView alloc] initKNBillboadrViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _billboadrView.bounds.size.height) andplaceholdImage: [UIImage imageNamed:@"KNBilboardDefalutImge"]];
    //[_bollboadrView setBackgroundColor:[UIColor grayColor]];
//    //设置代理
    _bollboadrView.delegate = self;
    _bollboadrView.KNPageCotrollPostion = KNPostionBottomLeft;
    // 设置滑动时gif停止播放
    _bollboadrView.gifPlayMode = KNGifPlayModePauseWhenScroll;
    [_billboadrView addSubview:_bollboadrView];
    
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
            [self.bollboadrView setImageArray:imageArray andDescArray:descArray];
        }
    } failure: nil];
   
    
    
}

#pragma mark - actions
- (IBAction)showAction:(id)sender {
    NSInteger tag = [sender tag];
    if(tag == 1){
        HMHomeController *home = [[HMHomeController alloc] init];
        
        [self.navigationController pushViewController:home animated:YES];
    }else if(tag == 2){
        [[CQSideBarManager sharedInstance] openSideBar:self];
    }
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
        _sideBarVC.view.cq_width = self.view.cq_width - 135.f;
    }
    return _sideBarVC;
}

#pragma mark - KNBillboadrViewDelegate
-(void)KNBillboadrView:(KNBillboadrView *)BillboadrView ClickImageForIndex:(NSInteger)index
{
    NSLog(@"index %ld",index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
