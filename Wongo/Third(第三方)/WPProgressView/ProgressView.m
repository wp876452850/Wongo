//
//  ProgressView.m
//  圆形进度条
//
//  Created by rexsu on 2017/3/13.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()
@property (nonatomic,strong)UILabel * dataLabel;
@property (nonatomic,strong)UILabel * dataNameLabel;
@end
@implementation ProgressView

-(UILabel *)dataLabel{
    if (!_dataLabel) {
        CGFloat radius                          = MIN(self.bounds.size.width, self.bounds.size.height) - 20;
        _dataLabel                              = [[UILabel alloc]init];
        _dataLabel.bounds                       = CGRectMake(0, 0, radius - 10 ,self.bounds.size.width /4);
        _dataLabel.center                       = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - self.bounds.size.height/8);
        _dataLabel.textColor                    = self.progressColor;
        _dataLabel.text                         = self.data;
        _dataLabel.adjustsFontSizeToFitWidth    = YES;
        _dataLabel.textAlignment                = NSTextAlignmentCenter;
        
    }
    return _dataLabel;
}

-(UILabel *)dataNameLabel{
    if (!_dataNameLabel) {
        CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) - 20;
        _dataNameLabel                              = [[UILabel alloc]init];
        _dataNameLabel.bounds                       = CGRectMake(0, 0, radius - 10 ,self.bounds.size.width /4);
        _dataNameLabel.center                       = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + self.bounds.size.height/8);
        _dataNameLabel.textColor                    = self.progressBackColor;
        _dataNameLabel.text                         = self.dataName;
        _dataNameLabel.adjustsFontSizeToFitWidth    = YES;
        _dataNameLabel.textAlignment                = NSTextAlignmentCenter;
    }
    return _dataNameLabel;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

+(instancetype)createProgressWithFrame:(CGRect)frame backColor:(UIColor *)backColor color:(UIColor *)color proportion:(CGFloat)proportion{
    ProgressView * progressView = [[self alloc]initWithFrame:frame];
    if (!color) {
        progressView.progressColor  = [UIColor whiteColor];
    }else{
        progressView.progressColor  = color;
    }
    progressView.progressBackColor  = backColor;
    if (proportion <= 0) {
        proportion = 0;
    }
    else if (proportion > 0 && proportion < 1) {
        proportion = proportion;
    }
    else{
        proportion = 1;
    }
    progressView.proportion = proportion;
    [progressView showProgress];
    return progressView;
};



-(void)showProgress{
    
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height)/2 - MIN(self.bounds.size.width, self.bounds.size.height)/10;
    UIBezierPath * path     = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:radius startAngle: - M_PI endAngle:M_PI clockwise:YES];
    
    CAShapeLayer * backLayer    = [CAShapeLayer layer];
    backLayer.fillColor         = [[UIColor clearColor] CGColor];
    backLayer.strokeColor       = self.progressBackColor.CGColor;
    backLayer.lineWidth         = radius / 15;
    backLayer.strokeEnd         = 1;
    backLayer.path              = path.CGPath;
    [self.layer addSublayer:backLayer];
    
    CAShapeLayer * progressLayer    = [CAShapeLayer layer];
    progressLayer.fillColor         = [UIColor clearColor].CGColor;
    progressLayer.strokeColor       = self.progressColor.CGColor;
    progressLayer.lineWidth         = radius / 15;
    progressLayer.path              = path.CGPath;
    [self.layer addSublayer:progressLayer];
    
    CABasicAnimation * animation    = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue             = @(0);
    animation.toValue               = @(self.proportion);
    animation.duration              = 1;
    animation.fillMode              = kCAFillModeForwards;
    animation.removedOnCompletion   = NO;
    [progressLayer addAnimation:animation forKey:nil];
}
-(void)showContentData{
    [self addSubview:self.dataLabel];
    [self addSubview:self.dataNameLabel];
}

#pragma mark - setter
-(void)setDataLabelFont:(CGFloat)dataLabelFont{
    _dataLabelFont = dataLabelFont;
    _dataLabel.font = [UIFont systemFontOfSize:dataLabelFont];
    [self setDataLabelBold:self.dataLabelBold];
}
-(void)setDataLabelBold:(BOOL)dataLabelBold{
    _dataLabelBold = dataLabelBold;
    if (_dataLabelBold) {
        if (_dataLabelFont) {
            [_dataLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:_dataLabelFont]];
        }else{
            [_dataLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        }
    }
}
@end
