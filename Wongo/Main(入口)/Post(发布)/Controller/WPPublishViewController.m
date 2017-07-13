//
//  WPPublishViewController.m
//  Wogou
//
//  Created by rexsu on 2016/11/29.
//  Copyright © 2016年 Winny. All rights reserved.
//

#import "WPPublishViewController.h"
#import "WPTabBarController.h"
#import "WPPushExchangeViewController.h"
#import "WPPushDreamingViewController.h"

#define PushTypeTitle   @[@"发布交换",@"发布造梦"]
#define PushButtonIcon  @[@"pushExchange",@"pushDreaming"]

@interface WPPublishViewController ()
// 毛玻璃
@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic,strong)UIImageView * bgImage;

@end

@implementation WPPublishViewController

-(UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushbg"]];
        _bgImage.bounds = CGRectMake(0, 0, 204, 62);
        _bgImage.center = CGPointMake(self.view.width/2, 130);
    }
    return _bgImage;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
    
   
    
    [self createEffectView];
    [self createButton];
    [self.view addSubview:self.bgImage];
    
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
//毛玻璃
-(void)createEffectView
{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectView = effectView;
    [self.view addSubview:_effectView];
    self.effectView.frame = self.view.frame;
    // 对应调整毛玻璃的效果
    self.effectView.alpha = 1;
}
//按钮
-(void)createButton{
    for (int i = 0; i<PushTypeTitle.count; i++)
    {
        UIButton * button       = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.bounds = CGRectMake(0, 0, 117, 117);
        button.centerX = self.view.width*(i%2*2+1)/4;
        button.centerY = self.view.centerY;
        [self.view addSubview:button];
        [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:PushButtonIcon[i]] forState:UIControlStateNormal];
    }
}

-(void)push:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            if ([self determineWhetherTheLoginWithViewController:self]) {
                WPPushExchangeViewController * vc = [[WPPushExchangeViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {   //FIXME:功能暂未开放
            [[self findViewController:self]showAlertNotOpenedWithBlock:nil];
            return;
            if ([self determineWhetherTheLoginWithViewController:self]) {
                WPPushDreamingViewController * vc = [[WPPushDreamingViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
            break;
    }
}

#pragma mark - touchesBegan
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end


