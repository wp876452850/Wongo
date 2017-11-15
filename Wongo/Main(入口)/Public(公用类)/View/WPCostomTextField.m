//
//  WPCostomTextField.m
//  视图随键盘上升
//
//  Created by rexsu on 2017/3/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCostomTextField.h"

@interface WPCostomTextField ()<UITextFieldDelegate>

@property (nonatomic,strong)UILabel * label;

@end

@implementation WPCostomTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+(instancetype)createCostomTextFieldWithFrame:(CGRect)frame openRisingView:(BOOL)openRisingView superView:(UIView *)superView{
    WPCostomTextField * costomeTextFiled = [[WPCostomTextField alloc]initWithFrame:frame];
    costomeTextFiled.openRisingView = openRisingView;
    costomeTextFiled.superView      = superView;
    return costomeTextFiled;
}

-(void)setOpenRisingView:(BOOL)openRisingView{
    _openRisingView = openRisingView;
    if (openRisingView) {
        self.delegate = self;
    }else{
        self.delegate = nil;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    int offset = CGRectGetMaxY(self.frame)-(_superView.bounds.size.height - 258);//iPhone键盘高度216，iPad的为352
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:0.3f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    
    if(offset > -20)
    {
        _superView.backgroundColor = SelfOrangeColor;
        _superView.bounds = CGRectMake(0.0f, -(offset+CGRectGetHeight(self.bounds)+20), _superView.frame.size.width, _superView.frame.size.height);
    }
    if (self.superViewIsTableViewCell) {
        _superView.bounds = CGRectMake(0.0f, 258.0f, _superView.frame.size.width, _superView.frame.size.height);
    }
    [UIView commitAnimations];
    NSLog(@"%@",_superView);
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _superView.bounds = CGRectMake(0.0f, 0.0f, _superView.frame.size.width, _superView.frame.size.height);
}
-(void)dealloc{
    
}




@end
