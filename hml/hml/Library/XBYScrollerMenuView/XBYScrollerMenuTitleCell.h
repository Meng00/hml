//
//  XBYScrollerMenuTitleCell.h
//  hml
//
//  Created by 刘学 on 2018/10/9.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBYScrollerMenuTitleCell : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame imageView:(NSString *)imageUrl title:(NSString *)title;

@end
