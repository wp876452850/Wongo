//
//  WPVarietiesButton.m
//  Wongo
//
//  Created by  WanGao on 2017/10/30.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPVarietiesButton.h"
#import "WPConsignmentClassificationViewController.h"

@interface WPVarietiesButton ()

@property (nonatomic,strong)NSString * varietiesTitle;

@property (nonatomic,strong)UIImage * varietiesImage;

@end


@implementation WPVarietiesButton

-(UIImageView *)varietiesImageView{
    if (!_varietiesImageView) {
        _varietiesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width * 0.65, _varietiesTitleLabel.height>0?self.height-_varietiesTitleLabel.height-10:self.height-20)];
        _varietiesImageView.top = self.varietiesTitleLabel.bottom;
        _varietiesImageView.centerX = self.width/2;
        _varietiesImageView.bottom  = self.height - 10;
        [self addSubview:_varietiesImageView];
    }
    return _varietiesImageView;
}

-(UILabel *)varietiesTitleLabel{
    if (!_varietiesTitleLabel) {
        _varietiesTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _varietiesTitleLabel.font = [UIFont systemFontOfSize:13.f];
        _varietiesTitleLabel.centerX = self.width/2;
        _varietiesTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_varietiesTitleLabel];
    }
    return _varietiesTitleLabel;
}

-(instancetype)initWithImage:(UIImage *)image title:(NSString *)title frame:(CGRect)frame{
    if (self = [super init]) {
        self = [WPVarietiesButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;
        self.varietiesTitle = title;
        self.varietiesImage = image;
        [self addTarget:self action:@selector(goConsignmentClass) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setVarietiesImage:(UIImage *)varietiesImage{
    _varietiesImage = varietiesImage;
    if (_varietiesImage) {
        self.varietiesImageView.image = varietiesImage;
    }
}

-(void)setVarietiesTitle:(NSString *)varietiesTitle{
    _varietiesTitle = varietiesTitle;
    if (varietiesTitle.length>0) {
        self.varietiesTitleLabel.text = varietiesTitle;
    }
}

-(void)goConsignmentClass{
    WPConsignmentClassificationViewController * vc = [[WPConsignmentClassificationViewController alloc]initWithGcname:self.varietiesTitle];
    [[self findViewController:self].navigationController pushViewControllerAndHideBottomBar:vc animated:YES];
}
@end
