//
//  WPDreamingDetailRecommendTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/9/29.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingDetailRecommendTableViewCell.h"
#import "WPDreamingDetailRecommendPageViewController.h"

@implementation WPDreamingDetailRecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (IBAction)goRecommend:(UIButton *)sender
{
    WPDreamingDetailRecommendPageViewController * vc = [[WPDreamingDetailRecommendPageViewController alloc]initWithCurrentPage:sender.tag];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}

@end
