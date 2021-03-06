//
//  WPDreamingIntroduceView.m
//  Wongo
//
//  Created by rexsu on 2017/3/1.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPDreamingIntroduceView.h"
#import "LYConversationController.h"
#import "WPParticipateDreamingViewController.h"
#import "WPDreamingIntroduceView.h"

#define Titles @[@" 造梦详情",@" 造梦故事",@" 造梦规则"]
#define TitlesImages @[@"dreamingitemsisintroduced",@"dreamingrules",@"dreamingstory"]
#define TitlesSelectImages @[@"dreamingitemsisintroduced_select",@"dreamingrules_select",@"dreamingstory_select"]

@interface WPDreamingIntroduceView ()
@property (nonatomic,strong)UIButton * selectButton;

@property (nonatomic,strong)UITextView * contentShowLabel;



@property (nonatomic,strong)UIButton * joinDreaming;

@property (nonatomic,strong)UIButton * chatBtn;

@end

@implementation WPDreamingIntroduceView

-(UIButton *)chatBtn{
    if (!_chatBtn) {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chatBtn.frame = CGRectMake(0, WINDOW_HEIGHT - 50, 50, 50);
        _chatBtn.backgroundColor = ColorWithRGB(45, 102, 139);
        [_chatBtn addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chatBtn];
        [_chatBtn setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
    }
    return _chatBtn;
}

-(UIButton *)joinDreaming{
    if (!_joinDreaming) {
        _joinDreaming = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinDreaming.frame = CGRectMake(self.chatBtn.right, WINDOW_HEIGHT - 50, WINDOW_WIDTH - 50, 50);
        [_joinDreaming setTitle:@"参与造梦帮助梦想人实现梦想" forState:UIControlStateNormal];
        _joinDreaming.titleLabel.font = [UIFont systemFontOfSize:15];
        [_joinDreaming setBackgroundColor:ColorWithRGB(105, 152, 192)];
        [_joinDreaming setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_joinDreaming setTitleColor:WhiteColor forState:UIControlStateHighlighted];
        [_joinDreaming addTarget:self action:@selector(goNextViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinDreaming;
}

-(WPDreamingGoodsIntroductionTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WPDreamingGoodsIntroductionTableView alloc]initWithFrame:self.contentShowLabel.frame style:UITableViewStylePlain];
    }
    return _tableView;
}

-(UITextView *)contentShowLabel{
    if (!_contentShowLabel) {
        _contentShowLabel = [[UITextView alloc]initWithFrame:CGRectMake(5, 65, WINDOW_WIDTH - 10, WINDOW_HEIGHT - 125)];
    }
    return _contentShowLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
        [self addSubview:self.contentShowLabel];
        [self addSubview:self.tableView];
        [self addSubview:self.joinDreaming];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

-(void)initSubView{
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*WINDOW_WIDTH/3, 20, WINDOW_WIDTH/3, 40);
        if (i!=0) {
            [button.layer addSublayer:[WPBezierPath drowLineWithMoveToPoint:CGPointMake(0, 12) moveForPoint:CGPointMake(0, button.height-12) lineColor:WongoBlueColor]];
        }
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
        case 2:{
            [self bringSubviewToFront:self.contentShowLabel];
            self.contentShowLabel.text = nil;
            NSString * title = @"造梦计划：“造梦”专区。碗糕用户可在此发起“造梦”招募，通过与其他用户进行有价值的物品多环节交换，换取所需物品或最接近所需物品价值的物品。“造梦”过程实际是多环节等价交换的过程，但发起者可通过发起招募，最终实现不等价交换，完成拉环变钻戒的梦想！碗糕全体用户均可参与其中，碗糕用户须上传个人物品，填写完整清楚的物品描述，且交纳一定的保证金之后，发布至专区页面便可成功发起“造梦”。发起者须在有限的五次交换中，尽量将物品的价值最大化，在最后获得所需物品或与所需物品价值相近的东西。当发起者成功完成五次不同的交换之后，无论发起者是否成功“造梦”，此次“造梦”结束。“造梦计划”是碗糕平台含公益性质的一大功能，旨在帮助更多有梦、追梦、有需要的人们完成自己所想。\n";
            UIImage * image = [UIImage imageNamed:@"jiaocheng.jpg"];
            self.contentShowLabel.attributedText = [WPAttributedString attributedStringWithAttributedString:[[NSAttributedString alloc] initWithString:title] insertImage:image atIndex:title.length imageBounds:CGRectMake(0, 0, WINDOW_WIDTH - 10, image.size.height*((WINDOW_WIDTH - 10)/image.size.width))];
            _contentShowLabel.font = [UIFont systemFontOfSize:15];
            
        }
            break;
        case 1:{
            [self bringSubviewToFront:self.contentShowLabel];
            self.contentShowLabel.attributedText = nil;
            self.contentShowLabel.text = self.dreamingStory;
            _contentShowLabel.font = [UIFont systemFontOfSize:15];
        }
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
    if (dataSource!=nil) {
        self.tableView.dataSourceArray = dataSource;
    }
}

#pragma mark 界面跳转
-(void)goNextViewController{
    WPParticipateDreamingViewController * vc = [[WPParticipateDreamingViewController alloc]initWithProid:self.vc.model.plid];
    
    [[self findViewController:self]dismissViewControllerAnimated:YES completion:nil];
    [self.vc.navigationController pushViewController:vc animated:YES];
}

-(void)goChat{
    if ([self determineWhetherTheLogin]) {
        LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.vc.model.userModel.uid];
        vc.title = self.vc.model.userModel.uname;
        [[self findViewController:self]dismissViewControllerAnimated:YES completion:nil];
        [self.vc.navigationController pushViewController:vc animated:YES];
    }
}

@end
