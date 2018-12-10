//
//  HMUserPwdController.h
//  hml
//
//  Created by 刘学 on 2018/9/21.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTextField.h"
#import "ZLVerifyCodeButton.h"

@interface HMUserPwdController : UIViewController
@property (strong, nonatomic) IBOutlet LCTextField *mobile;
@property (strong, nonatomic) IBOutlet LCTextField *code;
@property (strong, nonatomic) IBOutlet LCTextField *pwd;
@property (strong, nonatomic) IBOutlet LCTextField *pwd2;
@property (strong, nonatomic) IBOutlet ZLVerifyCodeButton *codeBtn;
@property (strong, nonatomic) IBOutlet UIButton *butt;

@end
