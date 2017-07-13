//
//  WPSearchUserModel.h
//  Wongo
//
//  Created by rexsu on 2017/2/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPSearchUserModel : NSObject
///
//用户:对象用户
///

//头像Url
@property (nonatomic,strong)NSString * url;
//用户名
@property (nonatomic,strong)NSString * uname;
//用户签名档
@property (nonatomic,strong)NSString * signature;
//用户粉丝数量
@property (nonatomic,strong)NSString * fansNumber;
//用户商品数量
@property (nonatomic,strong)NSString * goodsNum;
//是否关注用户
@property (nonatomic,strong)NSString * attention;
//用户唯一识别ID
@property (nonatomic,strong)NSString * uid;
@end
