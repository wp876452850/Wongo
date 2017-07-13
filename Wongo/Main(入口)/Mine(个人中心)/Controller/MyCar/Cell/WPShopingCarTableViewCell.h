//
//  WPShopingCarTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2016/12/19.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPShoppingCarModel.h"
typedef void(^WPNumberChangeBlock)(NSInteger number);
typedef void(^WPSelectChangeBlock)(BOOL select);

@interface WPShopingCarTableViewCell : UITableViewCell
/**勾选按钮*/
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
/**商品名*/
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
/**价格*/
@property (weak, nonatomic) IBOutlet UILabel *price;
/**商品数量*/
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber;
/**减少按钮*/
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
/**增加按钮*/
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
/**删除按钮*/
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

-(void)showDataWithModel:(WPShoppingCarModel *)model;
-(void)numberWithAddBlock:(WPNumberChangeBlock)block;
-(void)numberWithCutBlock:(WPNumberChangeBlock)block;
-(void)cellSelctWithBlock:(WPSelectChangeBlock)block;

@end
