//
//  WPStoreUserInformationView.h
//  Wongo
//
//  Created by  WanGao on 2017/8/24.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WPStoreUserInformationBlock)(NSInteger tag);
@interface WPStoreUserInformationView : UIView

-(instancetype)initWithFrame:(CGRect)frame uid:(NSString *)uid;

-(void)getmuneTagWithBlock:(WPStoreUserInformationBlock)block;

@end
