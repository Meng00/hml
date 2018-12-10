//
//  LCLoginOrRegistVC.m
//  BSProject
//
//  Created by Liu-Mac on 08/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCLoginOrRegistVC.h"
#import "LCUserTool.h"
#import "HMTextChecker.h"
#import "ZLVerifyCodeButton.h"
#import "HMUtility.h"
#import "HMUserPwdController.h"
#import "HMUserBindingController.h"
#import <ShareSDK/ShareSDK.h>
#import <SVProgressHUD.h>
#import "LCRegistXYController.h"

@interface LCLoginOrRegistVC ()<LCRegistXYDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (strong, nonatomic) IBOutlet UIButton *regist;

@end

@implementation LCLoginOrRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    // 获取验证码按钮
    //ZLVerifyCodeButton *codeBtn = [ZLVerifyCodeButton buttonWithType:UIButtonTypeCustom];
    [self.codeBtn setup];
    //self.codeBtn.frame = CGRectMake(self.pwdText.frame.size.width - 85, 10, 70, 30);
    [self.codeBtn addTarget:self action:@selector(codeBtnVerification) forControlEvents:UIControlEventTouchUpInside];
    //[self.regCodeField addSubview:codeBtn];
    //self.codeBtn = codeBtn;
    if(self.type == 1){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.regist.selected = YES;
            self.leadingConstraint.constant = -self.view.frame.size.width;
        });
    }
    if(_mobile){
        _regMobileField.text = _mobile;
        _mobileText.text = _mobile;
    }
    if(_isHiddenWxLogin){
        _kjLoginView.hidden = _isHiddenWxLogin;
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent;
//}

- (IBAction)closeLogin {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(closeLogin:)]) {
            [self.delegate closeLogin:0];
        }
    }];
}

- (IBAction) resignFirst {
    [self.view endEditing:YES];
    
}

// 获取验证码点击事件
- (void)codeBtnVerification {
    NSString *mobile=_regMobileField.text;
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
    
    NSLog(@"验证码:%@", self.mobileText.text);
    [self.codeBtn timeFailBeginFrom:60]; // 倒计时60s
    [HMUtility POST:HM_API_SendCode parameters:@{@"type":[NSNumber numberWithInteger:0],@"mobile":mobile} success:^(id responseObject) {
        HMApiResult *ar = responseObject;
        [SVProgressHUD showSuccessWithStatus:ar.message];
        [SVProgressHUD dismissWithDelay:0.6f];
        
    } failure: ^(id responseObject) {
        HMApiResult *ar = responseObject;
        [SVProgressHUD showErrorWithStatus:ar.message];
        [SVProgressHUD dismissWithDelay:0.6f];
        
        [self.codeBtn timeFailBeginFrom:1]; // 倒计时1
    }];
    
}

- (IBAction)registe:(UIButton *)btn {
    // 通过view辞退键盘, 而不是使用resignFirstResponder方法
    // 这个方法对view无效
    [self.view endEditing:YES];
    if([btn tag] == 0){
        if (btn.selected) {
            btn.selected = NO;
            self.leadingConstraint.constant = 0;
        } else {
            btn.selected = YES;
            self.leadingConstraint.constant = -self.view.frame.size.width;
        }
    }
    else if ([btn tag] == 2) {
        self.leadingConstraint.constant = 0;
    } else if([btn tag] == 1) {
        self.leadingConstraint.constant = -self.view.frame.size.width;
    } else if([btn tag] == 3) {
        [self dismissViewControllerAnimated:YES completion:^{
            UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [nav pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdatePwd"] animated:YES];
        }];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark -
#pragma mark event handler
-(IBAction) shareLogin:(id)sender{
    [self.view endEditing:YES];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
//             NSLog(@"uid=%@",user.uid);
//             NSLog(@"%@",user.credential);
//             NSLog(@"token=%@",user.credential.token);
//             NSLog(@"nickname=%@",user.nickname);
//             NSLog(@"%@",user.rawData);
//             NSLog(@"%@",user.credential.rawData);
             [HMGlobalParams sharedInstance].unionid = user.uid;
             [HMGlobalParams sharedInstance].openid = [user.rawData objectForKey:@"openid"];
             
             [HMUtility POST:HM_API_ThirdP_Login parameters:@{@"unionId":user.uid} success:^(id responseObject) {
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
                 
                 [self dismissViewControllerAnimated:YES completion:^{
                     if ([self.delegate respondsToSelector:@selector(LCLoginOrRegistVC:)]) {
                         [self.delegate LCLoginOrRegistVC:0];
                     }
                 }];
             } failure: ^(id responseObject) {
                 HMApiResult *ar = responseObject;
                 if(ar.result == 4){
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:ar.message preferredStyle:UIAlertControllerStyleAlert];
                     [alert addAction:[UIAlertAction actionWithTitle:@"马上绑定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                         
                         [self dismissViewControllerAnimated:YES completion:^{
                             UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                             HMUserBindingController *bind = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"binding"];
                             bind.delegate = self.delegate;
                             [nav pushViewController:bind animated:YES];
                         }];
                         
                     }]];
                     [self presentViewController:alert animated:YES completion:nil];
                 }else{
                     [SVProgressHUD showErrorWithStatus:ar.message];
                     [SVProgressHUD dismissWithDelay:0.6f];
                 }
             }];
             
         }else
         {
             NSLog(@"%@",error);
             [SVProgressHUD showErrorWithStatus:error.description];
             [SVProgressHUD dismissWithDelay:0.6f];
         }
         
     }];
}

- (IBAction)loginButtonDown:(id)sender {
    [self.view endEditing:YES];
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    NSString *mobile=_mobileText.text;
    NSString *pass =_pwdText.text;
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
        [SVProgressHUD showInfoWithStatus:@"请输入登录密码!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    
    [HMUtility POST:HM_API_Login parameters:@{@"username":mobile,@"password":pass} success:^(id responseObject) {
        HMApiResult *ar = responseObject;
        [SVProgressHUD showSuccessWithStatus:ar.message];
        [SVProgressHUD dismissWithDelay:0.6f];
        
        HMGlobalParams *params = [HMGlobalParams sharedInstance];
        params.anonymous = NO;
        params.password = pass;
        params.uid = [[ar.data objectForKey:@"id"] integerValue];//后台 没有返回id
        params.mobile = [ar.data objectForKey:@"mobile"];
        params.loginToken = [ar.data objectForKey:@"token"];
        params.name = [ar.data objectForKey:@"real_name"];
        
        //数据存到手机上
        [HMUtility writeUserInfo];
        
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(LCLoginOrRegistVC:)]) {
                [self.delegate LCLoginOrRegistVC:0];
            }
        }];
    } failure: ^(id responseObject) {
        HMApiResult *ar = responseObject;
        [SVProgressHUD showErrorWithStatus:ar.message];
    }];
    
}

- (IBAction)registerButtonDown:(id)sender {
    [self.view endEditing:YES];
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    NSString *mobile=_regMobileField.text;
    NSString *pass =_regPwdField.text;
    NSString *pass2 =_regPwd2Field.text;
    NSString *code =_regCodeField.text;
    NSString *name =_regNameField.text;
    NSString *card =_regCardField.text;
    NSString *number =_regNumField.text;
    
    if ([HMTextChecker checkIsEmpty:mobile]) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    if (![HMTextChecker checkIsMobile:mobile]){
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    if ([HMTextChecker checkIsEmpty:code]){
        [SVProgressHUD showInfoWithStatus:@"请输入验证码!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    
    if ([HMTextChecker checkIsEmpty:pass]){
        [SVProgressHUD showInfoWithStatus:@"请输入登录密码!"];
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
    if ([HMTextChecker checkIsEmpty:name]){
        [SVProgressHUD showInfoWithStatus:@"请输入您的真实姓名!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    if ([HMTextChecker checkIsEmpty:card]){
        [SVProgressHUD showInfoWithStatus:@"请输入身份证号!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    if (![HMTextChecker checkIsCardID:card]){
        [SVProgressHUD showInfoWithStatus:@"身份证号填写有误!"];
        [SVProgressHUD dismissWithDelay:0.6f];
        return;
    }
    
    _regBut.enabled = NO;
    LCRegistXYController *xy = [[LCRegistXYController alloc] init];
    xy.delegate = self;
    [self presentViewController:xy animated:YES completion:nil];
    
}

- (IBAction)sinaLogin {
    [LCUserTool loginUseSinaWithVc:nil completion:^(BOOL isSuccess) {
        [self dismissViewControllerAnimated:NO completion:nil];
        isSuccess ? ({
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        }) : ({
            [SVProgressHUD showSuccessWithStatus:@"登录失败"];
        });
    }];
}

- (void) agreest:(NSInteger )tag
{
    if(tag == 1){
        NSString *mobile=_regMobileField.text;
        NSString *pass =_regPwdField.text;
        NSString *code =_regCodeField.text;
        
        NSString *pass2 =_regPwd2Field.text;
        NSString *name =_regNameField.text;
        NSString *card =_regCardField.text;
        NSString *number =_regNumField.text;
        
        
        NSDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:mobile forKey:@"username"];
        [param setValue:pass forKey:@"password"];
        [param setValue:pass2 forKey:@"confirmPassword"];
        [param setValue:code forKey:@"code"];
        
        [param setValue:name forKey:@"realName"];
        [param setValue:card forKey:@"idCard"];
        [param setValue:number forKey:@"invitationCode"];
        if(_unionId){
            [param setValue:_unionId forKey:@"unionID"];
        }
        //    if(_openid){
        //        [param setValue:_openid forKey:@"openid"];
        //    }
        
        [HMUtility POST:HM_API_Register parameters:param success:^(id responseObject) {
            HMApiResult *ar = responseObject;
            if([SVProgressHUD isVisible]){
                [SVProgressHUD dismiss];
            }
            [SVProgressHUD showSuccessWithStatus:ar.message];
            [SVProgressHUD dismissWithDelay:0.6f];
            
            HMGlobalParams *params = [HMGlobalParams sharedInstance];
            params.anonymous = NO;
            params.password = pass;
            params.uid = [[ar.data objectForKey:@"id"] integerValue];//后台 没有返回id
            params.mobile = [ar.data objectForKey:@"mobile"];
            params.loginToken = [ar.data objectForKey:@"token"];
            params.name = [ar.data objectForKey:@"real_name"];
            
            //数据存到手机上
            [HMUtility writeUserInfo];
            
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(LCLoginOrRegistVC:)]) {
                    [self.delegate LCLoginOrRegistVC:0];
                }
            }];
        } failure: ^(id responseObject) {
            HMApiResult *ar = responseObject;
            if([SVProgressHUD isVisible]){
                [SVProgressHUD dismiss];
            }
            [SVProgressHUD showSuccessWithStatus:ar.message];
            [SVProgressHUD dismissWithDelay:0.6f];
            self.regBut.enabled = YES;
            
        }];
        
    }else{
        _regBut.enabled = YES;
    }
    
}

@end
