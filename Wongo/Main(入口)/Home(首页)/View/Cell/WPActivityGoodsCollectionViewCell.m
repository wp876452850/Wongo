//
//  WPActivityGoodsCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/9/26.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPActivityGoodsCollectionViewCell.h"
#import "WPExchangeViewController.h"

#define ActivityTitles      @[@"分享换新",@"公益换新",@"闲置换新"]
#define ActivityIcons       @[@"activities_blue",@"activities_yellow",@"activities_green"]
#define ActivityColors      @[WongoActivitBlueColor,WongoActivitYellowColor,WongoActivitGreenColor]
#define ThumupIcon_Normal @[@"thumup_blue_normal",@"thumup_yellow_normal",@"thumup_green_normal"]
#define ThumupIcon_Select @[@"thumup_blue_select",@"thumup_yellow_select",@"thumup_green_select"]

@interface WPActivityGoodsCollectionViewCell ()
{
    NSInteger _wantNumber;
    NSInteger _thumUpNumber;
}
@property (weak, nonatomic) IBOutlet UIImageView *activityIcon;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageOne;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *wantExchange;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *thumup;
@property (weak, nonatomic) IBOutlet UIButton *goExchange;

@end
@implementation WPActivityGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.thumup.layer.cornerRadius = 10.f;
    self.goExchange.layer.cornerRadius = 10.f;
    self.thumup.layer.borderWidth = 0.5f;
}

-(void)setActivityState:(NSInteger)activityState{
    _activityState = activityState;
    UIColor * color = ActivityColors[activityState];
    self.thumup.layer.borderColor = color.CGColor;
    self.goExchange.backgroundColor = color;
//    [self.goExchange setTitle:ActivityTitles[activityState] forState:UIControlStateNormal];
    [self.goExchange setTitle:@"参与活动" forState:UIControlStateNormal];
    [self.thumup setImage:[UIImage imageNamed:ThumupIcon_Normal[activityState]] forState:UIControlStateNormal];
    [self.thumup setImage:[UIImage imageNamed:ThumupIcon_Select[activityState]] forState:UIControlStateSelected];
    [self.thumup setTitleColor:color forState:UIControlStateNormal];
    
    self.activityIcon.image = [UIImage imageNamed:ActivityIcons[activityState]];
}

-(void)setModel:(WPExchangeModel *)model{
    _model = model;
    _goodsName.text = model.gname;
    _wantNumber = [model.praise integerValue];
    [_goodsImageOne sd_setImageWithURL:model.listimg[0][@"url"] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    self.wantExchange.text = [NSString stringWithFormat:@"%ld人想换",_wantNumber];
    
    self.price.text = [NSString stringWithFormat:@"￥%ld",[model.price integerValue]];
    if ([NSMutableArray thumUpWithinArrayContainsGid:model.gid]) {
        _thumup.selected = YES;
    }
}
- (IBAction)thumup:(UIButton *)sender {

    [self thumbUpGoodsWithSender:sender gid:_model.gid];
    if (sender.selected) {
        _thumUpNumber--;
    }
    else{
        _thumUpNumber++;
    }
    _wantExchange.text = [NSString stringWithFormat:@"%ld人想换",_thumUpNumber];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WPExchangeViewController * vc = [WPExchangeViewController createExchangeGoodsWithParams:@{@"gid":_model.gid}];
    vc.activityState = _activityState + 1;
    [vc showExchangeBottomView];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
   
}
@end
