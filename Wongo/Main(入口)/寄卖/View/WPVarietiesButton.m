//
//  WPVarietiesButton.m
//  Wongo
//
//  Created by  WanGao on 2017/10/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPVarietiesButton.h"

@interface WPVarietiesButton ()
{
    UIImage * _varietiesImage;
    NSString * _varietiesTitle;
}
//品种图片
@property (nonatomic,strong)UIImageView * varietiesImageVieww;
//品种标题
@property (nonatomic,strong)UILabel * varietiesTitleLabel;


@end

@implementation WPVarietiesButton

-(UIImageView *)varietiesImageVieww{
    if (!_varietiesImageVieww) {
        _varietiesImageVieww = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width * 0.8, self.height * 0.6)];
        _varietiesImageVieww.top = self.varietiesTitleLabel.bottom;
        _varietiesImageVieww.centerX = self.width/2;
        _varietiesImageVieww.bottom  = self.height - 10;
        _varietiesImageVieww.backgroundColor = RandomColor;
    }
    return _varietiesImageVieww;
}

-(UILabel *)varietiesTitleLabel{
    if (!_varietiesTitleLabel) {
        _varietiesTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _varietiesTitleLabel.font = [UIFont systemFontOfSize:14.f];
        _varietiesTitleLabel.centerX = self.width/2;
        _varietiesTitleLabel.backgroundColor = RandomColor;        
    }
    return _varietiesTitleLabel;
}

-(instancetype)initWithImage:(UIImage *)image title:(NSString *)title frame:(CGRect)frame{
    if (self) {
        self = [WPVarietiesButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;
        _varietiesImage = image;
        _varietiesTitle = title;
        [self addSubview:self.varietiesTitleLabel];
        [self addSubview:self.varietiesImageVieww];
        
        
    }
    return self;
}

@end
