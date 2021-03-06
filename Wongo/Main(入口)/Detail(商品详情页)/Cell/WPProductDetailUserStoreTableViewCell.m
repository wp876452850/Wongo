
//
//  WPProductDetailUserStoreTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPProductDetailUserStoreTableViewCell.h"
#import "WPStoreViewController.h"


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
    self.headPortrait.layer.cornerRadius = 25;
    self.headPortrait.layer.borderWidth = 0.5f;
    self.headPortrait.layer.borderColor =ColorWithRGB(24, 24, 24).CGColor;
    self.headPortrait.userInteractionEnabled = YES;
    _collect.selected = [self focusOnWithinArrayContainsUid:@"1"]?YES:NO;
    
    self.collect.layer.masksToBounds = YES;
    self.collect.layer.cornerRadius = 5;
    self.collect.layer.borderColor = AllBorderColor.CGColor;
    self.collect.layer.borderWidth = 1.f;
    [self.collect setTitle:@"关注" forState:UIControlStateNormal];
    [self.collect setTitle:@"取消关注" forState:UIControlStateSelected];
    [self.collect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.collect setTitleColor:ColorWithRGB(3, 74, 107) forState:UIControlStateSelected];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.headPortrait addGestureRecognizer:tap];
}

-(void)tap{
    WPStoreViewController * vc = nil;
    if (_model.url.length <=0) {
       vc = [[WPStoreViewController alloc]initWithUid:@"1"];
    }else
    vc = [[WPStoreViewController alloc]initWithUid:_model.uid];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)collect:(UIButton *)sender {
    if (_model.url.length <=0) {
        [self focusOnTheUserWithSender:sender uid:@"1" chenggongBlock:^{
            _collect.selected = !_collect.selected;
        } shibaiBlock:nil];
    }
    else
        [self focusOnTheUserWithSender:sender uid:_model.uid chenggongBlock:^{
            _collect.selected = !_collect.selected;
        } shibaiBlock:nil];
}

-(void)setModel:(WPUserIntroductionModel *)model{
    _model = model;
    [self.headPortrait sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    self.uname.text = model.uname;
    if (model.signature.length > 0) {
        self.other.text = model.signature;
    }
    else{
        self.other.text = @"用户暂无签名";
    }
    //判断是否有其他推荐，没有则返回分割线位置
    if (_rowHeightBlock) {
        _rowHeightBlock(self.line.bottom);
    }
    _collect.selected = [self focusOnWithinArrayContainsUid:_model.uid]?YES:NO;
}

-(void)getRowHeightWithBlock:(RowHeightBlock)block{
    _rowHeightBlock = block;
}


@end
