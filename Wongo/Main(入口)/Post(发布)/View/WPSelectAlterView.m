//
//  WPSelectAlterView.m
//  Wongo
//
//  Created by rexsu on 2017/3/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSelectAlterView.h"
static SelectAlertBlock _selectAlertBlock;
@interface WPSelectAlterView ()
{
    CGFloat max_y;
    
}
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,strong)NSMutableArray * gcids;
@property (nonatomic,strong)UIView * view;
@property (nonatomic,strong)UIView * selectView;
@end
@implementation WPSelectAlterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.view                   = [[UIView alloc]initWithFrame:self.frame];
        self.view.backgroundColor   = [UIColor blackColor];
        self.view.alpha             = 0;
        [self addSubview:self.view];
        self.selectView             = [[UIView alloc]initWithFrame:self.frame];
        self.selectView.backgroundColor = WhiteColor;
        [self addSubview:self.selectView];
        self.dataSource             = [NSMutableArray arrayWithCapacity:3];
        self.gcids                  = [NSMutableArray arrayWithCapacity:3];
        self.selectView.y           = WINDOW_HEIGHT;
    }
    return self;
}

+(instancetype)createArraySelectAlterWithFrame:(CGRect)frame array:(NSArray *)array block:(SelectAlertBlock)block{
    WPSelectAlterView * selectAlterView = [[WPSelectAlterView alloc]initWithFrame:frame];
    selectAlterView.dataSource = [NSMutableArray arrayWithArray:array];
    selectAlterView.gcids      = [NSMutableArray arrayWithArray:array];
    [selectAlterView createSelectButton];
    _selectAlertBlock = block;

    return selectAlterView;
}

+(instancetype)createURLSelectAlterWithFrame:(CGRect)frame urlString:(NSString *)urlString params:(NSDictionary *)params block:(SelectAlertBlock)block
{
    WPSelectAlterView * selectAlterView = [[WPSelectAlterView alloc]initWithFrame:frame];
    [selectAlterView loadDatasWithUrlString:urlString params:params];
    _selectAlertBlock = block;
    return selectAlterView;
}

-(void)loadDatasWithUrlString:(NSString *)urlString params:(NSDictionary *)params{
    __block WPSelectAlterView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:urlString params:params datas:^(NSDictionary *responseObject) {
        NSArray * dataSource = [responseObject objectForKey:@"goodClass"];
        for (NSDictionary *dic in dataSource) {
            [_gcids addObject:[dic objectForKey:@"gcid"]];
            [_dataSource addObject:[dic objectForKey:@"gcname"]];
        }
        [weakSelf createSelectButton];
    }];
}

-(void)createSelectButton{
    
    for (int i = 0; i<self.dataSource.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds     = CGRectMake(0, 0, 80, 30);
        button.center     = CGPointMake(i%2*WINDOW_WIDTH/2+WINDOW_WIDTH/4, 60+ i/2*40);
        [button setTitle:self.dataSource[i] forState:UIControlStateNormal];
        [button setTitleColor:SelfOrangeColor forState:UIControlStateNormal];
        [self.selectView addSubview:button];
        max_y                      = CGRectGetMaxY(button.frame);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius  = button.height/2;
        button.layer.borderWidth   = 1;
        button.tag                 = i;
        button.layer.borderColor   = [UIColor redColor].CGColor;
        [button addTarget:self action:@selector(selectAlert:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    
    self.selectView.height = max_y + 10;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectView.y  = WINDOW_HEIGHT - self.selectView.height;
        self.view.alpha    = 0.5;
    }];
}

-(void)selectAlert:(UIButton *)sender{
    if (_selectAlertBlock) {
        _selectAlertBlock(self.dataSource[sender.tag],self.gcids[sender.tag]);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.selectView.y  = WINDOW_HEIGHT;
        self.view.alpha    = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        self.selectView.y  = WINDOW_HEIGHT;
        self.view.alpha    = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
