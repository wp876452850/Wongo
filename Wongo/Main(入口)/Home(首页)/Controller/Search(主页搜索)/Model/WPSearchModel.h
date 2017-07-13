//
//  WPSearchModel.h
//  Wongo
//
//  Created by rexsu on 2017/2/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPSearchModel : NSObject
/**一级分类id*/
@property (nonatomic,strong)NSString * cid;
/**一级分类名*/
@property (nonatomic,strong)NSString * cname;
/**一级分类名*/
@property (nonatomic,strong)NSArray * listgc;
/**二级分类id*/
@property (nonatomic,strong)NSString * gcid;
/**二级分类名*/
@property (nonatomic,strong)NSString * gcname;
/**图片*/
@property (nonatomic,strong)NSString * url;
@end
