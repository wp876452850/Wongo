//
//  WPDreamingDirectoryViewController.h
//  Wongo
//
//  Created by rexsu on 2017/5/11.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦专题

#import <UIKit/UIKit.h>

@interface WPDreamingDirectoryViewController : UIViewController

-(instancetype)initWithSubid:(NSString *)subid subName:(NSString *)subName;

@property (nonatomic,strong)NSString * subid;

@end
