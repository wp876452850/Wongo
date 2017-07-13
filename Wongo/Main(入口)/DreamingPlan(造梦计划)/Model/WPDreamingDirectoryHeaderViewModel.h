//
//  WPDreamingDirectoryHeaderViewModel.h
//  Wongo
//
//  Created by rexsu on 2017/5/19.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPDreamingDirectoryHeaderViewModel : NSObject

/**描述*/
@property (nonatomic,strong)NSString * content;
/**造梦商品数(审核通过)*/
@property (nonatomic,strong)NSString * count;
/**商品*/
@property (nonatomic,strong)NSString * listm;
/**造梦人数量*/
@property (nonatomic,strong)NSString * productnum;
/**浏览量*/
@property (nonatomic,strong)NSString * readview;
/**标题*/
@property (nonatomic,strong)NSString * subname;
/**背景图片*/
@property (nonatomic,strong)NSString * url;

@end
