//
//  WPExchangeCommodityInformationCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPExchangeCommodityInformationCell.h"
#import "LYActivityController.h"

#define ActivityStateTitle @[@"",@"本商品已参与分享换新活动",@"本商品已参与公益换新活动",@"本商品已参与闲置换新活动"]
#define ActivityStateIcon @[@"",@"goodsfenxiang",@"goodsgongyi",@"goodsxianzhi"]

@interface WPExchangeCommodityInformationCell ()
{
    NSInteger _freightNumber;
}
/**收藏数*/
@property (weak, nonatomic) IBOutlet UILabel *collectionNumber;
/**商品名*/
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
/**价格*/
@property (weak, nonatomic) IBOutlet UILabel *price;
/**新旧度*/
@property (weak, nonatomic) IBOutlet UILabel *oldNew;
/**收藏*/
@property (weak, nonatomic) IBOutlet UIButton *collectionButoon;
/**活动链接*/
@property (weak, nonatomic) IBOutlet UILabel * activeLink;

@end

@implementation WPExchangeCommodityInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = _activeLink.frame;
    [button addTarget:self action:@selector(jumpActive) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

/**跳转活动页*/
-(void)jumpActive{
    if ([_model.state integerValue] <= 0) {
        return;
    }
    LYHomeCategory *category = self.listhk[[_model.state integerValue] - 1];
    LYActivityController * vc = [LYActivityController controllerWithCategory:category];
    vc.activityState = [_model.state integerValue] - 1;
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}

-(void)setActivityState:(NSInteger)activityState
{
    _activityState = activityState;
    _model.state = [NSString stringWithFormat:@"%ld",activityState];
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:ActivityStateTitle[activityState] attributes:attribtDic];
    //赋值
    _activeLink.userInteractionEnabled = YES;
    _activeLink.attributedText = attribtStr;
    if (activityState!=0) {
            NSAttributedString * attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",_model.gname]];
        _goodsName.attributedText = [WPAttributedString attributedStringWithAttributedString:attributedString insertImage:[UIImage imageNamed:ActivityStateIcon[activityState]] atIndex:0 imageBounds:CGRectMake(0, -1.5, 41, 16)];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_collectionButoon setBackgroundImage:[UIImage imageNamed:@"exchangecollect_normal"] forState:UIControlStateNormal];
    [_collectionButoon setBackgroundImage:[UIImage imageNamed:@"exchangecollect_select"] forState:UIControlStateSelected];
}

-(void)setModel:(WPExchangeDetailModel *)model{
    _model = model;
    
    NSAttributedString * attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",model.gname]];
    if ([model.uid floatValue] == 1 ||[model.uid floatValue] == 2) {
        _goodsName.attributedText = [WPAttributedString attributedStringWithAttributedString:attributedString insertImage:[UIImage imageNamed:@"goodsguangfang"] atIndex:0 imageBounds:CGRectMake(0, -1.5, 41, 16)];
    }else{
         _goodsName.attributedText = [WPAttributedString attributedStringWithAttributedString:attributedString insertImage:[UIImage imageNamed:@"goodsnew"] atIndex:0 imageBounds:CGRectMake(0, -1.5, 41, 16)];
    }
    _oldNew.text    = model.neworold;
    _price.text     = [NSString stringWithFormat:@"￥%ld",[model.price integerValue]];
    
    _freightNumber = [_model.freight integerValue];
    _collectionNumber.text = [NSString stringWithFormat:@"收藏量:%ld",_freightNumber];
    //判断是否登录
    if ([NSMutableArray collectionWithinArrayContainsGid:model.gid]) {
        _collectionButoon.selected = YES;
    }
}
//收藏
- (IBAction)collection:(UIButton *)sender {
    [self collectionOfGoodsWithSender:sender gid:_model.gid chenggongBlock:^{
        _collectionButoon.selected = !_collectionButoon.selected;
    } shibaiBlock:nil];
    if (sender.selected) {
        _freightNumber--;
    }
    else{
        _freightNumber++;
    }
    _collectionNumber.text = [NSString stringWithFormat:@"收藏量:%ld",_freightNumber];
}


@end
