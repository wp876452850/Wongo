//
//  WPChoiceContentCollectionView.m
//  Wongo
//
//  Created by rexsu on 2017/4/12.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPChoiceContentCollectionView.h"
#import "WPChoiceSubCollectionView.h"
#import "WPChioceSubTableView.h"
#import "WPDreameChioceSubView.h"

#define ChoiceCellItmeSize CGSizeMake(WINDOW_WIDTH , WINDOW_WIDTH * 0.66)

#define HeaderMenuHeight 104
#define RollWithContentInterval 30
#define RollPlayHeight 200
@interface WPChoiceContentCollectionView ()
@property (nonatomic,strong)NSArray * subClass;
@property (nonatomic,strong)NSArray * subCellClass;
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

+(instancetype)createChoiceCollectionWithFrame:(CGRect)frame SubViewsClassArray:(NSArray<Class> *)subClass cellClassArray:(NSArray<Class> *)cellClass loadDatasUrls:(NSArray<NSString *> *)loadDatasUrls{

    WPChoiceContentCollectionView * chioceCollection = [[WPChoiceContentCollectionView alloc]initWithFrame:frame];
    chioceCollection.subCellClass                    = cellClass;
    chioceCollection.subClass                        = subClass;
    chioceCollection.urls                            = loadDatasUrls;
    chioceCollection.contentSize = CGSizeMake(WINDOW_WIDTH * 3, 0);
    
    WPChioceSubTableView * tableView = [[WPChioceSubTableView alloc]initWithFrame:CGRectMake(0, 0, chioceCollection.width, chioceCollection.height) style:UITableViewStyleGrouped cellClass:chioceCollection.subCellClass[0] loadDatasUrl:chioceCollection.urls[0]];
     [chioceCollection addSubview:tableView];
    
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing           = 0;
    layout.minimumInteritemSpacing      = 0;
    layout.itemSize                     = ChoiceCellItmeSize;
    if ([chioceCollection.urls[1] isEqualToString:DreamingHomePageUrl]) {
        layout.sectionInset = UIEdgeInsetsMake(RollPlayFrame.size.height + 30, 0, 0, 0);
    }else{
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    WPChoiceSubCollectionView *collectionView = [[WPChoiceSubCollectionView alloc]initWithFrame:CGRectMake(WINDOW_WIDTH, 0, chioceCollection.width, chioceCollection.height) collectionViewLayout:layout loadDatasUrl:chioceCollection.urls[1] cellClass:chioceCollection.subCellClass[1]];
     [chioceCollection addSubview:collectionView];
    
    UICollectionViewFlowLayout *layout2  = [[UICollectionViewFlowLayout alloc] init];
    layout2.minimumLineSpacing           = 0;
    layout2.minimumInteritemSpacing      = 0;
    layout2.itemSize                     = ChoiceCellItmeSize;
    layout2.sectionInset                 = UIEdgeInsetsMake(0, 0, 0, 0);
    
    WPDreameChioceSubView *collectionView2 = [[WPDreameChioceSubView alloc]initWithFrame:CGRectMake(2 * WINDOW_WIDTH, 0, chioceCollection.width, chioceCollection.height) collectionViewLayout:layout2 cellClass:chioceCollection.subCellClass[2]];
     [chioceCollection addSubview:collectionView2];
    
    return chioceCollection;
}
@end
