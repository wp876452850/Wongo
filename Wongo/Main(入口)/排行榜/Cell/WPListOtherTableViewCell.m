//
//  WPListOtherTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPListOtherTableViewCell.h"
#import "WPCustomButton.h"
#import "WPStoreViewController.h"

@interface WPListOtherTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *thumup;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
@implementation WPListOtherTableViewCell

-(void)setModel:(WPListModel *)model{
    _model = model;
    NSString * imageName = @"";
    if (model.listuser.count>0) {
        imageName = model.listuser[0][@"url"];
    }
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    
    if (model.praise.length > 0) {
        self.number.text = model.praise;
    }
    else{
        self.number.text = @"0";
    }
    self.name.text = model.uname;
    if ([self thumUpDreamingWithinArrayContainsProid:_model.proid]) {
        _thumup.selected = YES;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 30;
    
    [_thumup setImage:[UIImage imageNamed:@"listthumup_normal"] forState:UIControlStateNormal];
    [_thumup setImage:[UIImage imageNamed:@"listthumup_black"] forState:UIControlStateSelected];
}

- (IBAction)thumup:(UIButton *)sender {
    typeof(self) weakSelf = self;
    [self thumbUpGoodsWithSender:_thumup proid:_model.proid addBlock:^{
        weakSelf.number.text = [NSString stringWithFormat:@"%ld", [weakSelf.number.text integerValue]+1];
    } reduceBlock:^{
        weakSelf.number.text = [NSString stringWithFormat:@"%ld", [weakSelf.number.text integerValue]-1];
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WPStoreViewController * vc = [[WPStoreViewController alloc]initWithUid:_model.uid];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
@end
