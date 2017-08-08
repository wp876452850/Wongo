//
//  WPCommentsSectionTableViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/8/2.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCommentsSectionTableViewCell.h"

@interface WPCommentsSectionTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *parameter;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (nonatomic,strong)UIView * parameterView;
@property (nonatomic,strong)UIView * commentView;
@end
@implementation WPCommentsSectionTableViewCell

-(UIView *)parameterView{
    if (!_parameterView) {
        _parameterView = [[UIView alloc]initWithFrame:CGRectMake(0, self.parameter.bottom, WINDOW_WIDTH, 110)];
        _parameterView.backgroundColor = WhiteColor;
        for (int i = 0; i < self.model.parameters.count/5; i++) {
            UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(i*WINDOW_WIDTH/3, 10, WINDOW_WIDTH/3, 90)];
            [_parameterView addSubview:textView];
            for (int j = 0; j < 5; j++) {
                if (textView.text.length > 0) {
                    textView.text = [NSString stringWithFormat:@"%@\n%@",textView.text,self.model.parameters[5*i+j]];
                }
                else
                    textView.text = self.model.parameters.firstObject;
            }
            textView.font = [UIFont systemFontOfSize:14];
            textView.userInteractionEnabled = NO;
        }
        [self.contentView addSubview:_parameterView];
    }
    return _parameterView;
}

-(UIView *)commentView{
    if (!_commentView) {
        _commentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.parameter.bottom, WINDOW_WIDTH, 110)];
        _commentView.backgroundColor = WhiteColor;
        [self.contentView addSubview:_commentView];        
        UIButton * goCommentViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [goCommentViewButton setTitle:@"查看所有讨论内容" forState:UIControlStateNormal];
    }
    return _commentView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
//显示参数
- (IBAction)showParameter:(UIButton *)sender {
    
    [self.contentView bringSubviewToFront:self.parameterView];
}
//显示评论
- (IBAction)showComment:(UIButton *)sender {
    
    [self.contentView bringSubviewToFront:self.commentView];
}

-(void)setModel:(WPExchangeDetailModel *)model{
    _model = model;
    self.commentView.hidden = NO;
    self.parameterView.hidden = NO;
}
@end
