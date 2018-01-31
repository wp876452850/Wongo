//
//  WPMenuScrollView.h
//  Wongo
//
//  Created by rexsu on 2017/2/9.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPMenuScrollView : UIScrollView

@property (nonatomic,strong)UIScrollView * collectionView;

-(instancetype)initWithFrame:(CGRect)frame withOptions:(NSDictionary *)options;

-(void)selectMenuWithIndex:(NSInteger)index;

@end
