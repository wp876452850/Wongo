//
//  WPPushDetailInformationCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/11/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCostomTextField.h"


@interface WPPushDetailInformationCollectionViewCell : UICollectionViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *title;
//数据
@property (weak, nonatomic) IBOutlet WPCostomTextField *data;

@end
