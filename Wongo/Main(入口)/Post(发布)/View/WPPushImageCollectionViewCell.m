//
//  WPPushImageCollectionViewCell.m
//  Wongo
//
//  Created by  WanGao on 2017/7/14.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPPushImageCollectionViewCell.h"

@implementation WPPushImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_imageView createDeleteBtn];
}

@end
