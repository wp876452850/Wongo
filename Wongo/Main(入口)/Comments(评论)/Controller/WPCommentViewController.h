//
//  WPCommentViewController.h
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYBaseController.h"
#import "WPExchangeDetailModel.h"

@interface WPCommentViewController : LYBaseController

-(instancetype)initWithModel:(WPExchangeDetailModel *)model;
@property (nonatomic,strong)ChatKeyBoard * commentKeyBoard;
@end
