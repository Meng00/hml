//
//  SideBarViewController.m
//  CQSideBarManager
//
//  Created by heartjoy on 2017/11/7.
//  Copyright © 2017年 heartjoy. All rights reserved.
//

#import "SideBarViewController.h"
#import "CQSideBarConst.h"
#import "CQSideBarManager.h"
#import "HMGlobalParams.h"

@interface SideBarViewController ()

@end

@implementation SideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![HMGlobalParams sharedInstance].anonymous){
        self.loginView.hidden = YES;
        self.infoView.hidden = NO;
        self.mobileLabel.text = [HMGlobalParams sharedInstance].mobile;
    }else{
        self.loginView.hidden = NO;
        self.infoView.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


#pragma mark - actions
- (IBAction)showAction:(id)sender {
    [self.delegate sideBarDown:[sender tag]];
}


- (void)closeView
{
    [[CQSideBarManager sharedInstance] closeSideBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"SideBarViewController dealloc");
}

@end
