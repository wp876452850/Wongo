//
//  WPHomeReusableModel.h
//  Wongo
//
//  Created by rexsu on 2017/2/8.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPHomeReusableModel : NSObject
//图标名
@property (nonatomic,strong)NSString * icon_name;
//图标中文名
@property (nonatomic,strong)NSString * title_e;
//图标英文名
@property (nonatomic,strong)NSString * title_c;
//价格
@property (nonatomic,strong)NSString * price;

@property (nonatomic,strong)UIColor * titleColor;

@end
