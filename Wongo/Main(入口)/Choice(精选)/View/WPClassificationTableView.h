//
//  WPClassificationTableView.h
//  Wongo
//
//  Created by rexsu on 2017/5/22.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TableViewSelectClassification)(NSString *classification,NSInteger index);

@interface WPClassificationTableView : UITableView


@property (nonatomic,strong)NSIndexPath * indexPath;
@property (nonatomic,strong)NSArray * dataSourceArray;

-(void)getClassificationStringWithBlock:(TableViewSelectClassification)block;

-(void)menuOpen;
-(void)menuClose;
-(void)removeSelect;
@end
