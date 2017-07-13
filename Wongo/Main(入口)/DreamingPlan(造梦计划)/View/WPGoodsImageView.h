//
//  WPGoodsImageView.h
//  Wongo
//
//  Created by rexsu on 2017/5/4.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteGoodsImage)(void);

@interface WPGoodsImageView : UIImageView


-(void)getBlock:(DeleteGoodsImage)block;
@end
