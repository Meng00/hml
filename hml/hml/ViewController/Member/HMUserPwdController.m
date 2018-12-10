//
//  HMUserPwdController.m
//  hml
//
//  Created by 刘学 on 2018/9/21.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMUserPwdController.h"
#import "HMTextChecker.h"
#import "ZLVerifyCodeButton.h"
#import "HMUtility.h"
#import "LCLoginOrRegistVC.h"
#import <SVProgressHUD.h>
#import "HMHomeController.h"

@interface HMUserPwdController ()<LCLoginOrRegistVCDelegate>

@end

@implementation HMUserPwdController

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
    NSString *pass = self.pwd.text;
    NSString *pass2 = self.pwd2.text;
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
    if ([HMTextChecker checkIsEmpty:pass]){
        [SVProgressHUD showInfoWithStatus:@"请输入密码!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    
    if (![HMTextChecker checkLength:pass min:6 max:12]){
        [SVProgressHUD showInfoWithStatus:@"密码长度必须6~12位!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    
    if (![pass isEqualToString:pass2]){
        [SVProgressHUD showInfoWithStatus:@"两次密码不一致!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    if ([HMTextChecker checkIsEmpty:code]){
        [SVProgressHUD showInfoWithStatus:@"请输入短信验证码!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    _butt.enabled = NO;
    [HMUtility POST:HM_API_UpdatePwd parameters:@{@"username":mobile,@"password":pass,@"confirmPassword":pass,@"code":code} success:^(id responseObject) {
        HMApiResult *ar = responseObject;
        [HMUtility resetUserInfo];
        
        [SVProgressHUD showSuccessWithStatus:ar.message];
        [SVProgressHUD dismissWithDelay:0.6f];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LCLoginOrRegistVC *vc = [[LCLoginOrRegistVC alloc] init];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        });
    } failure: ^(id responseObject) {
        HMApiResult *ar = responseObject;
        [SVProgressHUD showErrorWithStatus:ar.message];
        self.butt.enabled = YES;
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void) closeLogin:(NSInteger )tag
{
    //登录成功处理 通知页面
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
