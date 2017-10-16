//
//  LYHomeSquareCell.m
//  Wongo
//
//  Created by  WanGao on 2017/6/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYHomeSquareCell.h"
#import "WPCollectionBaseViewController.h"


@interface LYHomeSquareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *count;
//高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countH;

@end

@implementation LYHomeSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}
- (void)setCategory:(LYHomeCategory *)category{
    _category = category;
    [self.image sd_setImageWithURL:[NSURL URLWithString:category.url] placeholderImage:nil];
    self.count.text = [NSString stringWithFormat:@"数量:%d",category.count];
    self.countH.constant = self.height *0.308;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WPCollectionBaseViewController * vc = [[WPCollectionBaseViewController alloc]initWithWithTpid:[NSString stringWithFormat:@"%d",_category.tpid] imageUrl:_category.urljs];
    vc.url = QueryGoodById;
    vc.myNavItem.title = _category.tpname;;
    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
}
@end
