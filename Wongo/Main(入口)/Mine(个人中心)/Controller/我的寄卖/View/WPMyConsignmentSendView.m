//
//  WPMyConsignmentSendView.m
//  Wongo
//
//  Created by  WanGao on 2018/1/4.
//  Copyright © 2018年 Winny. All rights reserved.
//

#import "WPMyConsignmentSendView.h"
#import "WPMyConsignmentViewController.h"

@interface WPMyConsignmentSendView (){
    WPMyConsignmentSendBlock _block;
}

@property (nonatomic,strong)NSString * lid;
//物流单号
@property (nonatomic,strong)UITextField * logNumber;
//物流公司
@property (nonatomic,strong)UITextField * logcompany;
//背景视图
@property (nonatomic,strong)UIView * backView;
//关闭按钮
@property (nonatomic,strong)UIButton * closeButton;
//确认信息
@property (nonatomic,strong)UIButton * send;
//头部标题
@property (nonatomic,strong)UILabel * title;
@end
@implementation WPMyConsignmentSendView


-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH-40, 220)];
        _backView.center = self.center;
        _backView.backgroundColor = WhiteColor;
        _backView.layer.cornerRadius = 5.f;
        //背景阴影
        UIView * shadowView = [[UIView alloc]initWithFrame:self.frame];
        shadowView.backgroundColor = BlackColor;
        shadowView.alpha = .5f;
        [self addSubview:shadowView];
        
        [self addSubview:_backView];
    }
    return _backView;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.backView.width - 20, 40)];
        _title.text = @"填写商品物流信息";
        _title.font = [UIFont boldSystemFontOfSize:14.f];
        //分割线
        [self.backView.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(2, _title.bottom) moveForPoint:CGPointMake(self.backView.width - 4, _title.bottom) lineColor:TitleGrayColor]];        
    }
    return _title;
}

-(UITextField *)logNumber{
    if (!_logNumber) {
        _logNumber = [[UITextField alloc]initWithFrame:CGRectMake(20, 60, self.backView.width - 40, 30)];
        _logNumber.backgroundColor = AllBorderColor;
        _logNumber.placeholder = @"请输入物流单号";
        _logNumber.borderStyle = UITextBorderStyleRoundedRect;
        _logNumber.font = [UIFont systemFontOfSize:14.f];
        _logNumber.keyboardType = UIKeyboardTypePhonePad;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(25, _logNumber.bottom, 230, 15)];
        label.text = @"物流单号,便于查询物流信息";
        label.textColor = TitleGrayColor;
        label.font = [UIFont systemFontOfSize:12.f];
        [self.backView addSubview:label];
    }
    return _logNumber;
}

-(UITextField *)logcompany{
    if (!_logcompany) {
        _logcompany = [[UITextField alloc]initWithFrame:CGRectMake(20, 120, self.backView.width - 40, 30)];
        _logcompany.backgroundColor = AllBorderColor;
        _logcompany.placeholder = @"请输入物流公司名称";
        _logcompany.borderStyle = UITextBorderStyleRoundedRect;
        _logcompany.font = [UIFont systemFontOfSize:14.f];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(25, _logcompany.bottom, 230, 15)];
        label.text = @"物流公司名称,便于查询物流信息";
        label.textColor = TitleGrayColor;
        label.font = [UIFont systemFontOfSize:12.f];
        [self.backView addSubview:label];
    }
    return _logcompany;
}

-(UIButton *)send{
    if (!_send) {
        _send = [UIButton buttonWithType:UIButtonTypeCustom];
        _send.frame = CGRectMake(0, 0, 95, 35);
        _send.layer.masksToBounds = YES;
        _send.layer.cornerRadius = 5.f;
        _send.right = self.backView.width - 10;
        _send.bottom = self.backView.height - 10;
        _send.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _send.backgroundColor = WongoBlueColor;
        [_send setTitle:@"确认物流信息" forState:UIControlStateNormal];
        [_send addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _send;
}
-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, 10.5, 19, 19);
        _closeButton.right = self.backView.width - 10;
        [_closeButton setImage:[UIImage imageNamed:@"deleteImage"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

-(instancetype)initWithLid:(NSString *)lid{
    if (self = [super init]) {
        self.lid = lid;
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
        [self.backView addSubview:self.title];
        [self.backView addSubview:self.logNumber];
        [self.backView addSubview:self.logcompany];
        [self.backView addSubview:self.closeButton];
        [self.backView addSubview:self.send];
    }
    return self;
}

-(void)sendClick{
    if ([self determineWhetherIsEmpty]) {
        [WPNetWorking createPostRequestMenagerWithUrlString:LogisticsUserUpdate params:@{@"lid":self.lid,@"lognum":self.logNumber.text,@"logcompany":self.logcompany.text} datas:^(NSDictionary *responseObject) {
            if ([responseObject[@"flag"] integerValue] == 1) {
                [[self findViewController:self]showMBProgressHUDWithTitle:@"物流信息上传成功"];
                WPMyConsignmentViewController * vc = (WPMyConsignmentViewController *)[self findViewController:self];
                [vc loadDatas];                
                [self removeFromSuperview];
            }else{
                [[self findViewController:self]showMBProgressHUDWithTitle:@"物流信息上传失败"];
            }
        }];
    }else{
        [[self findViewController:self]showMBProgressHUDWithTitle:@"请输入完整信息"];
    }
}

-(BOOL)determineWhetherIsEmpty{
    if (self.logNumber.text.length <= 0||self.logcompany.text.length <= 0) {
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findViewController:self].view endEditing:YES];
}
//发送后的回调
-(void)sendGoodsWithBlock:(WPMyConsignmentSendBlock)block{
    _block = block;
}
@end
