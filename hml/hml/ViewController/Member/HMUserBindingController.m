//
//  HMUserBindingController.m
//  hml
//
//  Created by 刘学 on 2018/10/12.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMUserBindingController.h"
#import "HMTextChecker.h"
#import "ZLVerifyCodeButton.h"
#import "HMUtility.h"
#import "LCLoginOrRegistVC.h"
#import <SVProgressHUD.h>
#import "HMHomeController.h"

@interface HMUserBindingController ()<LCLoginOrRegistVCDelegate>

@end

@implementation HMUserBindingController


- (void)viewDidLoad {
    [super viewDidLoad];
    //将title 文字的颜色改为透明
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
    // 获取验证码按钮
    self.view.backgroundColor = [UIColor whiteColor];
    //self.codeBtn = [ZLVerifyCodeButton buttonWithType:UIButtonTypeCustom];
    [self.codeBtn setup];
    //self.frame = CGRectMake(self.code.frame.size.width + 10, 5, 70, 40);
    [self.codeBtn addTarget:self action:@selector(codeBtnVerification) forControlEvents:UIControlEventTouchUpInside];
    //[self.code addSubview:codeBtn];
    //self.codeBtn = codeBtn;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
- (IBAction) close {
    [self.view endEditing:YES];
    //    return YES;
}

// 获取验证码点击事件
- (void)codeBtnVerification {
    NSString *mobile= self.mobile.text;
    if ([HMTextChecker checkIsEmpty:mobile]) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    if (![HMTextChecker checkIsMobile:mobile]){
        [SVProgressHUD showInfoWithStatus:@"手机号码不正确!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    
    [self.view endEditing:YES];
    NSLog(@"验证码:%@", self.code.text);
    [self.codeBtn timeFailBeginFrom:60]; // 倒计时60s
    [HMUtility POST:HM_API_SendCode parameters:@{@"type":[NSNumber numberWithInteger:0],@"mobile":mobile} success:^(id responseObject) {
        HMApiResult *ar = responseObject;
        [SVProgressHUD showSuccessWithStatus:ar.message];
        
    } failure: ^(id responseObject) {
        HMApiResult *ar = responseObject;
        [SVProgressHUD showErrorWithStatus:ar.message];
        [self.codeBtn timeFailBeginFrom:1]; // 倒计时1
    }];
    
}

- (IBAction)updateButtonDown:(id)sender {
    
    [self.view endEditing:YES];
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    NSString *mobile= self.mobile.text;
    NSString *code = self.code.text;
    if ([HMTextChecker checkIsEmpty:mobile]) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    if (![HMTextChecker checkIsMobile:mobile]){
        [SVProgressHUD showInfoWithStatus:@"手机号码不正确!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    if ([HMTextChecker checkIsEmpty:code]){
        [SVProgressHUD showInfoWithStatus:@"请输入短信验证码!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    __weak typeof(self)weakSelf = self;
    [HMUtility POST:HM_API_Binding parameters:@{@"mobile":mobile,@"code":code,@"unionId":[HMGlobalParams sharedInstance].unionid} success:^(id responseObject) {
        HMApiResult *ar = responseObject;
        
        [SVProgressHUD showSuccessWithStatus:ar.message];
        [SVProgressHUD dismissWithDelay:0.6f];
        
        HMGlobalParams *params = [HMGlobalParams sharedInstance];
        params.anonymous = NO;
        
        params.uid = [[ar.data objectForKey:@"id"] integerValue];//后台 没有返回id
        params.mobile = [ar.data objectForKey:@"mobile"];
        params.loginToken = [ar.data objectForKey:@"token"];
        params.name = [ar.data objectForKey:@"real_name"];
        
        //数据存到手机上
        [HMUtility writeUserInfo];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure: ^(id responseObject) {
        HMApiResult *ar = responseObject;
        if(ar.result == 3){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:ar.message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"立即注册" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
                vc.delegate = self;
                vc.type=1;
                vc.mobile = mobile;
                vc.isHiddenWxLogin = YES;
                vc.unionId = [HMGlobalParams sharedInstance].unionid;
                vc.openid = [HMGlobalParams sharedInstance].openid;
                [self presentViewController:vc animated:YES completion:nil];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:ar.message];
        }
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- LCLoginOrRegistVCDelegate
- (void) LCLoginOrRegistVC:(NSInteger )tag
{
    //登录成功处理 通知页面
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(LCLoginOrRegistVC:)]) {
        [self.delegate LCLoginOrRegistVC:0];
    }
}
- (void) closeLogin:(NSInteger )tag
{
    //取消
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(closeLogin:)]) {
        [self.delegate closeLogin:0];
    }
}

@end
