//
//  WPDreamingDetailViewController.h
//  Wongo
//
//  Created by rexsu on 2017/2/27.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPDreamingDetailViewController : UIViewController

/**
 @param plid 商品id
 @param subid 主题id
 */
+(instancetype)createDreamingDetailWithPlid:(NSString *)plid subid:(NSString *)subid;

@end
