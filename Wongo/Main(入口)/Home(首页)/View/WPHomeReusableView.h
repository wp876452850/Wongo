//
//  WPHomeReusableView.h
//  Wongo
//
//  Created by rexsu on 2017/2/8.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPHomeReusableModel.h"
#import "WPDreamingMainGoodsModel.h"

@interface WPHomeReusableView : UICollectionReusableView
@property (nonatomic,strong)WPHomeReusableModel * model;
@property (nonatomic,strong)WPDreamingMainGoodsModel * dreamingMainGoodsModel;


@end
