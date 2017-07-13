//
//  WPDreamingDescribeTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2017/3/3.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WPPushDescribeBlock)(NSString * str);
@interface WPDreamingDescribeTableViewCell : UITableViewCell
@property (nonatomic,assign)NSInteger rowHeight;
//描述textView文字改变时调用回调
-(void)getDescribeBlockWithBlock:(WPPushDescribeBlock)block;
@end
