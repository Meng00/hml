//
//  HMTabBar4Controller.m
//  hml
//
//  Created by 刘学 on 2018/9/19.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMTabBar4Controller.h"

@interface HMTabBar4Controller ()

@end

@implementation HMTabBar4Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlString = [NSString stringWithFormat:@"%@member/HMUserCenter.do", HM_WEB_URL];
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
