//
//  WPDreamingDescribeTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/3.
//  Copyright © 2017年 Winny. All rights reserved.
//  描述单元格

#import "WPDreamingDescribeTableViewCell.h"

@interface WPDreamingDescribeTableViewCell ()<UITextViewDelegate>
{
    WPPushDescribeBlock _pushDescribeBlock;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleNumber;
@property (weak, nonatomic) IBOutlet UILabel *limitLenghtLabel;

@end
@implementation WPDreamingDescribeTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.delegate = self;
    self.textView.placeholder = @"介绍宝贝的尺码、材质等信息";
    self.textView.limitLength = @(200);
    self.limitLenghtLabel.textAlignment = NSTextAlignmentRight;
    self.limitLenghtLabel.textColor = [UIColor lightGrayColor];
    self.limitLenghtLabel.font = [UIFont systemFontOfSize:13.];
    self.limitLenghtLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.textView.text.length,@(200)];
    self.selectionStyle         = UITableViewCellSelectionStyleNone;
}



-(NSInteger)rowHeight{
    _rowHeight = self.textView.height + 20;
    return _rowHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (_pushDescribeBlock) {
        _pushDescribeBlock(textView.text);
    }
    if (self.textView.text.length > 200 ) {
        self.textView.text = [self.textView.text substringToIndex:200];
    }
    
    self.limitLenghtLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.textView.text.length,@(200)];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
}

-(void)getDescribeBlockWithBlock:(WPPushDescribeBlock)block{
    _pushDescribeBlock = block;
}

@end
