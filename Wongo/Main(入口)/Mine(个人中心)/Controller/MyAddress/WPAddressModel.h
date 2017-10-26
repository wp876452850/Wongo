//
//  WPAddressModel.h
//  Wongo
//
//  Created by rexsu on 2017/4/26.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPAddressModel : NSObject
/**名字*/
@property (nonatomic,strong)NSString * consignee;
/**地址*/
@property (nonatomic,strong)NSString * address;
/**电话号码*/
@property (nonatomic,strong)NSString * phone;
/**地址编号*/
@property (nonatomic,assign)NSInteger adid;
/**是否默认地址*/
@property (nonatomic,strong)NSString * state;
@end
