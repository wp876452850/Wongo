//
//  WPCommentViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/7/25.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPCommentViewCell.h"

@interface WPCommentViewCell ()<UITableViewDelegate,UITableViewDataSource>
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UITableView *commentTabel;

@end

@implementation WPCommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
/**点赞*/
- (IBAction)thumbUp:(UIButton *)sender {
    
}
/**进行评论*/
- (IBAction)comment:(UIButton *)sender {
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    return cell;
}
@end
