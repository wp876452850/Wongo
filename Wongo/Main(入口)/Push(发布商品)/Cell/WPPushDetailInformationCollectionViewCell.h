//
//  WPPushDetailInformationCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/11/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCostomTextField.h"

typedef void(^WPNewPushDetailInformationBlock)(NSString * str);
@interface WPPushDetailInformationCollectionViewCell : UICollectionViewCell
/**输入框限制字数 默认50*/
@property (nonatomic,assign)NSInteger wordsNumber;
//标题
@property (weak, nonatomic) IBOutlet UILabel *title;
//数据
@property (weak, nonatomic) IBOutlet UITextField *data;

@property (nonatomic,strong)UICollectionView * superView;

@property (nonatomic,strong)NSIndexPath * indexPath;

-(void)getTextFieldDataWithBlock:(WPNewPushDetailInformationBlock)block;

@end
