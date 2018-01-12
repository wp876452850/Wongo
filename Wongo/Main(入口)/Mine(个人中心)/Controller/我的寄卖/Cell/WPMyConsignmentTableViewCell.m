//
//  WPMyConsignmentTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/12/8.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPMyConsignmentTableViewCell.h"
#import "WPMyConsignmentSendView.h"

#define States @[@"待寄出",@"已寄出",@"审核中",@"已上架",@""]

@interface WPMyConsignmentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *lName;
@property (weak, nonatomic) IBOutlet UILabel *userPrice;
@property (weak, nonatomic) IBOutlet UILabel *wongoPrice;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation WPMyConsignmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.cornerRadius = 2.f;
    self.backView.layer.cornerRadius = 5.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setModel:(WPMyConsignmentModel *)model{
    _model = model;
    self.lName.text = model.lname;
    _userPrice.text = [NSString stringWithFormat:@"期望报价:￥%@",model.price];
    _wongoPrice.text = [NSString stringWithFormat:@"碗糕报价:%@",@"暂无报价"];
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[self getPlaceholderImage]];
    self.state.text = States[[_model.sign integerValue]];
    if ([_model.sign integerValue]!=0) {
        self.rightButton.hidden = YES;
    }
}

//寄出操作
- (IBAction)jichu:(UIButton *)sender {
    
    //
    WPMyConsignmentSendView * view = [[WPMyConsignmentSendView alloc]initWithLid:_model.lid];
    
    [[self findViewController:self].view addSubview:view];
}

@end
