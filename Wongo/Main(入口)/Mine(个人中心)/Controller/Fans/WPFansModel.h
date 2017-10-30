//
//  WPFansModel.h
//  Wongo
//
//  Created by rexsu on 2017/2/23.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPFansModel : NSObject

@property (nonatomic,strong)NSString * url;

@property (nonatomic,strong)NSString * uname;
//用户签名档
@property (nonatomic,strong)NSString * signature;
//是否关注用户
@property (nonatomic,strong)NSString * attention;
//用户唯一识别ID
@property (nonatomic,strong)NSString * uid;

@end
