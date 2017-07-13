//
//  WPSelectAlterView.h
//  Wongo
//
//  Created by rexsu on 2017/3/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectAlertBlock)(NSString * string,NSString * gcid);
@interface WPSelectAlterView : UIView

+(instancetype)createURLSelectAlterWithFrame:(CGRect)frame urlString:(NSString *)urlString params:(NSDictionary *)params block:(SelectAlertBlock)block;
+(instancetype)createArraySelectAlterWithFrame:(CGRect)frame array:(NSArray *)array block:(SelectAlertBlock)block;

@end
