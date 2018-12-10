//
//  LCLoginOrRegistVC.h
//  BSProject
//
//  Created by Liu-Mac on 08/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTextField.h"
#import "ZLVerifyCodeButton.h"
@protocol LCLoginOrRegistVCDelegate <NSObject>

@required
- (void) LCLoginOrRegistVC:(NSInteger )tag;

@optional
- (void) closeLogin:(NSInteger )tag;

@end

@interface LCLoginOrRegistVC : UIViewController
@property (nonatomic, weak) id<LCLoginOrRegistVCDelegate> delegate;

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) BOOL isHiddenWxLogin;
@property (nonatomic, copy) NSString *unionId;
@property (nonatomic, copy) NSString *openid;

@property (nonatomic, assign) NSInteger type;
@property (strong, nonatomic) IBOutlet LCTextField *pwdText;
@property (strong, nonatomic) IBOutlet LCTextField *mobileText;

@property (strong, nonatomic) IBOutlet LCTextField *regMobileField;
@property (strong, nonatomic) IBOutlet LCTextField *regPwdField;
@property (strong, nonatomic) IBOutlet LCTextField *regCodeField;
@property (strong, nonatomic) IBOutlet LCTextField *regPwd2Field;
@property (strong, nonatomic) IBOutlet LCTextField *regNameField;
@property (strong, nonatomic) IBOutlet LCTextField *regCardField;
@property (strong, nonatomic) IBOutlet LCTextField *regNumField;

@property (strong, nonatomic) IBOutlet ZLVerifyCodeButton *codeBtn;
@property (strong, nonatomic) IBOutlet UIView *kjLoginView;
@property (strong, nonatomic) IBOutlet UIButton *loginBut;
@property (strong, nonatomic) IBOutlet UIButton *regBut;



@end
