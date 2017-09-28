//
//  WPHomeDreamingCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPHomeDreamingCollectionViewCell.h"
#import "WPDreamingDirectoryModel.h"
#import "WPDreamingDetailViewController.h"

@interface WPHomeDreamingCollectionViewCell ()
//指示图标
@property (nonatomic,strong)UIImageView * instructions;
@property (weak, nonatomic) IBOutlet UIImageView *nowGoods;
//目标商品
@property (weak, nonatomic) IBOutlet UIImageView *targetGoods;

@end
@implementation WPHomeDreamingCollectionViewCell

-(UIImageView *)instructions{
    if (!_instructions) {
        _instructions = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"positioning"]];
        
    }
    return _instructions;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _nowGoods.layer.masksToBounds = YES;
    _nowGoods.layer.cornerRadius = _nowGoods.height/2;
    
    [self.nowGoods sd_setImageWithURL:[NSURL URLWithString:@"http://119.23.32.206:8080/change/image/SLHSZ4.jpg"] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    [self.targetGoods sd_setImageWithURL:[NSURL URLWithString:@"http://119.23.32.206:8080/change/image/02715425324820170922151724165231.jpg"] placeholderImage:[UIImage imageNamed:@"loadimage"]];
}

-(void)setUrl:(NSString *)url{
    _url = url;
//    [self.nowGoods sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    [self.nowGoods sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"loadimage"]];
}

-(void)setModel:(WPDreamingDirectoryModel *)model{
    _model = model;
//     [self.nowGoods sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [[self findViewController:self] showAlertNotOpenedWithBlock:nil];
//    return;
    WPDreamingDetailViewController * vc = [WPDreamingDetailViewController createDreamingDetailWithProid:_model.proid plid:_model.plid];
//    WPDreamingDetailViewController * vc = [WPDreamingDetailViewController createDreamingDetailWithProid:self.proid plid:self.plid];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
@end
