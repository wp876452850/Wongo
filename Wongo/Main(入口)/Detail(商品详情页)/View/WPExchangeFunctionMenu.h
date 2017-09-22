//
//  WPExchangeFunctionMenu.h
//  Wongo
//
//  Created by  WanGao on 2017/9/20.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FunctionMenuBlock)(NSInteger tag);
@interface WPExchangeFunctionMenu : UIView
@property (nonatomic,assign)BOOL isOpen;

-(instancetype)initWithFrame:(CGRect)frame menuImages:(NSArray *)menuImages menuTitles:(NSArray *)menuTitles;
-(void)functionMenuClickWithBlock:(FunctionMenuBlock)block;
-(void)menuOpen;
-(void)menuClose;
@end
