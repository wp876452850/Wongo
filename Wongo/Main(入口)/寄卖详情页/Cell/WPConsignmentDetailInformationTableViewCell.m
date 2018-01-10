//
//  WPConsignmentDetailInformationTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/12/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPConsignmentDetailInformationTableViewCell.h"

@interface WPConsignmentDetailInformationTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *collectionButoon;
@property (weak, nonatomic) IBOutlet UILabel *collectionNumber;

@end
@implementation WPConsignmentDetailInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_collectionButoon setBackgroundImage:[UIImage imageNamed:@"exchangecollect_normal"] forState:UIControlStateNormal];
    [_collectionButoon setBackgroundImage:[UIImage imageNamed:@"exchangecollect_select"] forState:UIControlStateSelected];
}

- (IBAction)collect:(UIButton *)sender {
    
    
    
}


@end
