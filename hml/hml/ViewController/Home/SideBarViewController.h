//
//  SideBarViewController.h
//  CQSideBarManager
//
//  Created by heartjoy on 2017/11/7.
//  Copyright © 2017年 heartjoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideBarViewControllerDelegate <NSObject>

@required
- (void) sideBarDown:(NSInteger )tag;
@end

@interface SideBarViewController : UIViewController
@property (nonatomic, weak) id<SideBarViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;

@end
