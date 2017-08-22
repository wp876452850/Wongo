//
//  WPDreamingDetailIntroduceTableViewCell.h
//  Wongo
//
//  Created by  WanGao on 2017/8/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WPDreamingDetailIntroduceBlock)(CGFloat height);
@interface WPDreamingDetailIntroduceTableViewCell : UITableViewCell

@property (nonatomic,strong)NSString * name;

@property (nonatomic,strong)NSString * introduce;

-(void)getCellheightWithBlock:(WPDreamingDetailIntroduceBlock)block;
@end
