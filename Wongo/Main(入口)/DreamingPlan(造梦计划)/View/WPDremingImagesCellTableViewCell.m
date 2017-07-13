//
//  WPDremingImagesCellTableViewCell.m
//  Wongo
//
//  Created by rexsu on 2017/3/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDremingImagesCellTableViewCell.h"
#import "WPAddImagesButton.h"
#import "WPGoodsImageView.h"

#define AddButton_Width_Height (WINDOW_WIDTH - 80) /3

@interface WPDremingImagesCellTableViewCell ()
{
    BackImagesBlock _backImagesBlock;
    WPAddImagesButton * _addButton;
}
@end
@implementation WPDremingImagesCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _images = [NSMutableArray arrayWithCapacity:3];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

-(void)setImages:(NSMutableArray *)images{
    _images = images;
    [self.contentView removeAllSubviews];
    _addButton = [[WPAddImagesButton alloc]initWithFrame:CGRectMake(_images.count % 3 * (AddButton_Width_Height+20)+20, _images.count / 3 * (AddButton_Width_Height+20) + 50 , AddButton_Width_Height, AddButton_Width_Height)];
    _rowHeight = CGRectGetMaxY(_addButton.frame)+20;
    [_addButton getSelectPhotoWithBlock:^(UIImage *image) {
        [_images addObject:image];
        _backImagesBlock(_images,CGRectGetMaxY(_addButton.frame)+20);
    }];
    [self.contentView addSubview:_addButton];
    
    if (_images) {
        for (int i = 0; i<_images.count; i++) {
            WPGoodsImageView * image = [[WPGoodsImageView alloc]initWithImage:_images[i]];
            
            [image getBlock:^{
                NSMutableArray * array = [NSMutableArray arrayWithArray:_images];
                [array removeObjectAtIndex:i];
                self.images = array;
                 _backImagesBlock(_images,CGRectGetMaxY(_addButton.frame)+20);
            }];
            image.frame = CGRectMake(i % 3 * (AddButton_Width_Height+20) + 20, i / 3 * (AddButton_Width_Height+20) + 50 , AddButton_Width_Height, AddButton_Width_Height);
            
            [self.contentView addSubview:image];
        }
    }
}


-(void)getRowDataWithBlock:(BackImagesBlock)block{
    _backImagesBlock = block;
}
@end
