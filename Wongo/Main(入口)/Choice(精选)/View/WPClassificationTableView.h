//
//  WPClassificationTableView.h
//  Wongo
//
//  Created by rexsu on 2017/5/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TableViewSelectClassification)(NSString * cname,NSString * cid);

@interface WPClassificationTableView : UITableView


@property (nonatomic,strong)NSIndexPath * indexPath;
@property (nonatomic,strong)NSMutableArray * dataSourceArray;

-(void)getClassificationStringWithBlock:(TableViewSelectClassification)block;

-(void)menuOpen;
-(void)menuClose;
-(void)removeSelect;
@end
