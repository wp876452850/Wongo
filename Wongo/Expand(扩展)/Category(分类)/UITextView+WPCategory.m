//
//  UITextView+WPCategory.m
//  Wongo
//
//  Created by rexsu on 2017/3/24.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "UITextView+WPCategory.h"
#import <objc/runtime.h>
@interface UITextView ()
@property (nonatomic,strong) UILabel *placeholderLabel;//占位符
@property (nonatomic,strong) UILabel *wordCountLabel;//计算字数
@end
@implementation UITextView (WPCategory)

static NSString     * PLACEHOLDLABEL    = @"placelabel";
static NSString     * PLACEHOLD         = @"placehold";
static NSString     * WORDCOUNTLABEL    = @"wordcount";
static const void   * limitLengthKey    = &limitLengthKey;

#pragma mark -- set/get...

-(void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    
    objc_setAssociatedObject(self, &PLACEHOLDLABEL, placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)placeholderLabel {
    
    return objc_getAssociatedObject(self, &PLACEHOLDLABEL);
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    objc_setAssociatedObject(self, &PLACEHOLD, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setPlaceHolderLabel:placeholder];
}

- (NSString *)placeholder {
    
    return objc_getAssociatedObject(self, &PLACEHOLD);
}


- (UILabel *)wordCountLabel {
    
    return objc_getAssociatedObject(self, &WORDCOUNTLABEL);
    
}
- (void)setWordCountLabel:(UILabel *)wordCountLabel {
    
    objc_setAssociatedObject(self, &WORDCOUNTLABEL, wordCountLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (NSNumber *)limitLength {
    
    return objc_getAssociatedObject(self, limitLengthKey);
}

- (void)setLimitLength:(NSNumber *)limitLength {
    objc_setAssociatedObject(self, limitLengthKey, limitLength, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addLimitLengthObserver:[limitLength intValue]];
    
    //[self setWordcountLable:limitLength];
    
}

#pragma mark -- 配置占位符标签

- (void)setPlaceHolderLabel:(NSString *)placeholder {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextViewTextDidChangeNotification object:self];
    /*
     *  占位字符
     */
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = [UIFont systemFontOfSize:14.0];
    self.placeholderLabel.text = placeholder;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    CGSize size = [placeholder getSizeWithFont:[UIFont systemFontOfSize:14.5f] maxSize:CGSizeMake(CGRectGetWidth(self.frame)-8, MAXFLOAT)];
    self.placeholderLabel.frame = CGRectMake(5, 7, size.width, size.height);
    [self addSubview:self.placeholderLabel];
    self.placeholderLabel.hidden = self.text.length > 0 ? YES : NO;
    
}

#pragma mark -- 配置字数限制标签

- (void)setWordcountLable:(NSNumber *)limitLength {
    
    /*
     *  字数限制
     */
    self.wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - 180, CGRectGetMaxY(self.frame) - 40, 60, 20)];
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    self.wordCountLabel.textColor = [UIColor lightGrayColor];
    self.wordCountLabel.font = [UIFont systemFontOfSize:13.];
    if (self.text.length > [limitLength integerValue]) {
        self.text = [self.text substringToIndex:[self.limitLength intValue]];
    }
    self.wordCountLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.text.length,limitLength];
    [self addSubview:self.wordCountLabel];
    
}


#pragma mark -- 增加限制位数的通知
- (void)addLimitLengthObserver:(int)length {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitLengthEvent) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark -- 限制输入的位数
- (void)limitLengthEvent {
    
    if ([self.text length] > [self.limitLength intValue]) {
        
        self.text = [self.text substringToIndex:[self.limitLength intValue]];
    }
}


#pragma mark -- NSNotification

- (void)textFieldChanged:(NSNotification *)notification {
    if (self.placeholder) {
        self.placeholderLabel.hidden = YES;
        
        if (self.text.length == 0) {
            
            self.placeholderLabel.hidden = NO;
        }
    }
    if (self.limitLength) {
        
        NSInteger wordCount = self.text.length;
        if (wordCount > [self.limitLength integerValue]) {
            wordCount = [self.limitLength integerValue];
        }
        self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/%@",wordCount,self.limitLength];
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
}

#pragma mark -- 改变间距
#pragma mark - 行间距
+ (void)changeLineSpaceForLabel:(UITextView *)textView WithSpace:(float)space {
    id text = nil;
    NSMutableAttributedString *attributedString = nil;
    if (textView.text.length>0) {
        text = textView.text;
        attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    }
    else{
        text = textView.attributedText;
        attributedString = text;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    textView.attributedText = attributedString;
    //[textView sizeToFit];
}

+ (void)changeLineSpaceForLabel:(UITextView *)textView WithSpace:(float)space foneSize:(CGFloat)foneSize{
    [self changeLineSpaceForLabel:textView WithSpace:space];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AdobeHeitiStd-Regular" size:foneSize] range:NSMakeRange(0, [textView.attributedText length])];
    textView.attributedText = attributedString;    
    [textView sizeToFit];
}

#pragma mark - 字间距
+ (void)changeWordSpaceForLabel:(UITextView *)textView WithSpace:(float)space {
    
    NSString * text = textView.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    textView.attributedText = attributedString;
    
    [textView sizeToFit];
}
#pragma mark - 字与行间距
+ (void)changeSpaceForLabel:(UITextView *)textView withLineSpace:(float)lineSpace WordSpace:(float)wordSpace{
    
    NSString *text = textView.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    textView.attributedText = attributedString;
    [textView sizeToFit];
    
}
@end
