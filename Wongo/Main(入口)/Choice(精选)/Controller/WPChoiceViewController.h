//
//  WPChoiceViewController.h
//  Wongo
//
//  Created by rexsu on 2017/4/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPMenuScrollView.h"
#import "WPChoiceContentCollectionView.h"

@interface WPChoiceViewController : UIViewController

@property (nonatomic,strong)WPChoiceContentCollectionView * choiceContentCollectionView;
@property (nonatomic,strong)WPMenuScrollView    * menuScrollView;
@end
