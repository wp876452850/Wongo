//
//  WPSearchNavigationBar.m
//  Wongo
//
//  Created by rexsu on 2017/2/15.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSearchNavigationBar.h"

@interface WPSearchNavigationBar()
{
    ActionBlock _actionBlock;
    ChooseBlock _chooseBlock;
}
@property (nonatomic,strong)UIView * view;

@property (nonatomic,strong)UIButton * go;

@property (nonatomic,strong)UITextField * textField;
@end

@implementation WPSearchNavigationBar

-(UIView *)view{
    if (!_view) {
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WINDOW_WIDTH, 44)];
        _view.backgroundColor = self.backgroundColor;
    }
    return _view;
}
-(UIButton *)back{
    if (!_back) {
        _back = [UIButton buttonWithType:UIButtonTypeCustom];
        [_back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    return _back;
}
-(UIButton *)choose{
    if (!_choose) {
        _choose = [UIButton buttonWithType:UIButtonTypeCustom];
        _choose.frame = CGRectMake(0, 0, 50, 30);
        [_choose setTitle:@"商品" forState:UIControlStateNormal];
        _choose.titleLabel.font = [UIFont systemFontOfSize:15];
        [_choose setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_choose addTarget:self action:@selector(chooseTpyeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choose;
}
-(UIButton *)go{
    if (!_go) {
        _go = [UIButton buttonWithType:UIButtonTypeCustom];
        [_go addTarget:self action:@selector(actionSearch) forControlEvents:UIControlEventTouchUpInside];
        [_go setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    }
    return _go;
}
-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftView = self.choose;
        _textField.placeholder = @"请输入关键字";
        _textField.textColor = WhiteColor;
        _textField.font = [UIFont systemFontOfSize:15];
        [_textField setValue:WhiteColor forKeyPath:@"_placeholderLabel.textColor"];
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        
        
        _textField.layer.masksToBounds = YES;
        _textField.layer.cornerRadius = 15;
        _textField.layer.borderWidth = 1.5;
        _textField.layer.borderColor = WhiteColor.CGColor;
        _textField.backgroundColor = self.backgroundColor;
        
    }
    return _textField;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorWithRGB(0, 0, 0);
        [self addSubview:self.view];
        [self.view addSubview:self.go];
        [self.view addSubview:self.back];
        [self.view addSubview:self.textField];
        [self constraintLayout];
    }
    return self;
}

-(void)constraintLayout{
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [self.go mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.back.mas_right).offset(10);
        make.right.mas_equalTo(self.go.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
}
#pragma mark - buttonClick
-(void)actionSearch{
    if (_actionBlock) {
        _actionBlock(self.choose.titleLabel.text,self.textField.text);
    }
}

-(void)chooseTpyeClick{
    if (_chooseBlock) {
        _chooseBlock();
    }
}

#pragma makr - block
-(void)actionSearchWithBlock:(ActionBlock)block{
    _actionBlock = block;
}
-(void)chooseButtonClickWithBlock:(ChooseBlock)block{
    _chooseBlock = block;
}

-(void)setOpenFirstResponder:(BOOL)openFirstResponder{
    _openFirstResponder = openFirstResponder;
    if (openFirstResponder) {
        [self.textField becomeFirstResponder];
    }
}
@end
