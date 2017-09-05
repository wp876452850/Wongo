//
//  WPDreamingImageTableViewCell.h
//  test222
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPDreamingIntroduceImageModel.h"

@interface WPDreamingImageTableViewCell : UITableViewCell

@property (nonatomic,strong)WPDreamingIntroduceImageModel * model;
-(void)showOK;
-(void)showOngoing;
@end
