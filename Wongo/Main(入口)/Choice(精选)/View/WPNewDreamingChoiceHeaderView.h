//
//  WPNewDreamingChoiceHeaderView.h
//  Wongo
//
//  Created by  WanGao on 2017/8/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WPNewDreameingChoiceMenuButtonClickBlock)(NSString *parame);

@interface WPNewDreamingChoiceHeaderView : UIView

-(instancetype)initWithPostersImages:(NSArray *)postersImages;

@end
