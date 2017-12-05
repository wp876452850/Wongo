//
//  WPNewPushUserInformationCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewPushUserInformationCollectionViewCell.h"

@interface WPNewPushUserInformationCollectionViewCell ()<UITextFieldDelegate>
{
    WPNewPushNameBlock  _nameBlock;
    WPNewPushPhoneBlock _phoneBlock;
    WPNewPushMailBlock  _mailBlock;
}
@property (weak, nonatomic) IBOutlet WPCostomTextField *name;
@property (weak, nonatomic) IBOutlet WPCostomTextField *phone;

@end

@implementation WPNewPushUserInformationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.name.delegate = self;
    self.phone.delegate = self;
}
//结束输入是返回回调
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        if (_nameBlock) {
            _nameBlock(textField.text);
        }
    }
    else if(textField.tag == 1){
        if (_phoneBlock) {
            _phoneBlock(textField.text);
        }
    }
    else{
        if (_mailBlock) {
            _mailBlock(textField.text);
        }
    }
}

//回调
-(void)getNameBlockWithBlock:(WPNewPushNameBlock)block{
    _nameBlock  = block;
}
-(void)getPhoneBlockWithBlock:(WPNewPushPhoneBlock)block{
    _phoneBlock = block;
}
-(void)getMailBlockWithBlock:(WPNewPushPhoneBlock)block;{
    _mailBlock = block;
}
@end
