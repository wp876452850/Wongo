//
//  WPTypeChooseMune.h
//  Wongo
//
//  Created by rexsu on 2017/2/17.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeBlock)(NSString * type);

@interface WPTypeChooseMune : UIView
@property (nonatomic,assign)BOOL isOpen;
-(void)changeTypeWithBlock:(ChangeBlock)block;

-(void)menuOpen;
-(void)menuClose;
@end
