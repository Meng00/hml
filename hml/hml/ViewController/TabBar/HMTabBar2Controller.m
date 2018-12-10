//
//  HMTabBar2Controller.m
//  hml
//
//  Created by 刘学 on 2018/9/19.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMTabBar2Controller.h"

@interface HMTabBar2Controller ()

@end

@implementation HMTabBar2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlString = [NSString stringWithFormat:@"%@primary/HMSubChain.do", HM_WEB_URL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
