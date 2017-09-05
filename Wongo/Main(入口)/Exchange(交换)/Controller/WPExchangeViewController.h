//
//  WPExchangeViewController.h
//  Wongo
//
//  Created by rexsu on 2017/3/16.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPExchangeViewController : UIViewController
@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)UITableView            * tableView;
+(instancetype)createExchangeGoodsWithUrlString:(NSString *)url params:(NSDictionary *)params fromOrder:(BOOL)fromOrder;

-(void)showExchangeBottomView;
-(void)showShoppingBottomView;
@end
