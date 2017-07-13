//
//  WPClassificationView.m
//  Wongo
//
//  Created by rexsu on 2017/5/18.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPClassificationView.h"
#import "WPClassificationTableView.h"
#import "WPChoiceViewController.h"
#import "WPChoiceSubCollectionView.h"
#import "WPClassificationModel.h"
#define ButtonTitle @[@"一级分类",@"二级分类"]

@interface WPClassificationView ()
{
    ClassificationSelectBlock _block;
    AddViewForExchangeSubCollectionView _addBlock;
    NSInteger _primaryClassificationIndex;
    BOOL isOpen1;
    BOOL isOpen2;
}
@property (nonatomic,strong)NSMutableArray * icons;

@property (nonatomic,strong)NSMutableArray * senders;

@property (nonatomic,strong)NSMutableArray * classificationModels;

@property (nonatomic,strong)NSMutableArray * primaryClassificationTitles;

@property (nonatomic,strong)NSMutableArray * secondaryClassificationTitles;
@property (nonatomic,strong)WPClassificationTableView * primaryClassificationTableView;

@property (nonatomic,strong)WPClassificationTableView * secondaryClassificationTableView;


@end

@implementation WPClassificationView

-(WPClassificationTableView *)primaryClassificationTableView{
    if (!_primaryClassificationTableView) {
        _primaryClassificationTableView = [[WPClassificationTableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH /2, 200) style:UITableViewStylePlain];
        _primaryClassificationTableView.backgroundColor = WhiteColor;
        _primaryClassificationTableView.top = self.bottom;
        _primaryClassificationTableView.centerX = WINDOW_WIDTH/4;
        
    }
    return _primaryClassificationTableView;
}

-(WPClassificationTableView *)secondaryClassificationTableView{
    if (!_secondaryClassificationTableView) {
        _secondaryClassificationTableView = [[WPClassificationTableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH /2, 200) style:UITableViewStylePlain];
        _secondaryClassificationTableView.backgroundColor = WhiteColor;
        _secondaryClassificationTableView.top = self.bottom;
        _secondaryClassificationTableView.centerX = WINDOW_WIDTH/4*3;
    }
    return _secondaryClassificationTableView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self createClassificationButton];
        
    }
    return self;
}


-(void)createClassificationButton{
    _icons = [NSMutableArray arrayWithCapacity:3];
    _senders = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0;  i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, WINDOW_WIDTH / 2, 30);
        button.left = i*WINDOW_WIDTH/2;
        button.top  = 0;
        button.tag  = i;
        [button addTarget:self action:@selector(createSubClassificationButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:ButtonTitle[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_senders addObject:button];
        
        UIImageView * icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_gray"]];
        icon.bounds = CGRectMake(0, 0, 12, 8);
        icon.centerY = self.height/2;
        icon.centerX = button.centerX + 40;
        [_icons addObject:icon];
        [self addSubview:button];
        [self addSubview:icon];
    }
}

-(void)createSubClassificationButton:(UIButton *)sender{
    
    UIImageView * icon = self.icons[sender.tag];
    [self.primaryClassificationTableView getClassificationStringWithBlock:^(NSString *classification, NSInteger index) {
        UIButton * button0 = _senders[0];
        [button0 setTitle:classification forState:UIControlStateNormal];
        _primaryClassificationIndex = index;
        UIButton * button = _senders[1];
        
        [button setTitle:@"二级分类" forState:UIControlStateNormal];
        [self animationWithView:icon isOpen:isOpen1];
        isOpen1 = !isOpen1;
        
        _secondaryClassificationTitles = [NSMutableArray arrayWithCapacity:3];
        WPClassificationModel * model = self.classificationModels[_primaryClassificationIndex];
        for (int i = 0; i<model.listgc.count; i++) {
            NSDictionary * dic = model.listgc[i];
            [_secondaryClassificationTitles addObject:[dic objectForKey:@"gcname"]];
        }
        [_secondaryClassificationTableView removeSelect];
        _secondaryClassificationTableView.dataSourceArray = _secondaryClassificationTitles;
        
    }];
    [self.secondaryClassificationTableView getClassificationStringWithBlock:^(NSString *classification, NSInteger index) {
        UIButton * button = _senders[1];
        [button setTitle:classification forState:UIControlStateNormal];
        [self animationWithView:icon isOpen:isOpen2];
        isOpen2 = !isOpen2;
        _block(classification);
#warning 网络请求
    }];
    switch (sender.tag) {
        case 0:
        {
            [self animationWithView:icon isOpen:isOpen1];
            if (isOpen1) {
                [_primaryClassificationTableView menuClose];
            }else{
                [self.primaryClassificationTableView menuOpen];
                //是否已经请求过一级分类
                if (!_primaryClassificationTitles||_primaryClassificationTitles.count == 0) {
                    _primaryClassificationTitles = [NSMutableArray arrayWithCapacity:3];
                    [self loadDatas];
                    if (_addBlock) {
                        _addBlock(self.primaryClassificationTableView);
                    }
                }
            }
            isOpen1 =! isOpen1;
        }
            break;
        case 1:
        {
            [self animationWithView:icon isOpen:isOpen2];
            if (isOpen2) {
                [_secondaryClassificationTableView menuClose];
            }
            else{
                [self.secondaryClassificationTableView menuOpen];
                if (_addBlock) {
                    _addBlock(self.secondaryClassificationTableView);
                }
                
            }
            isOpen2 =! isOpen2;
        }
            break;
    }
    
}

-(void)loadDatas{
    [WPNetWorking createPostRequestMenagerWithUrlString:QueryClassoneUrl params:nil datas:^(NSDictionary *responseObject) {
        NSArray * listc = [responseObject objectForKey:@"listc"];
        _classificationModels = [NSMutableArray arrayWithCapacity:3];
        _primaryClassificationTitles = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < listc.count; i++) {
            WPClassificationModel * model = [WPClassificationModel mj_objectWithKeyValues:listc[i]];
            [_classificationModels addObject:model];
            [_primaryClassificationTitles addObject:model.cname];
        }
        _primaryClassificationTableView.dataSourceArray = _primaryClassificationTitles;
        
    }];
}

//点击后请求服务器
-(void)classificationSelectWithBlock:(ClassificationSelectBlock)block{
    _block = block;
}
-(void)classificationAddForExchangeSubCollectionViewWithBlock:(AddViewForExchangeSubCollectionView)block{
    _addBlock = block;
}


-(void)animationWithView:(UIView *)view isOpen:(BOOL)isOpen{
    CABasicAnimation *animation     =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    if (isOpen == YES) {
        animation.fromValue             = @(M_PI);
        animation.toValue               = @(M_PI*2);
    }else{
        animation.fromValue             = @(0.f);
        animation.toValue               = @(M_PI);
    }
    isOpen = !isOpen;
    animation.duration              = 0.5;
    animation.autoreverses          = NO;
    animation.fillMode              = kCAFillModeForwards;
    animation.removedOnCompletion   = NO;
    [view.layer addAnimation:animation forKey:nil];
}
@end
