//
//  WPStroeDreamingCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPStroeDreamingCollectionViewCell.h"
#import "WPDreamingDetailViewController.h"

#define States @[@"未开始",@"进行中"]
@interface WPStroeDreamingCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UITextView *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIButton *thumup;

@end
@implementation WPStroeDreamingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.thumup setImage:[UIImage imageNamed:@"shopDreamingthumup_normal"] forState:UIControlStateNormal];
    [self.thumup setImage:[UIImage imageNamed:@"shopDreamingthumup_select"] forState:UIControlStateSelected];
}

-(void)setModel:(WPStroeDreamingModel *)model{
    _model = model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    _goodsName.text = model.proname;
    _state.text = States[[model.isrecommend integerValue]];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WPDreamingDetailViewController * vc = [WPDreamingDetailViewController createDreamingDetailWithProid:_model.proid plid:_model.plid];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
- (IBAction)thumup:(id)sender {
    
}

@end
