//
//  WPHotCell.m
//  Wongo
//
//  Created by Winny on 2016/12/9.
//  Copyright © 2016年 Wongo. All rights reserved.
//  主页Cell

#import "WPHotCell.h"
#import "WPExchangeViewController.h"
#import "LoginViewController.h"
#import "WPDreamingDetailViewController.h"


@interface WPHotCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UILabel *collectNumber;
@property (weak, nonatomic) IBOutlet UILabel *projectNumber;

@end
@implementation WPHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_collectButton setImage:[UIImage imageNamed:@"collection_gray_normal"] forState:UIControlStateNormal];
    [_collectButton setImage:[UIImage imageNamed:@"collection_select"] forState:UIControlStateSelected];
    
    _goodsImage.clipsToBounds = YES;
}

-(void)setModel:(WPHomeDataModel *)model{
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"------%@------",error);
    }];
    
    _model                  = model;
    _goodsName.text         = model.gname;
    _collectButton.selected = model.collection;
    _collectNumber.text     = model.collectNumber;
    _projectNumber.text     = [NSString stringWithFormat:@"￥%@",model.price];
}
//点赞
- (IBAction)collect:(UIButton *)sender {
    
    [[self findViewController:self]showAlertNotOpenedWithBlock:nil];
    return;
    
    if (![self determineWhetherTheLogin]) {
        [[self findViewController:self] showAlertWithAlertTitle:@"提示" message:@"您需要登陆后才能进行收藏" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定",@"取消"] block:^{
            LoginViewController * vc = [[LoginViewController alloc]init];
            [[self findViewController:self].navigationController pushViewController:vc animated:YES];
        }];
        return;
    }
    
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isDreamingGoods) {
        WPDreamingDetailViewController * vc = [WPDreamingDetailViewController createDreamingDetailWithProid:_model.proid subid:_model.subid];
        [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
        return;
    }
    if (!_model.gid.length) {
        return;
    }
    WPExchangeViewController * vc   = [WPExchangeViewController createExchangeGoodsWithUrlString:ExchangeDetailGoodsUrl params:@{@"gid":_model.gid} fromOrder:NO];
    [vc showExchangeBottomView];
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
}

@end
