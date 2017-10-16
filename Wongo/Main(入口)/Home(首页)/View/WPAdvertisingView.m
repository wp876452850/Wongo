//
//  WPAdvertisingView.m
//  Wongo
//
//  Created by  WanGao on 2017/7/31.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPAdvertisingView.h"

@interface WPAdvertisingView ()
@property (nonatomic,strong)UIImageView * advertisingImageView;
@property (nonatomic,strong)UIButton * passButton;
@property (nonatomic,strong)NSTimer * timer;
/**记录读秒时间*/
@property (nonatomic,assign)NSInteger seconds;
@end
@implementation WPAdvertisingView
#pragma mark -懒加载
-(UIImageView *)advertisingImageView{
    if (!_advertisingImageView) {
        _advertisingImageView = [[UIImageView alloc]initWithFrame:self.frame];
        _advertisingImageView.backgroundColor = WhiteColor;
        //广告图
        _advertisingImageView.image = [UIImage imageNamed:@"advertisingfigure.jpg"];
        _advertisingImageView.userInteractionEnabled = YES;
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 44, 30, 15)];
        label.text = @"广告";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor blackColor];
        label.textColor = WhiteColor;
        label.alpha = 0.7;
        label.centerY = _passButton.centerY;
        [_advertisingImageView addSubview:label];
    }
    return _advertisingImageView;
}

-(UIButton *)passButton{
    if (!_passButton) {
        _passButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _passButton.alpha = 0.7;
        _passButton.frame = CGRectMake(WINDOW_WIDTH - 85, WINDOW_HEIGHT - 44, 70, 25);
        _passButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _passButton.layer.masksToBounds = YES;
        _passButton.layer.cornerRadius = 12.5f;
        [_passButton addTarget:self action:@selector(pass) forControlEvents:UIControlEventTouchUpInside];
        [_passButton setBackgroundColor:[UIColor blackColor]];
        [_passButton setTitle:@"跳过(5)" forState:UIControlStateNormal];
        [_passButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    }
    return _passButton;
}

#pragma mark -init
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
        [self addSubview:self.passButton];
        [self addSubview:self. advertisingImageView];
        [self bringSubviewToFront:self.passButton];
    }
    return self;
}
#pragma mark -loadData
-(void)loadData{
    
    //获取广告图片
    [WPNetWorking createPostRequestMenagerWithUrlString:@"" params:@{} datas:^(NSDictionary *responseObject) {
        
    }];
}
#pragma mark -willMoveToSuperview
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timing) userInfo:nil repeats:YES];
}
//跳过
-(void)pass{
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:1.f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
//计时
-(void)timing{
    if (self.seconds>=6) {
        [self pass];
        return;
    }
    [self.passButton setTitle:[NSString stringWithFormat:@"跳过(%ld)",5 - self.seconds] forState:UIControlStateNormal];
    self.seconds ++;
}


@end




