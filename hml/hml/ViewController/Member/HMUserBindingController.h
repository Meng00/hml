//
//  HMUserBindingController.h
//  hml
//
//  Created by 刘学 on 2018/10/12.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTextField.h"
#import "ZLVerifyCodeButton.h"
#import "LCLoginOrRegistVC.h"

@interface HMUserBindingController : UIViewController

@property (nonatomic, copy) NSString *unionId;
@property (nonatomic, weak) id<LCLoginOrRegistVCDelegate> delegate;

@property (strong, nonatomic) IBOutlet LCTextField *mobile;
@property (strong, nonatomic) IBOutlet LCTextField *code;
@property (strong, nonatomic) IBOutlet ZLVerifyCodeButton *codeBtn;

@end
