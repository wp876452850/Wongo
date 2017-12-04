//
//  WPChoiceContentCollectionView.m
//  Wongo
//
//  Created by rexsu on 2017/4/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPChoiceContentCollectionView.h"
#import "WPChoiceSubCollectionView.h"
//#import "WPDreameChioceSubView.h"
#import "WPChoiceSubTableView.h"
#import "WPConsignmentCollectionView.h"

#define ChoiceCellItmeSize CGSizeMake(WINDOW_WIDTH , WINDOW_WIDTH * 0.66)

#define HeaderMenuHeight 104
#define RollWithContentInterval 30
#define RollPlayHeight 200
@interface WPChoiceContentCollectionView ()
/**请求的rul，2个*/
@property (nonatomic,strong)NSArray * urls;
@end
@implementation WPChoiceContentCollectionView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled                   = YES;
        self.showsHorizontalScrollIndicator  = NO;
        self.backgroundColor                 = [UIColor whiteColor];
    }
    return self;
}

+(instancetype)createChoiceCollectionWithFrame:(CGRect)frame loadDatasUrls:(NSArray<NSString *> *)loadDatasUrls{

    WPChoiceContentCollectionView * chioceCollection = [[WPChoiceContentCollectionView alloc]initWithFrame:frame];
    chioceCollection.urls                            = loadDatasUrls;
    chioceCollection.contentSize = CGSizeMake(WINDOW_WIDTH * loadDatasUrls.count, 0);
    
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(WINDOW_WIDTH, 0, 0, 0);
    
    //交换表
    WPChoiceSubCollectionView *collectionView = [[WPChoiceSubCollectionView alloc]initWithFrame:CGRectMake(WINDOW_WIDTH, 0, chioceCollection.width, chioceCollection.height) collectionViewLayout:layout loadDatasUrl:chioceCollection.urls[0]];
     [chioceCollection addSubview:collectionView];

    //造梦表
    WPChoiceSubTableView * tableView = [[WPChoiceSubTableView alloc]initWithFrame:CGRectMake(0, 0, chioceCollection.width, chioceCollection.height) style:UITableViewStyleGrouped url:chioceCollection.urls[1]];
    [chioceCollection addSubview:tableView];
    
    //寄卖表
//    UICollectionViewFlowLayout *consignmentLayout  = [[UICollectionViewFlowLayout alloc] init];

//    WPConsignmentCollectionView * consignmentCollectionView = [[WPConsignmentCollectionView alloc]initWithFrame:CGRectMake(WINDOW_WIDTH*2, 0, WINDOW_WIDTH, chioceCollection.height) collectionViewLayout:consignmentLayout];
//    [chioceCollection addSubview:consignmentCollectionView];
    
    return chioceCollection;
}
@end
