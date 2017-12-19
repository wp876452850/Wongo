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
    WPNewPushDescribeEdtingBlock _describeEdtingBlock;
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
    [self.goodsname addTarget:self action:@selector(endEnding) forControlEvents:UIControlEventEditingDidEndOnExit];
    
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
    
    self.describe.placeholder = @"请详细描述您所发布的物品相关信息";
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

    if (self.describe.text.length > 200 ) {
        self.describe.text = [self.describe.text substringToIndex:200];
    }    
    self.limitLenghtLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.describe.text.length,@(200)];
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self endEnding];
    if (_describeEdtingBlock) {
        _describeEdtingBlock(textView.text,[textView.text getSizeWithFont:[UIFont systemFontOfSize:14.5f] maxSize:CGSizeMake(textView.width, MAXFLOAT)].height+145.f);
    }
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

//回调
-(void)getGoodsNameBlockWithBlock:(WPNewPushGoodsNameBlock)block{
    _goodsNameBlock = block;
}

-(void)getDescribeEdtingBlockWithBlock:(WPNewPushDescribeEdtingBlock)block{
    _describeEdtingBlock = block;
}
@end
