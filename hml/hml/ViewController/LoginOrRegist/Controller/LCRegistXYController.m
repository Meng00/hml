//
//  LCRegistXYController.m
//  hml
//
//  Created by 刘学 on 2018/10/17.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "LCRegistXYController.h"
#import "HMUtility.h"

@interface LCRegistXYController ()

@end

@implementation LCRegistXYController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@primary/HMRegisterRule.html", HM_WEB_URL]];
    //加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //设置时候自适应
    self.webView.scalesPageToFit = YES;
}

- (IBAction)showAction:(id)sender {
    NSInteger tag = [sender tag];
    if(tag == 1){
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(agreest:)]) {
                [self.delegate agreest:0];
            }
        }];
    }else if(tag == 2){
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(agreest:)]) {
                [self.delegate agreest:0];
            }
        }];
    }else if(tag == 3){
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(agreest:)]) {
                [self.delegate agreest:1];
            }
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
