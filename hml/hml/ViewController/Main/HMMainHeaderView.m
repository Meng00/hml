//
//  HMMainHeaderView.m
//  hml
//
//  Created by 刘学 on 2018/10/3.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMMainHeaderView.h"
#import "KHAdView.h"
#import "HMUtility.h"

@interface HMMainHeaderView()

@end


@implementation HMMainHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpAdImages];
    }
    return self;
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
            [weakSelf setUpOnlineImagesWithSource:imageArray
                                                     PlaceHolder:[UIImage imageNamed:@"KNBilboardDefalutImge"]
                                                    ClickHandler:^(NSInteger index, NSString *imgSrc, UIImage *img) {
                                                        
                                                    }];
#endif
            
            
        }
    } failure: nil];
}

@end
