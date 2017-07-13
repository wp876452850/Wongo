//
//  LYHomeRectangleCell.m
//  Wongo
//
//  Created by  WanGao on 2017/6/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "LYHomeRectangleCell.h"
#import "LYActivityController.h"

@interface LYHomeRectangleCell ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cyImage;

@end

@implementation LYHomeRectangleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cyImage.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;//无效

}
- (void)setCategorys:(NSArray<LYHomeCategory *> *)categorys{
    _categorys = categorys;
    NSMutableArray *images = [NSMutableArray array];
    for (LYHomeCategory *category in categorys) {
        [images addObject:category.url];
    }
    self.cyImage.hidesForSinglePage = NO;
    self.cyImage.imageURLStringsGroup = images;
    self.cyImage.delegate = self;
    self.cyImage.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.cyImage.pageControlBottomOffset = -30;
    self.cyImage.pageDotImage = [UIImage imageNamed:@"HollowDot"];
    self.cyImage.currentPageDotImage = [UIImage imageNamed:@"SolidDot"];
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (index >= self.categorys.count) {
        return;
    }
    LYHomeCategory *category = self.categorys[index];
    [[self findViewController:self].navigationController pushViewController:[LYActivityController controllerWithCategory:category] animated:YES];
}
@end
