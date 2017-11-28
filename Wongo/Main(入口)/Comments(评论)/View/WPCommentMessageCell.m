//
//  WPCommentMessageCell.m
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCommentMessageCell.h"

@interface WPCommentMessageCell ()
@property (nonatomic,strong)UILabel * commentContent;
@end

@implementation WPCommentMessageCell
-(UILabel *)commentContent{
    if (!_commentContent) {
        _commentContent = [[UILabel alloc]init];
        _commentContent.numberOfLines = 0;
        _commentContent.lineBreakMode = NSLineBreakByCharWrapping;
        _commentContent.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:_commentContent];
        self.hyb_lastViewInCell = _commentContent;
        self.hyb_bottomOffsetToCell = 5.f;
        [_commentContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).offset(3.0f);
        }];
    }
    return _commentContent;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = WhiteColor;
    }
    return self;
}

-(void)setModel:(WPCommentMessegeModel *)model{
    _model = model;
    NSString * comment = nil;
    //将用户名颜色处理
    if ([model.byuname isEqualToString:@""]) {
        comment = [NSString stringWithFormat:@"%@:%@",model.uname,model.commentContent];
    }else{
        comment = [NSString stringWithFormat:@"%@回复%@:%@",model.uname,model.byuname,model.commentContent];}
    NSMutableAttributedString * content = [[NSMutableAttributedString alloc]initWithString:comment];
    [content addAttribute:NSForegroundColorAttributeName value:SelfThemeColor range:NSMakeRange(0, model.uname.length)];
    [content addAttribute:NSForegroundColorAttributeName value:SelfThemeColor range:NSMakeRange(model.uname.length+2, model.byuname.length)];
    self.commentContent.attributedText = content;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
