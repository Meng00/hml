//
//  HMApiResult.h
//  hml
//
//  Created by 刘学 on 2018/9/15.
//  Copyright © 2018年 翰墨链. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMApiResult : NSObject
/*！
 @property
 @abstract 服务返回的结果
 */
@property int result;
@property int totalPage;
@property int totalCount;

/*!
 @property
 @abstract 返回的信息
 */
@property (strong, nonatomic) NSString *message;

/*!
 @property
 @abstract 返回的数据对象
 */
@property (strong, nonatomic) id value;
@property (strong, nonatomic) id list;
@property (strong, nonatomic) id data;
@end
