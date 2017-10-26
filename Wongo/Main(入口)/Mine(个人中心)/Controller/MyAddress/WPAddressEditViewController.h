//
//  WPAddressEditViewController.h
//  Wongo
//
//  Created by rexsu on 2016/12/26.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,WPAddressManageStyle)
{
    WPAddressEditStyle   = 0,                    //编辑样式
    WPAddressNewStyle    = 1                     //新建样式
};

typedef void(^selectBlock)(NSString *recipient,NSString *phone,NSString *address,NSString *detailAddress,NSInteger adid);

@interface WPAddressEditViewController : UIViewController
@property (nonatomic,strong)selectBlock saveBlock;
@property (nonatomic,assign)BOOL isPresent;
-(instancetype)initWithStyle:(WPAddressManageStyle)style dateSource:(NSDictionary *)dateSource;

@end
