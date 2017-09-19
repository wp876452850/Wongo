//
//  WPDreamingIntroduceView.m
//  Wongo
//
//  Created by rexsu on 2017/3/1.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingIntroduceView.h"
#import "WPDreamingGoodsIntroductionTableView.h"
#define Titles @[@" 参加商品",@" 造梦规则",@" 造梦故事"]
#define TitlesImages @[@"dreamingitemsisintroduced",@"dreamingrules",@"dreamingstory"]
#define TitlesSelectImages @[@"dreamingitemsisintroduced_select",@"dreamingrules_select",@"dreamingstory_select"]

@interface WPDreamingIntroduceView ()
@property (nonatomic,strong)UIButton * selectButton;

@property (nonatomic,strong)UITextView * contentShowLabel;

@property (nonatomic,strong)WPDreamingGoodsIntroductionTableView * tableView;

@property (nonatomic,strong)UIButton * backButton;

@end

@implementation WPDreamingIntroduceView

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(5, WINDOW_HEIGHT - 55, WINDOW_WIDTH - 10, 50);
        [_backButton setTitle:@"关闭详情" forState:UIControlStateNormal];
        _backButton.backgroundColor = WongoBlueColor;
        [_backButton addTarget:[self findViewController:self] action:@selector(w_dismissViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(WPDreamingGoodsIntroductionTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WPDreamingGoodsIntroductionTableView alloc]initWithFrame:self.contentShowLabel.frame style:UITableViewStylePlain];
        _tableView.dataSourceArray = self.dataSource;
        
    }
    return _tableView;
}
-(UITextView *)contentShowLabel{
    if (!_contentShowLabel) {
        _contentShowLabel = [[UITextView alloc]initWithFrame:CGRectMake(5, 65, WINDOW_WIDTH - 10, WINDOW_HEIGHT - 125)];
        _contentShowLabel.font = [UIFont systemFontOfSize:15];
        _contentShowLabel.userInteractionEnabled = NO;
    }
    return _contentShowLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
        [self addSubview:self.contentShowLabel];
        [self addSubview:self.tableView];
        [self addSubview:self.backButton];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

-(void)initSubView{
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*WINDOW_WIDTH/3, 20, WINDOW_WIDTH/3, 40);
        [button setTitle:Titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:TitlesImages[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:TitlesSelectImages[i]] forState:UIControlStateSelected];
        button.backgroundColor = WhiteColor;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:WongoBlueColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = i;
        
        if (i == 0) {
            button.selected = YES;
            self.selectButton = button;
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)buttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            [self bringSubviewToFront:self.tableView];}
            break;
        case 1:{
            [self bringSubviewToFront:self.contentShowLabel];
            self.contentShowLabel.text = @"造梦计划：“造梦”专区。碗糕用户可在此发起“造梦”招募，通过与其他用户进行有价值的物品多环节交换，换取所需物品或最接近所需物品价值的物品。“造梦”过程实际是多环节等价交换的过程，但发起者可通过发起招募，最终实现不等价交换，完成拉环变钻戒的梦想！碗糕全体用户均可参与其中，碗糕用户须上传个人物品，填写完整清楚的物品描述，且交纳一定的保证金之后，发布至专区页面便可成功发起“造梦”。发起者须在有限的五次交换中，尽量将物品的价值最大化，在最后获得所需物品或与所需物品价值相近的东西。当发起者成功完成五次不同的交换之后，无论发起者是否成功“造梦”，此次“造梦”结束。“造梦计划”是碗糕平台含公益性质的一大功能，旨在帮助更多有梦、追梦、有需要的人们完成自己所想。";}
            break;
        case 2:{
            [self bringSubviewToFront:self.contentShowLabel];
            self.contentShowLabel.text = self.dreamingStory;}
            break;
    }
    _selectButton.selected = !_selectButton.selected;
    sender.selected = !sender.selected;    
    _selectButton = sender;
}

-(void)addGestures{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeGesture];
}

-(void)swipeGesture:(UISwipeGestureRecognizer *)swipe
{
    //向下轻扫
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
        
    { 
        [[self findViewController:self] w_dismissViewControllerAnimated];
    }
}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    if (dataSource) {
        self.tableView.dataSourceArray = dataSource;
    }
}

@end
