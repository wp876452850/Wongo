//
//  WPListModel.h
//  Wongo
//
//  Created by  WanGao on 2017/8/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPListModel : NSObject
/**点赞数*/
@property (nonatomic,strong)NSString * praise;
@property (nonatomic,strong)NSString * uname;
@property (nonatomic,strong)NSString * url;
@property (nonatomic,strong)NSArray  * listuser;
@property (nonatomic,strong)NSString * uid;
@end
