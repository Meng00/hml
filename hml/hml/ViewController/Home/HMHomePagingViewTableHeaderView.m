//
//  HMHomePagingViewTableHeaderView.m
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMHomePagingViewTableHeaderView.h"
#import "KNBillboadrView.h"
#import "HMUtility.h"

@interface HMHomePagingViewTableHeaderView ()<KNBillboadrViewDelegate>

@property (nonatomic, assign) CGRect billboadrViewFrame;
@property (nonatomic, strong) KNBillboadrView *bollboadrView;

@end

@implementation HMHomePagingViewTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.billboadrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_billboadrView];
        self.billboadrViewFrame = self.billboadrView.frame;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.billboadrView.bounds];
        imageView.image=[UIImage imageNamed:@"ad1"];
//        [self.billboadrView insertSubview:imageView atIndex:0];
        
        [self query];
    }
    return self;
}

-(void) query{
    __weak typeof(self) weakSelf = self;
    //创建广告栏
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
            
            weakSelf.bollboadrView = [[KNBillboadrView  alloc]initKNBillboadrViewWithFrame:CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height) andImageArray:imageArray andDescArray:nil andplaceholdImage:nil];
            //                self.bollboadrView = [[KNBillboadrView alloc]initKNBillboadrViewWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) andImageArray:@[[UIImage imageNamed:@"ad2"],[UIImage imageNamed:@"ad3"]] andDescArray:nil andplaceholdImage:[UIImage imageNamed:@"ad1"]];
            
            weakSelf.bollboadrView.delegate = self;
            weakSelf.bollboadrView.KNPageCotrollPostion = KNPostionBottomCenter;
            
            //设置动画
            //                self.bollboadrView.KNChangeMode = KNChangeModeFade;
            // 设置滑动时gif停止播放
            weakSelf.bollboadrView.gifPlayMode = KNGifPlayModePauseWhenScroll;
            
            weakSelf.bollboadrView.time = 3.f;
            [weakSelf.billboadrView insertSubview:self.bollboadrView atIndex:2];
        }
    } failure: nil];
    
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    CGRect frame = self.billboadrViewFrame;
    frame.size.height -= contentOffsetY;
    frame.origin.y = contentOffsetY;
    self.billboadrView.frame = frame;
}


#pragma mark - KNBillboadrViewDelegate
-(void)KNBillboadrView:(KNBillboadrView *)BillboadrView ClickImageForIndex:(NSInteger)index
{
    NSLog(@"index %ld",index);
}

@end
