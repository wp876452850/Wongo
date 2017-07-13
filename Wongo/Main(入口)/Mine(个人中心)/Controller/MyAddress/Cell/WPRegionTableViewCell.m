//
//  WPRegionTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2016/12/27.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "WPRegionTableViewCell.h"
#import "CityPickView.h"

@interface WPRegionTableViewCell ()
{
    
}
@property (nonatomic,strong)CityPickView *cityPickView;

@property (nonatomic,strong)BackAddressData backAddressDataBlock;

@property (nonatomic,strong)CancelChangeAddress cancelBlock;
@end
@implementation WPRegionTableViewCell

-(void)cityViewAction{
    self.textField.inputView = self.cityPickView;
}

-(CityPickView *)cityPickView{
    if (!_cityPickView) {
        _cityPickView = [[CityPickView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 256)];
        NSString * str;
        if (self.initialAddress) {
            self.region.text= self.initialAddress;
            str = self.initialAddress;
        }else{
            str = @"北京市北京市东城区";
        }
        _cityPickView.address = [str getStringSegmentationRegionWithString:str];
        //设置默认城市，弹出之后显示的是这个
        _cityPickView.backgroundColor = [UIColor whiteColor];//设置背景颜色
        _cityPickView.toolshidden = NO; //默认是显示的，如不需要，toolsHidden设置为yes
        
        
        //点击确定按钮回调
        __block WPRegionTableViewCell * selfCell = self;
        _cityPickView.doneBlock = ^(NSString *proVince,NSString *city,NSString *area){
            selfCell.region.text = [NSString stringWithFormat:@"%@%@%@",proVince,city,area];
            if (selfCell.backAddressDataBlock) {
                selfCell.backAddressDataBlock(selfCell.region.text);
            }
        };
        _cityPickView.cancelblock = ^(){
            if (selfCell.cancelBlock) {
                selfCell.cancelBlock();
            }
            
        };

    }
    return _cityPickView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UILabel * title = [[UILabel alloc]init];
        [self.contentView addSubview:title];
        self.region = [[UILabel alloc]init];
        _textField = [[UITextField alloc]init];
        [self.contentView addSubview:_textField];
        [self.contentView addSubview:self.region];
        title.text = @"收货地址:";
        title.font = [UIFont systemFontOfSize:15];
        CGSize size = [title.text getSizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 0)];
        _region.font =[UIFont systemFontOfSize:15];
        _region.backgroundColor = [UIColor whiteColor];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(size.width+4);
            make.height.mas_equalTo(30);
        }];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(title.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
        }];
        [_region mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(title.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

-(void)getAddressDataWithBlock:(BackAddressData)block
{
    _backAddressDataBlock = block;
}
-(void)cancelChangeAddress:(CancelChangeAddress)block{
    _cancelBlock = block;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
