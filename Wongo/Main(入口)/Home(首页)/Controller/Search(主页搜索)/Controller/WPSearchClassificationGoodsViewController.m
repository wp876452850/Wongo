//
//  WPSearchClassificationGoodsViewController.m
//  Wongo
//
//  Created by  WanGao on 2017/9/19.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPSearchClassificationGoodsViewController.h"
#import "WPNewExchangeModel.h"

@interface WPSearchClassificationGoodsViewController ()

@property (nonatomic,strong)NSString * gcid;

@property (nonatomic,strong)NSMutableArray * dataSource;

@property (nonatomic,strong)UICollectionView * collectionView;
@end

@implementation WPSearchClassificationGoodsViewController

-(instancetype)initWithGcid:(NSString *)gcid{
    if (self = [super init]) {
        self.gcid = gcid;
    }
    return self;
}

-(void)loadDatas{
    self.dataSource = [NSMutableArray arrayWithCapacity:3];
    __block WPSearchClassificationGoodsViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryGoodById params:@{@"gcid":self.gcid} datas:^(NSDictionary *responseObject) {
        NSArray * list = responseObject[@"list"];
        for (int i = 1; i<list.count;i++) {
            WPNewExchangeModel * model = [WPNewExchangeModel mj_objectWithKeyValues:list[i]];
            [weakSelf.dataSource addObject:model];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
