//
//  HMHomeTableViewCell.m
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import "HMHomeTableViewCell.h"

@interface HMHomeTableViewCell ()

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *v1Lab1;
@property (nonatomic, strong) UILabel *v1Lab2;
@property (nonatomic, strong) UILabel *v1Lab3;
@property (nonatomic, strong) UILabel *v1Lab4;

@property (nonatomic, strong) UILabel *v3Lab1;
@property (nonatomic, strong) UILabel *v3Lab2;

//头像
@property (nonatomic, weak) UIImageView *headImageView;
@property (nonatomic, weak) UILabel *nameLabel;


@end

@implementation HMHomeTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    
    _view1 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_view1];
    
    _view2 = [[UIView alloc] initWithFrame:CGRectZero];
    _view2.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [self.contentView addSubview:_view2];
    
    _view3 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_view3];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [self.contentView addSubview:_lineView];
    
    _view1.translatesAutoresizingMaskIntoConstraints = NO;
    _view2.translatesAutoresizingMaskIntoConstraints = NO;
    _view3.translatesAutoresizingMaskIntoConstraints = NO;
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self.contentView, _view1, _view2, _view3, _lineView);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_view1(==180)]-0-[_view2(==1)]-0-[_view3]" options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_view1]-1-|" options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_view2]-21-|" options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_view3]-1-|" options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_lineView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_lineView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lineView(==1)]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_lineView)]];
    
    
    _v1Lab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    _v1Lab1.textColor = [UIColor colorWithRed:255/255.0 green:97/255.0 blue:42/255.0 alpha:1.0];
    _v1Lab1.font = [UIFont systemFontOfSize:18];
    _v1Lab1.text = @"40.15";
    [_view1 addSubview:_v1Lab1];
    
    _v1Lab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    _v1Lab2.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    _v1Lab2.font = [UIFont systemFontOfSize:12];
    _v1Lab2.text = @"转让最低价";
    [_view1 addSubview:_v1Lab2];
    
    _v1Lab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    _v1Lab3.textColor = [UIColor colorWithRed:38/255.0 green:185/255.0 blue:254/255.0 alpha:1.0];
    _v1Lab3.font = [UIFont systemFontOfSize:18];
    _v1Lab3.text = @"40.15";
    [_view1 addSubview:_v1Lab3];
    
    _v1Lab4 = [[UILabel alloc] initWithFrame:CGRectZero];
    _v1Lab4.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    _v1Lab4.font = [UIFont systemFontOfSize:12];
    _v1Lab4.text = @"求购最高价";
    [_view1 addSubview:_v1Lab4];
    
    _v1Lab1.translatesAutoresizingMaskIntoConstraints = NO;
    _v1Lab2.translatesAutoresizingMaskIntoConstraints = NO;
    _v1Lab3.translatesAutoresizingMaskIntoConstraints = NO;
    _v1Lab4.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_v1Lab1(==20)]-7-[_v1Lab2(==_v1Lab1)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_v1Lab1, _v1Lab2)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-18-[_v1Lab1]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_v1Lab1)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-18-[_v1Lab2(==70)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_v1Lab2)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_v1Lab2]-10-[_v1Lab3]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_v1Lab2, _v1Lab3)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_v1Lab2]-10-[_v1Lab4]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_v1Lab2, _v1Lab4)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_v1Lab3(==20)]-7-[_v1Lab4(==_v1Lab3)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_v1Lab3, _v1Lab4)]];
    
    
    _v3Lab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    _v3Lab1.textColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45   /255.0 alpha:1.0];
    _v3Lab1.font = [UIFont systemFontOfSize:16];
    _v3Lab1.text = @"翰墨千秋交易平台";
    [_view3 addSubview:_v3Lab1];
    
    _v3Lab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    _v3Lab2.textColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45   /255.0 alpha:1.0];
    _v3Lab2.font = [UIFont systemFontOfSize:14];
    _v3Lab2.text = @"代码 HMQQ365";
    [_view3 addSubview:_v3Lab2];
    
    _v3Lab1.translatesAutoresizingMaskIntoConstraints = NO;
    _v3Lab2.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_v3Lab1(==20)]-7-[_v3Lab2(==_v3Lab1)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_v3Lab1, _v3Lab2)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-18-[_v3Lab1]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_v3Lab1)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-18-[_v3Lab2]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_v3Lab2)]];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

//- (void)bgButtonClicked:(UIButton *)btn {
//    self.bgButtonClicked();
//}

- (void)setShowModel:(NSDictionary *)model{
    _v1Lab1.text = [NSString stringWithFormat:@"%@", [model objectForKey:@"minPrice"]];
    _v1Lab3.text = [NSString stringWithFormat:@"%@", [model objectForKey:@"maxPrice"]];;
    
    _v3Lab1.text = [model objectForKey:@"name"];
    _v3Lab2.text = [NSString stringWithFormat:@"%@ %@", @"代码", [model objectForKey:@"code"]];
}

@end
