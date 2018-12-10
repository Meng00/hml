//
//  HMViewController.h
//  hmArt
//
//  Created by 刘学 on 2018/1/13.
//  Copyright © 2018年 hanmoqianqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMUtility.h"
#import "HMGlobal.h"

@interface HMViewController : UIViewController

@property (nonatomic,copy) NSString *urlString;

/** 背景视图图 */
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;


@end
