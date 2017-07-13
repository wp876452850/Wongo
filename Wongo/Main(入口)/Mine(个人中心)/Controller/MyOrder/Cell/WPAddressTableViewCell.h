//
//  WPAddressTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2016/12/22.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPAddressTableViewCell : UITableViewCell
/**收件人*/
@property (weak, nonatomic) IBOutlet UILabel *recipient;
/**电话*/
@property (weak, nonatomic) IBOutlet UILabel *phone;
/**地址*/
@property (weak, nonatomic) IBOutlet UILabel *address;

@end
