//
//  MainController.h
//  hml
//
//  Created by 刘学 on 2018/9/12.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBillboadrView.h"

@interface MainController : UIViewController
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *fengxiang;
@property (weak, nonatomic) IBOutlet UIImageView *person;
@property (weak, nonatomic) IBOutlet UIView *billboadrView;

@end
