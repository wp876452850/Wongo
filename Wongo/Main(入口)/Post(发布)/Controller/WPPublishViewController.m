//
//  WPPublishViewController.m
//  Wogou
//
//  Created by rexsu on 2016/11/29.
//  Copyright © 2016年 Winny. All rights reserved.
//

#import "WPPublishViewController.h"
#import "WPTabBarController.h"

#import "WPNewPushExchangeViewController.h"
#import "WPNewPushConsignmentViewController.h"
#import "WPNewPushDreamingViewController.h"

#import "WPPayDepositViewController.h"

#define PushTypeTitle           @[@"交换",@"寄卖",@"造梦"]
#define PushDescribeTitle       @[@"平台担保安全交换",@"平台检测商品寄卖",@"平台提供造梦计划"]
#define PushButtonIcon          @[@"exchangebtn_normal",@"consignment_normal",@"pushDreaming_normal"]
#define PushButtonSelectIcon    @[@"exchangebtn_selected",@"consignment_select",@"pushDreaming_selected"]

@interface WPPublishViewController ()
// 毛玻璃
@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic,strong)UIImageView * bgImage;

@end

@implementation WPPublishViewController

-(UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushbg"]];
        _bgImage.frame = CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    }
    return _bgImage;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
    
    //[self createEffectView];
    [self.view addSubview:self.bgImage];
    [self createButton];
}
#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self.navigationController removeFromParentViewController];
    }
}
#pragma mark - viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - CreateSubView
////毛玻璃
//-(void)createEffectView
//{
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
//    _effectView = effectView;
//    [self.view addSubview:_effectView];
//    self.effectView.frame = self.view.frame;
//    // 对应调整毛玻璃的效果
//    self.effectView.alpha = 1;
//}
//按钮
-(void)createButton{
    for (int i = 0; i<PushTypeTitle.count; i++)
    {
        UIImage * image = [UIImage imageNamed:PushButtonIcon[i]];
        UIButton * button       = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.bounds = CGRectMake(0, 0, 134, 134);
        button.centerX = self.view.width*(i%2*2+1)/4;
        button.centerY = self.view.centerY - 50;
        if (i==2) {
            button.centerX = self.view.width/2;
            button.centerY = self.view.centerY+150;
        }

        
        [self.view addSubview:button];
        [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:PushButtonSelectIcon[i]] forState:UIControlStateHighlighted];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH/3, 30)];
        label.top = button.bottom;
        label.font = [UIFont boldSystemFontOfSize:19.f];
        label.centerX = button.centerX;
        label.textColor = WhiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PushTypeTitle[i];
        [self.view addSubview:label];
        
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH/2, 30)];
        label1.top = label.bottom;
        label1.font = [UIFont systemFontOfSize:14.f];
        label1.centerX = button.centerX;
        label1.textColor = WhiteColor;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = PushDescribeTitle[i];
        [self.view addSubview:label1];
    }
}

-(void)push:(UIButton *)sender{
    if ([self determineWhetherTheLoginWithViewController:self]) {
        switch (sender.tag) {
            case 0:
            {
                WPNewPushExchangeViewController * vc = [[WPNewPushExchangeViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            }
                break;
            case 1:
            {   //FIXME:功能暂未开放
                //         [self showAlertNotOpenedWithBlock:nil];
                //         return;
                WPNewPushConsignmentViewController * vc = [[WPNewPushConsignmentViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            }
                break;
            case 2:{
                WPNewPushDreamingViewController * vc = [[WPNewPushDreamingViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - touchesBegan
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   [self dismissViewControllerAnimated:YES completion:nil];
}

@end


