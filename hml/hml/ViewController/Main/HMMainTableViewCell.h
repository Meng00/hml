//
//  HMMainTableViewCell.h
//  hml
//
//  Created by 刘学 on 2018/10/3.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMMainTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end
