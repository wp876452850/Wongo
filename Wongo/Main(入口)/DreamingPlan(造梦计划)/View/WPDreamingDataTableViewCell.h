//
//  WPDreamingDataTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2017/3/3.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCostomTextField.h"

typedef void(^WPPushDataBlock)(NSString * str);

@interface WPDreamingDataTableViewCell : UITableViewCell
/**输入框限制字数 默认50*/
@property (nonatomic,assign)NSInteger wordsNumber;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet  WPCostomTextField *data;
@property (nonatomic,assign)NSInteger rowHeight;
//信息textField文字改变时调用回调
-(void)getTextFieldDataWithBlock:(WPPushDataBlock)block;
@end
