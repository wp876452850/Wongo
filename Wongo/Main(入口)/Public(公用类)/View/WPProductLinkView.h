//
//  WPProductLinkView.h
//  Wongo
//
//  Created by  WanGao on 2017/7/27.
//  Copyright © 2017年 Winny. All rights reserved.
//  产品链接图

#import <UIKit/UIKit.h>
#import "WPProductLinkModel.h"
#import "WPExchangeDetailModel.h"


@interface WPProductLinkView : UIView


+(instancetype)productLinkWithModel:(WPExchangeDetailModel *)model frame:(CGRect)frame;

@end
