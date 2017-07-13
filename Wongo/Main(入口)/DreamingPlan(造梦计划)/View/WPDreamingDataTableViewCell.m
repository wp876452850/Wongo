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
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.rowHeight = self.data.height + 10;
        [self.data addTarget:self action:@selector(textDataChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)textDataChange:(UITextField *)textField{
    if (textField.text.length > 50 ) {
        textField.text = [textField.text substringToIndex:50];
    }
    if (_pushDataBlock) {
        _pushDataBlock(textField.text);
    }
    
}
-(void)getTextFieldDataWithBlock:(WPPushDataBlock)block{
    _pushDataBlock = block;
}
@end
