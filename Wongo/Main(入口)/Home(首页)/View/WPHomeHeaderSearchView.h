//
//  WPHomeHeaderSearchView.h
//  Wongo
//
//  Created by rexsu on 2017/2/7.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPHomeHeaderSearchView : UIView

@property (nonatomic,strong)UICollectionView * colloctionView;

-(void)showSearchView;
-(void)hidenSearchView;
-(void)animationForSearchButton;
@end
