//
//  WPAddressManageTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2016/12/26.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPAddressModel.h"


typedef void(^DeleteAddressBlock)(void);
@interface WPAddressManageTableViewCell : UITableViewCell

/**勾选按钮*/
@property (weak, nonatomic) IBOutlet UIButton *select;

@property (nonatomic,strong) WPAddressModel* model;

-(void)deleteAddressWithBlock:(DeleteAddressBlock)block;
@end
