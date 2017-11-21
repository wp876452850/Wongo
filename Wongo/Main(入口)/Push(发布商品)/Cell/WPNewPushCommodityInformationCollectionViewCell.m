//
//  WPNewPushCommodityInformationCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/16.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewPushCommodityInformationCollectionViewCell.h"


@interface WPNewPushCommodityInformationCollectionViewCell ()<UITextViewDelegate,UITextFieldDelegate>
{
    WPNewPushGoodsNameBlock _goodsNameBlock;
    WPNewPushDescribeBlock  _describeBlock;
}
@property (weak, nonatomic) IBOutlet WPCostomTextField *goodsname;
@property (weak, nonatomic) IBOutlet UITextView  *describe;
//记录单元格高度
@property (nonatomic,assign)NSInteger rowHeight;
@property (weak, nonatomic) IBOutlet UILabel *limitLenghtLabel;
@end

@implementation WPNewPushCommodityInformationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.describe.layer.masksToBounds = YES;
    self.describe.layer.borderWidth = .5f;
    self.describe.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.describe.layer.cornerRadius = 5.f;
    self.describe.delegate = self;
    self.describe.limitLength = @(200);
    self.goodsname.delegate = self;
    
    _limitLenghtLabel.textAlignment = NSTextAlignmentRight;
    _limitLenghtLabel.textColor = [UIColor lightGrayColor];
    _limitLenghtLabel.font = [UIFont systemFontOfSize:13.];
    _limitLenghtLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.describe.text.length,@(200)];
    
    self.describe.placeholder = @"请描述物品相关信息,越详细获选的几率越高哟";
    _wordsNumber = 50;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_goodsNameBlock) {
        _goodsNameBlock(textField.text);
    }
}
//限制输入框字数
-(void)textDataChange:(UITextField *)textField{
    if (textField.text.length > _wordsNumber ) {
        textField.text = [textField.text substringToIndex:_wordsNumber];
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if (_describeBlock) {
        _describeBlock(textView.text,[textView.text getSizeWithFont:[UIFont systemFontOfSize:14.5f] maxSize:CGSizeMake(textView.width, MAXFLOAT)].height+145.f);
    }
    if (self.describe.text.length > 200 ) {
        self.describe.text = [self.describe.text substringToIndex:200];
    }    
    self.limitLenghtLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.describe.text.length,@(200)];
}

//回调
-(void)getGoodsNameBlockWithBlock:(WPNewPushGoodsNameBlock)block{
    _goodsNameBlock = block;
}
-(void)getDescribeBlockWithBlock:(WPNewPushDescribeBlock)block{
    _describeBlock = block;
}

@end
