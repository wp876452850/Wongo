//
//  WPProductDetailsViewController.h
//  Wongo
//
//  Created by  WanGao on 2017/8/1.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPTableBaseViewController.h"


@interface WPProductDetailsViewController : WPTableBaseViewController
@property (nonatomic,strong)UIView * bottomView;

+(instancetype)productDetailsViewControllerWithGid:(NSString *)gid ;
-(void)showExchangeBottomView;
-(void)showShoppingBottomView;

@end
