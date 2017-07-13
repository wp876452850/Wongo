//
//  WPOrderDetailTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2016/12/23.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPOrderDetailTableViewCell : UITableViewCell

/**店铺名称*/
@property (weak, nonatomic) IBOutlet UILabel *shopName;
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
/**商品名字*/
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
/**规格*/
@property (weak, nonatomic) IBOutlet UILabel *specifications;
/**数量*/
@property (weak, nonatomic) IBOutlet UILabel *number;
/**价格*/
@property (weak, nonatomic) IBOutlet UILabel *price;
/**总价*/
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/**运费*/
@property (weak, nonatomic) IBOutlet UILabel *freight;
/**合计总价*/
@property (weak, nonatomic) IBOutlet UILabel *settlement;
/**订单号*/
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
/**下单时间*/
@property (weak, nonatomic) IBOutlet UILabel *time;
/**联系卖家*/
@property (weak, nonatomic) IBOutlet UIButton *contactSeller;
/**付款*/
@property (weak, nonatomic) IBOutlet UIButton *payment;


@end
