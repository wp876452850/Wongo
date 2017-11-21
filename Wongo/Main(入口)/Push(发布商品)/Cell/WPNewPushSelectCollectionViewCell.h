//
//  WPNewPushSelectCollectionViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/11/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WPNewPushSelectBlock)(NSString * string ,NSString * gcid);
@interface WPNewPushSelectCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic,strong)NSArray * selectDataArray;
@property (nonatomic,strong)NSString * url;


-(void)getSelectWithBlock:(WPNewPushSelectBlock)block;
@end
