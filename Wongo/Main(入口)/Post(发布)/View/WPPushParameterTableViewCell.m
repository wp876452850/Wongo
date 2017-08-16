//
//  WPPushParameterTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPPushParameterTableViewCell.h"
#import "DLPickerView.h"

@interface WPPushParameterTableViewCell ()<UITextFieldDelegate>
{
    WPPushParameterBlock        _parameterBlock;
    WPPushParameterNameBlock    _parameterNameBlock;
}



@end
@implementation WPPushParameterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _parameterName.layer.masksToBounds  = YES;
    _parameterName.layer.cornerRadius   = 5;
    _parameterName.layer.borderWidth    = .5f;
    _parameterName.layer.borderColor    = ColorWithRGB(210, 210, 210).CGColor;
    [_parameter addTarget:self action: @selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldChange:(UITextField *)textField{
    //tag值在xib中设置
    if (_parameterBlock) {
       _parameterBlock(textField.text);
    }
}

- (IBAction)parameterNameSelected:(UIButton *)sender {
    DLPickerView *pickerView = [[DLPickerView alloc] initWithDataSource:@[@"Man",@"Woman"]
                                                       withSelectedItem:sender.titleLabel.text
                                                      withSelectedBlock:^(id selectedItem) {
                                                          [sender setTitle:selectedItem forState:UIControlStateNormal];
                                                      }
                                ];    
    [pickerView show];
}

-(void)getPushParameterWithBlock:(WPPushParameterBlock)pushParameterBlock{
    _parameterBlock = pushParameterBlock;
}
-(void)getPushParameterNameWithBlock:(WPPushParameterNameBlock)pushParameterNameBlock{
    _parameterNameBlock = pushParameterNameBlock;
}

@end
