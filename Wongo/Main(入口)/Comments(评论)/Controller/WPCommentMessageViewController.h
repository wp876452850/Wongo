//
//  WPCommentMessageViewController.h
//  Wongo
//
//  Created by  WanGao on 2017/7/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPTableBaseViewController.h"
#import "WPCommentModel.h"
#import "WPExchangeDetailModel.h"

@interface WPCommentMessageViewController : WPTableBaseViewController

-(instancetype)initWithCommentModel:(WPCommentModel *)model goodsModel:(WPExchangeDetailModel *)goodsModel commentHeight:(CGFloat)commentHeight upKeyBoard:(BOOL)upKeyBoard;

@end
