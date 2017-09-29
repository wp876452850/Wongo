//
//  WPReportBoxTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/9/28.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPReportBoxTableViewCell.h"

@implementation WPReportBoxTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.selectButton setImage:[UIImage imageNamed:@"select_normal_address"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"select_select_address"] forState:UIControlStateSelected];
}
- (IBAction)select:(UIButton *)sender {
    sender.selected = !sender.selected;
}


@end
