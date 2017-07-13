//
//  WPRegionTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2016/12/27.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^BackAddressData)(NSString * address);
typedef void(^CancelChangeAddress)();

@interface WPRegionTableViewCell : UITableViewCell

@property (nonatomic,strong)UITextField * textField;
@property (nonatomic,strong)UILabel * region;
@property (nonatomic,strong)NSString * initialAddress;
-(void)cityViewAction;
-(void)getAddressDataWithBlock:(BackAddressData)block;
-(void)cancelChangeAddress:(CancelChangeAddress)block;
@end
