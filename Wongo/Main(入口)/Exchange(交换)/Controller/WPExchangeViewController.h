//
//  WPExchangeViewController.h
//  Wongo
//
//  Created by rexsu on 2017/3/16.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPExchangeViewController : UIViewController

+(instancetype)createExchangeGoodsWithUrlString:(NSString *)url params:(NSDictionary *)params fromOrder:(BOOL)fromOrder;

@end
