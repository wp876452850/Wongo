//
//  WPListFirstTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPListFirstTableViewCell.h"
#import "WPListModel.h"
#import "WPStoreViewController.h"

@interface WPListFirstTableViewCell ()
{
    NSInteger _oneNumber;
    NSInteger _twoNumber;
    NSInteger _threeNumber;
}
/**3个头像*/
@property (weak, nonatomic) IBOutlet UIImageView *one;
@property (weak, nonatomic) IBOutlet UIImageView *two;
@property (weak, nonatomic) IBOutlet UIImageView *three;
/**三个名字框*/
@property (nonatomic,strong)UILabel * oneLabel;
@property (nonatomic,strong)UILabel * twoLabel;
@property (nonatomic,strong)UILabel * threeLabel;
/**三个点赞按钮*/
@property (weak, nonatomic) IBOutlet UIButton *twobutton;
@property (weak, nonatomic) IBOutlet UIButton *onebutton;
@property (weak, nonatomic) IBOutlet UIButton *threebutton;
/**三个点赞数框*/
@property (weak, nonatomic) IBOutlet UILabel *onenumber;
@property (weak, nonatomic) IBOutlet UILabel *twonumber;
@property (weak, nonatomic) IBOutlet UILabel *threenumber;

@end
@implementation WPListFirstTableViewCell

-(UILabel *)oneLabel{
    if (!_oneLabel) {
        _oneLabel = [[UILabel alloc]init];
        _oneLabel.bounds = CGRectMake(0, 0, _one.width, 40);
        _oneLabel.x = 0;
        _oneLabel.bottom = _one.height;
        _oneLabel.textAlignment = NSTextAlignmentCenter;
        _oneLabel.clipsToBounds = YES;
        _oneLabel.text = @"蛇皮袋";
        _oneLabel.font = [UIFont systemFontOfSize:13.f];
        _oneLabel.textColor = WhiteColor;
        
        UILabel * bg = [[UILabel alloc]initWithFrame:_oneLabel.frame];
        bg.backgroundColor = ColorWithRGB(0, 0, 0);
        bg.alpha = 0.4f;
        bg.clipsToBounds = YES;
        [_one addSubview:bg];
    }
    return _oneLabel;
}
-(UILabel *)twoLabel{
    if (!_twoLabel) {
        _twoLabel = [[UILabel alloc]init];
        _twoLabel.bounds = CGRectMake(0, 0, _two.width, 30);
        _twoLabel.x = 0;
        _twoLabel.bottom = _two.height;
        _twoLabel.textAlignment = NSTextAlignmentCenter;
        _twoLabel.clipsToBounds = YES;
        _twoLabel.text = @"蛇皮袋";
        _twoLabel.font = [UIFont systemFontOfSize:11.f];
        _twoLabel.textColor = WhiteColor;
        
        UILabel * bg = [[UILabel alloc]initWithFrame:_twoLabel.frame];
        bg.backgroundColor = ColorWithRGB(0, 0, 0);
        bg.alpha = 0.4f;
        bg.clipsToBounds = YES;
        [_two addSubview:bg];
    }
    return _twoLabel;
}
-(UILabel *)threeLabel{
    if (!_threeLabel) {
        _threeLabel = [[UILabel alloc]init];
        _threeLabel.bounds = CGRectMake(0, 0, _three.width, 30);
        _threeLabel.x = 0;
        _threeLabel.bottom = _three.height;
        _threeLabel.textAlignment = NSTextAlignmentCenter;
        _threeLabel.clipsToBounds = YES;
        _threeLabel.text = @"蛇皮袋";
        _threeLabel.font = [UIFont systemFontOfSize:11.f];
        _threeLabel.textColor = WhiteColor;
        
        UILabel * bg = [[UILabel alloc]initWithFrame:_threeLabel.frame];
        bg.backgroundColor = ColorWithRGB(0, 0, 0);
        bg.alpha = 0.4f;
        bg.clipsToBounds = YES;
        [_three addSubview:bg];
    }
    return _threeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _one.layer.masksToBounds    = YES;
    _one.layer.cornerRadius     = _one.height/2;
    _two.layer.masksToBounds    = YES;
    _two.layer.cornerRadius     = _two.height/2;
    _three.layer.masksToBounds  = YES;
    _three.layer.cornerRadius   = _three.height/2;
    
    [_onebutton setImage:[UIImage imageNamed:@"listthumup_normal"] forState:UIControlStateNormal];
    [_onebutton setImage:[UIImage imageNamed:@"listthumup_orange"] forState:UIControlStateSelected];
    [_twobutton setImage:[UIImage imageNamed:@"listthumup_normal"] forState:UIControlStateNormal];
    [_twobutton setImage:[UIImage imageNamed:@"listthumup_yellow"] forState:UIControlStateSelected];
    [_threebutton setImage:[UIImage imageNamed:@"listthumup_normal"] forState:UIControlStateNormal];
    [_threebutton setImage:[UIImage imageNamed:@"listthumup_blue"] forState:UIControlStateSelected];
    
    
    [_one addSubview:self.oneLabel];
    [_two addSubview:self.twoLabel];
    [_three addSubview:self.threeLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_one addGestureRecognizer:tap];
    [_two addGestureRecognizer:tap1];
    [_three addGestureRecognizer:tap2];
    
}

-(void)tap:(UITapGestureRecognizer *)tap{
    WPListModel * model = [WPListModel mj_objectWithKeyValues:_dataSourceArray[tap.view.tag]];
    WPStoreViewController * vc = [[WPStoreViewController alloc]initWithUid:model.uid];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (IBAction)thumup:(UIButton *)sender {
     WPListModel * model = [WPListModel mj_objectWithKeyValues:_dataSourceArray[sender.tag]];
    typeof(self) weakSelf = self;
    [self thumbUpGoodsWithSender:sender proid:model.proid addBlock:^{
        switch (sender.tag) {
            case 0:
                weakSelf.onenumber.text = [NSString stringWithFormat:@"%ld",_oneNumber++];
                break;
            case 1:
                weakSelf.twonumber.text = [NSString stringWithFormat:@"%ld",_twoNumber++];
                break;
            default:
                weakSelf.threenumber.text = [NSString stringWithFormat:@"%ld",_threeNumber++];
                break;
        }
    } reduceBlock:^{
        switch (sender.tag) {
            case 0:
                weakSelf.onenumber.text = [NSString stringWithFormat:@"%ld",_oneNumber--];
                break;
            case 1:
                weakSelf.twonumber.text = [NSString stringWithFormat:@"%ld",_twoNumber--];
                break;
            default:
                weakSelf.threenumber.text = [NSString stringWithFormat:@"%ld",_threeNumber--];
                break;
        }
    }];
}


-(void)setDataSourceArray:(NSArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    
    NSInteger dataSourceArrayCount = dataSourceArray.count;
    if (dataSourceArrayCount >= 3) {
        dataSourceArrayCount = 3;
    }
    for (int i = 0; i < dataSourceArrayCount; i++) {
        WPListModel * model = [WPListModel mj_objectWithKeyValues:dataSourceArray[i]];
        NSString * imageName = @"";
        if (model.listuser.count > 0) {
            imageName = model.listuser[0][@"url"];
        }
        switch (i) {
            case 0:
            {
                [_one sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"loadimage"]];
                _onenumber.text = model.praise;
                _oneLabel.text = model.uname;
                _oneNumber = [model.praise integerValue];
                
            }break;
            case 1:{               
                [_two sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"loadimage"]];
                _twoLabel.text = model.uname;
                _twonumber.text = model.praise;
                _twoNumber = [model.praise integerValue];
            }
                break;
            case 2:{
                [_three sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"loadimage"]];
                _threeLabel.text = model.uname;
                _threenumber.text = model.praise;
                _threeNumber = [model.praise integerValue];
            }
                break;
        }
    }
}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//}
@end
