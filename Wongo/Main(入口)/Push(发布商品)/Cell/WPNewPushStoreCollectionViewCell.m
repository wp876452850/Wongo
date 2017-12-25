//
//  WPNewPushStoreCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/11/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPNewPushStoreCollectionViewCell.h"

@interface WPNewPushStoreCollectionViewCell ()<UITextViewDelegate,UITextFieldDelegate>{
    WPNewPushStoreBlock  _storeBlock;
}
@property (weak, nonatomic) IBOutlet UITextView *storeTextView;
@property (weak, nonatomic) IBOutlet UILabel *limitLenghtLabel;
@property (nonatomic,assign)NSInteger rowHeight;
@end
@implementation WPNewPushStoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.storeTextView.layer.masksToBounds = YES;
    self.storeTextView.layer.borderWidth = .5f;
    self.storeTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.storeTextView.layer.cornerRadius = 5.f;
    self.storeTextView.delegate = self;
    self.storeTextView.limitLength = @(200);
    
    _limitLenghtLabel.textAlignment = NSTextAlignmentRight;
    _limitLenghtLabel.textColor = [UIColor lightGrayColor];
    _limitLenghtLabel.font = [UIFont systemFontOfSize:13.];
    _limitLenghtLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.storeTextView.text.length,@(200)];
    
    self.storeTextView.placeholder = @"请填写您的造梦故事";
    _wordsNumber = 50;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.superView&&self.indexPath) {
        [self.superView selectItemAtIndexPath:self.indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textViewDidChange:(UITextView *)textView{
    if (_storeBlock) {
        _storeBlock(textView.text,[textView.text getSizeWithFont:[UIFont systemFontOfSize:14.5f] maxSize:CGSizeMake(textView.width, MAXFLOAT)].height+65.f);
    }
    if (self.storeTextView.text.length > 200 ) {
        self.storeTextView.text = [self.storeTextView.text substringToIndex:200];
    }
    self.limitLenghtLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.storeTextView.text.length,@(200)];
}

-(void)getStoreBlockWithBlock:(WPNewPushStoreBlock)block{
    _storeBlock = block;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findViewController:self].view endEditing:YES];
}
@end
