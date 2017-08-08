
//
//  WPProductDetailUserStoreTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPProductDetailUserStoreTableViewCell.h"


@interface WPProductDetailUserStoreTableViewCell ()
{
    RowHeightBlock _rowHeightBlock;
}
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UILabel *uname;
@property (weak, nonatomic) IBOutlet UILabel *other;
@property (weak, nonatomic) IBOutlet UIButton *collect;
@property (weak, nonatomic) IBOutlet UILabel *line;

@end
@implementation WPProductDetailUserStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headPortrait.layer.masksToBounds = YES;
    self.headPortrait.layer.cornerRadius = 30;
    self.collect.layer.masksToBounds = YES;
    self.collect.layer.cornerRadius = 5;
    self.collect.layer.borderColor = AllBorderColor.CGColor;
    self.collect.layer.borderWidth = 1.f;
    [self.collect setTitle:@"关注" forState:UIControlStateNormal];
    [self.collect setTitle:@"取消关注" forState:UIControlStateSelected];
    [self.collect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.collect setTitleColor:ColorWithRGB(3, 74, 107) forState:UIControlStateSelected];
}

- (IBAction)collect:(UIButton *)sender {
    [[self findViewController:self] showAlertNotOpenedWithBlock:nil];
    return;
    sender.selected = !sender.selected;
    [self focusOnTheUserWithSender:sender uid:_model.uid];
    
}

-(void)setModel:(WPUserIntroductionModel *)model{
    [self.headPortrait sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    self.uname.text = model.uname;
    self.other.text = model.signature;
    self.collect.selected = [model.collect floatValue];
    //判断是否有其他推荐，没有则返回分割线位置
    if (_rowHeightBlock) {
        _rowHeightBlock(self.line.bottom);
    }
}

-(void)getRowHeightWithBlock:(RowHeightBlock)block{
    _rowHeightBlock = block;
}


@end
