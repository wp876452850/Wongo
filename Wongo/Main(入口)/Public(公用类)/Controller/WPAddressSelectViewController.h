//
//  WPAddressSelectViewController.h
//  Wongo
//
//  Created by rexsu on 2017/3/23.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPAddressModel.h"
#import "LYBaseController.h"

typedef void(^SelectAddressBlock)(WPAddressModel* address);

@interface WPAddressSelectViewController : LYBaseController

-(void)getAdidAndAddressWithBlock:(SelectAddressBlock)block;

@end
