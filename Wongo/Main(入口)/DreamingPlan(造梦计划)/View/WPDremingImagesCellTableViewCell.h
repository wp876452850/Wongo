//
//  WPDremingImagesCellTableViewCell.h
//  Wongo
//
//  Created by rexsu on 2017/3/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackImagesBlock)(NSMutableArray * images,NSInteger heightRow);

@interface WPDremingImagesCellTableViewCell : UITableViewCell
@property (nonatomic,assign)CGFloat rowHeight;
@property (nonatomic,strong)NSMutableArray * images;

-(void)getRowDataWithBlock:(BackImagesBlock)block;

@end
