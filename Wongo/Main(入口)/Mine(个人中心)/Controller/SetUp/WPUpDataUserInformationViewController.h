//
//  WPUpDataUserInformationViewController.h
//  Wongo
//
//  Created by rexsu on 2017/4/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPUpDataUserInformationViewController : UIViewController

typedef void(^UpdateBlock)(NSString * str);
typedef NS_ENUM(NSUInteger,UpdateData)
{
    UpdateUserName              = 0,                    //精选界面样式
    UpdateUserSignature         = 1                     //主页样式
};


-(instancetype)initWithUpdateData:(UpdateData)updateData;
@end
