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
}

-(void)setUrl:(NSString *)url{
    _url = url;
    [self.nowGoods sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
}

-(void)setModel:(WPDreamingDirectoryModel *)model{
    _model = model;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [[self findViewController:self] showAlertNotOpenedWithBlock:nil];
//    return;
    WPDreamingDetailViewController * vc = [WPDreamingDetailViewController createDreamingDetailWithProid:self.proid subid:nil];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
@end
