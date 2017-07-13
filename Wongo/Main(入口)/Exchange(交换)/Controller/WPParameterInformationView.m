//
//  WPParameterInformationView.m
//  Wongo
//
//  Created by rexsu on 2017/5/4.
//  Copyright © 2017年 Winny. All rights reserved.
//  参数信息

#import "WPParameterInformationView.h"

@interface WPParameterInformationView ()
@property (nonatomic,strong)UIView      * view;
@property (nonatomic,strong)UITextView  * textView;
@property (nonatomic,strong)NSString    * url;

@end

@implementation WPParameterInformationView

-(UIView *)view{
    if (!_view) {
        _view                           = [[UIView alloc]initWithFrame:self.bounds];
        _view.backgroundColor           = [UIColor blackColor];
        _view.alpha                     = 0;
        UITapGestureRecognizer * tap    = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [_view addGestureRecognizer:tap];
    }
    return _view;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView           = [[UITextView alloc]initWithFrame:self.bounds];
        _textView.userInteractionEnabled = NO;
        _textView.y         = WINDOW_HEIGHT;
        _textView.height    = WINDOW_HEIGHT /2;
        _textView.font      = [UIFont systemFontOfSize:17];
    }
    return _textView;
}
-(instancetype)init{
    if (self = [super init]) {
        self.frame = WINDOW_BOUNDS;
        [self addSubview:self.view];
        [self addSubview:self.textView];
        _textView.text = @"暂无参数信息";
        [self loadParameterInformation];
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}
-(void)loadParameterInformation{
    
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0.5;
        self.textView.y = WINDOW_HEIGHT - self.textView.height;
    }];
}

+(instancetype)createParameterInformationWithUrlString:(NSString *)urlstring{
    WPParameterInformationView * vc = [[WPParameterInformationView alloc]init];
    vc.url = urlstring;
    return vc;
}

-(void)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
        self.textView.y = WINDOW_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}





@end
