//
//  WPPushParameterTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPPushParameterTableViewCell.h"

@interface WPPushParameterTableViewCell ()<UITextFieldDelegate>
{
    WPPushParameterBlock        _parameterBlock;
    WPPushParameterNameBlock    _parameterNameBlock;
}

@property (weak, nonatomic) IBOutlet UITextField *parameterName;
@property (weak, nonatomic) IBOutlet UITextField *parameter;

@end
@implementation WPPushParameterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_parameter addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_parameterName addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldChange:(UITextField *)textField{
    //tag值在xib中设置
    if (textField.tag == 1) {
        _parameterBlock(textField.text);
    }else{
        _parameterNameBlock(textField.text);
    }
}

-(void)getPushParameterWithBlock:(WPPushParameterBlock)pushParameterBlock{
    _parameterBlock = pushParameterBlock;
}
-(void)getPushParameterNameWithBlock:(WPPushParameterNameBlock)pushParameterNameBlock{
    _parameterNameBlock = pushParameterNameBlock;
}
@end
