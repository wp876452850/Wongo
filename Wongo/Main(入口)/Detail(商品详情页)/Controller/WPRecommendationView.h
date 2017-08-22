//
//  WPRecommendationView.h
//  Wongo
//
//  Created by  WanGao on 2017/8/21.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPRecommendationViewDelegate <NSObject>
//展示表滑动代理
-(void)didSrollWithCollectionView:(UICollectionView *)collectionView;

@end
@interface WPRecommendationView : UIView

-(instancetype)initWithFrame:(CGRect)frame dataSourceArray:(NSMutableArray *)dataSourceArray;

@property (nonatomic,assign)id<WPRecommendationViewDelegate> delegate;
@end
