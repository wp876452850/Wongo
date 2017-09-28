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
@property (nonatomic,assign)NSInteger activityState;
/**旧方法(已废弃)*/
+(instancetype)createExchangeGoodsWithUrlString:(NSString *)url params:(NSDictionary *)params fromOrder:(BOOL)fromOrder;

/**
 初始化方法
 @param params 参数
 @return id
 */
+(instancetype)createExchangeGoodsWithParams:(NSDictionary *)params;

-(void)showExchangeBottomView;
-(void)showShoppingBottomView;


@end
