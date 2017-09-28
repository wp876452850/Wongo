//
//  WPDreamingDetailViewController.h
//  Wongo
//
//  Created by rexsu on 2017/2/27.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情页

#import <UIKit/UIKit.h>
#import "WPDreamingModel.h"

@interface WPDreamingDetailViewController : UIViewController

/**
 @param proid 商品id
 @param subid 主题id
 */
@property (nonatomic,strong)WPDreamingModel * model;
+(instancetype)createDreamingDetailWithProid:(NSString *)proid plid:(NSString *)plid;

@end
