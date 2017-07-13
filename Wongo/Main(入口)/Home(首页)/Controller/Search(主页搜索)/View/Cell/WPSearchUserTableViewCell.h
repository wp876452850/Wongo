//
//  WPSearchUserTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2017/2/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPSearchUserModel.h"

typedef void(^ChatBlock)(NSString * userID);
@interface WPSearchUserTableViewCell : UITableViewCell
@property (nonatomic,strong)WPSearchUserModel * model;
-(void)goChatWithBlock:(ChatBlock)block;
@end
