//
//  WPDreamingDataTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/3.
//  Copyright © 2017年 Winny. All rights reserved.
//  普通资料

#import "WPDreamingDataTableViewCell.h"

@interface WPDreamingDataTableViewCell ()
{
    WPPushDataBlock _pushDataBlock;
}

@end
@implementation WPDreamingDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rowHeight = self.data.height + 10;
    [self.data addTarget:self action:@selector(textDataChange:) forControlEvents:UIControlEventEditingChanged];
    _wordsNumber = 50;
}

-(void)textDataChange:(UITextField *)textField{
    if (textField.text.length > _wordsNumber ) {
        textField.text = [textField.text substringToIndex:_wordsNumber];
    }
    if (_pushDataBlock) {
        _pushDataBlock(textField.text);
    }
    
}
-(void)getTextFieldDataWithBlock:(WPPushDataBlock)block{
    _pushDataBlock = block;
}
@end
