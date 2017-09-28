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
#define ActivityIcons       @[@"activities_green",@"activities_yellow",@"activities_blue"]
#define ActivityColors      @[WongoActivitGreenColor,WongoActivitYellowColor,WongoActivitBlueColor]
#define ThumupIcon_Normal @[@"thumup_green_normal",@"thumup_yellow_normal",@"thumup_blue_normal"]
#define ThumupIcon_Select @[@"thumup_green_select",@"thumup_yellow_select",@"thumup_blue_select"]

@interface WPActivityGoodsCollectionViewCell ()

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
    
    [self.thumup setImage:[UIImage imageNamed:ThumupIcon_Normal[activityState]] forState:UIControlStateNormal];
    [self.thumup setImage:[UIImage imageNamed:ThumupIcon_Select[activityState]] forState:UIControlStateSelected];
    [self.thumup setTitleColor:color forState:UIControlStateNormal];
    
    self.activityIcon.image = [UIImage imageNamed:ActivityIcons[activityState]];
}

-(void)setModel:(WPExchangeModel *)model{
    _model = model;
    _goodsName.text = model.gname;
    [_goodsImageOne sd_setImageWithURL:model.listimg[0][@"url"] placeholderImage:[UIImage imageNamed:@"loadimage"]];
    
    self.price.attributedText = [WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc] initWithString:model.price] insertImage:[UIImage imageNamed:@"goodsprice"] atIndex:0 imageBounds:CGRectMake(0, -2, 12.5, 25)];
}
- (IBAction)thumup:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)goExchange:(id)sender
{
    WPExchangeViewController * vc = [WPExchangeViewController createExchangeGoodsWithParams:@{@"gid":_model.gid}];
    vc.activityState = _activityState + 1;
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
    
}

@end
