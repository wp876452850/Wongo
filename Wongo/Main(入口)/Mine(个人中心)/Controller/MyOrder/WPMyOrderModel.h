//
//  WPMyOrderModel.h
//  Wongo
//
//  Created by rexsu on 2017/5/16.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPMyOrderModel : NSObject
/**寄货人uid*/
@property (nonatomic,strong)NSString * uid;
/**收货地址 */
@property (nonatomic, strong) NSString *address;

/**订单号*/
@property (nonatomic,strong)NSString * ordernum;
/**状态 0:刚生成订单 1:收货人已上交保证金 2:发货人已发货 3:确认收货 4:平台介入 */
@property (nonatomic,assign) int state;
/**订单详细id */
@property (nonatomic,strong)NSString * plodid;
/**订单id*/
@property (nonatomic,strong)NSString * ploid;
/**收货人名*/
@property (nonatomic,strong)NSString * shouname;
/**寄货人店铺/用户名*/
@property (nonatomic,strong)NSString * uname;
/**商品图片*/
@property (nonatomic,strong)NSString * url;
/**商品描述*/
@property (nonatomic,strong)NSString * remark;
/**商品名*/
@property (nonatomic,strong)NSString * proname;

/**发货人商品价格*/
@property (nonatomic,strong)NSString * price;
/**收货人商品的价格 */
@property (nonatomic, assign) CGFloat money;
/**收货人所支付保证金金额 */
@property (nonatomic, assign) CGFloat paymoney;
/**造梦商品新旧程度 */
@property (nonatomic, strong) NSString *neworold;
/**造梦人等级*/
@property (nonatomic,strong)NSString * class_;
/**发布时间*/
@property (nonatomic,strong)NSString * pubtime;
/**商品数量*/
@property (nonatomic,strong)NSString * number;
/**操作标识：1.成功，0失败*/
@property (nonatomic, assign) int flag;
/**发货人ID */
@property (nonatomic, strong) NSString *fromuser;
/**收货人ID */
@property (nonatomic, strong) NSString *touser;
@end
