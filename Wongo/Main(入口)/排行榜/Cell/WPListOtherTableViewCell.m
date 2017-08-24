//
//  WPListOtherTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPListOtherTableViewCell.h"
#import "WPCustomButton.h"

@interface WPListOtherTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (nonatomic,strong)UILabel * name;
@property (weak, nonatomic) IBOutlet UIButton *thumup;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
@implementation WPListOtherTableViewCell

-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.bounds = CGRectMake(0, 0, 200, 20);
        _name.y = _headerImage.y + 5;
        _name.x = _headerImage.right + 5;
    }
    return _name;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 30;
    
    
    [self.contentView addSubview:self.name];
    [_thumup setImage:[UIImage imageNamed:@"listthumup_normal"] forState:UIControlStateNormal];
    [_thumup setImage:[UIImage imageNamed:@"listthumup_black"] forState:UIControlStateSelected];
}

- (IBAction)thumup:(UIButton *)sender {
    _thumup.selected = !_thumup.selected;
}

@end
