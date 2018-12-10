//
//  LCRegistXYController.h
//  hml
//
//  Created by 刘学 on 2018/10/17.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LCRegistXYDelegate <NSObject>

@required
- (void) agreest:(NSInteger )tag;

@end

@interface LCRegistXYController : UIViewController
@property (nonatomic, weak) id<LCRegistXYDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
