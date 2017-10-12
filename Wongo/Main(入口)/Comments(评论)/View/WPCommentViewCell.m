//
//  WPCommentViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCommentViewCell.h"
#import "WPCommentMessageCell.h"
#import "WPStoreViewController.h"

@interface WPCommentViewCell ()
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation WPCommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headPortrait.layer.masksToBounds = YES;
    self.headPortrait.layer.cornerRadius  = 17.5f;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.headPortrait addGestureRecognizer:tap];
}

-(void)tap{
    WPStoreViewController * vc = [[WPStoreViewController alloc]initWithUid:@"1"];
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
/**点赞*/
- (IBAction)thumbUp:(UIButton *)sender {
    
}
/**进行评论*/
- (IBAction)comment:(UIButton *)sender {
    
}

-(void)setModel:(WPCommentModel *)model{
    _model = model;
    _headPortrait.image = model.headImage;
    _name.text = model.uname;
    _time.text = [model.commenttime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    _comment.text = model.comment;
}
-(void)setCommentMessageModel:(WPCommentMessegeModel *)commentMessageModel{
    _commentMessageModel = commentMessageModel;
    _headPortrait.image = commentMessageModel.headImage;
    _name.text = commentMessageModel.uname;
    _time.text = commentMessageModel.commentTime;
    _comment.text = commentMessageModel.commentContent;
}

@end
