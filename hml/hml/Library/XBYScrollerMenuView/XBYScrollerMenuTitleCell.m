//
//  XBYScrollerMenuTitleCell.m
//  hml
//
//  Created by 刘学 on 2018/10/9.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "XBYScrollerMenuTitleCell.h"
#import "YYWebImage.h"

@interface XBYScrollerMenuTitleCell()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;

@end

@implementation XBYScrollerMenuTitleCell

- (instancetype)initWithFrame:(CGRect)frame imageView:(NSString *)imageUrl title: (NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        _imageUrl = imageUrl;
        _title = title;
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.width-20)];
    _imageView.yy_imageURL = [NSURL URLWithString: _imageUrl];
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.frame.size.height+_imageView.frame.origin.y+5, self.frame.size.width, 25)];
    _titleLabel.text = _title;
    _titleLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
}

@end
