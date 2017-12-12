//
//  WPPushDetailInformationCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPPushDetailInformationCollectionViewCell.h"

@interface WPPushDetailInformationCollectionViewCell ()
{
    WPNewPushDetailInformationBlock _block;
}

@end
@implementation WPPushDetailInformationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.data addTarget:self action:@selector(textDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    [self.data addTarget:self action:@selector(textDataChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.data addTarget:self action:@selector(endEnding) forControlEvents:UIControlEventEditingDidEndOnExit];
    _wordsNumber = 50;
}
//点击换行结束编辑
-(void)endEnding{
    [self.contentView endEditing:YES];
}
-(void)textDidBegin:(UITextField *)textField{
    if (self.superView&&self.indexPath) {
        [self.superView selectItemAtIndexPath:self.indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
}

-(void)textDataChange:(UITextField *)textField{
    
    if (textField.text.length > _wordsNumber ) {
        textField.text = [textField.text substringToIndex:_wordsNumber];
    }
    if (_block) {
        _block(textField.text);
    }
}

-(void)getTextFieldDataWithBlock:(WPNewPushDetailInformationBlock)block{
    _block = block;
}

@end
