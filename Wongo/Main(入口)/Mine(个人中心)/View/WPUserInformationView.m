//
//  WPUserInformationView.m
//  我的
//
//  Created by rexsu on 2016/11/28.
//  Copyright © 2016年 Winny. All rights reserved.
//  用户信息

#import "WPUserInformationView.h"
#import "LoginViewController.h"
#import "SKFCamera.h"
#import "WPPhotoLibrary.h"
#import "WPSetUpViewController.h"

#import "WPTabBarController.h"
#import "WPFansViewController.h"
#import "WPEnjoyViewController.h"
#import "WPConcernUserViewController.h"

#import "LoginViewController.h"
#import "LYConversationListController.h"

#define HeadPortrait_Bounds CGRectMake(0, 0, 80, 80)

@interface WPUserInformationView ()<WPPhotoLibraryDelegate,RCIMUserInfoDataSource>
//
@property (nonatomic,assign)CGRect            selfFrame;
//背景图片
@property (nonatomic,strong)UIImageView     * bgImage;
//头像
@property (nonatomic,strong)UIImageView     * headPortrait;
//用户名
@property (nonatomic,strong)UILabel         * userName;
//大V标识
@property (nonatomic,strong)UIImageView     * vipLogo;
//签名
@property (nonatomic,strong)UILabel         * signature;
//关注人数
@property (nonatomic,strong)UILabel         * attentionNumber;
//粉丝人数
@property (nonatomic,strong)UILabel         * fansNumber;
//喜欢
@property (nonatomic,strong)UILabel         * enjoyNumber;
//消息按钮
@property (nonatomic,strong)UIButton        * message;
@end

@implementation WPUserInformationView
- (void)changeMessageBtnDot{
    int n = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    if (n) {
        [_message setBackgroundImage:[UIImage imageNamed:@"message_select"] forState:UIControlStateNormal];
    }else{
        [_message setBackgroundImage:[UIImage imageNamed:@"message_normal"] forState:UIControlStateNormal];
    }
}
#pragma mark - 懒加载
-(UIImageView *)bgImage
{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]init];
        _bgImage.image = [UIImage imageNamed:@"headerBGImage.jpg"];
        _bgImage.alpha = 1;
    }
    return _bgImage;
}

-(UIImageView *)headPortrait
{
    if (!_headPortrait) {
        _headPortrait = [[UIImageView alloc]init];
#warning 后期修改成数据
        _headPortrait.image = [UIImage imageNamed:@"1"];
        //画圆
        [_headPortrait roundWithWithCornerRadius:40];
        _headPortrait.layer.borderWidth = 1;
        _headPortrait.layer.borderColor = [UIColor grayColor].CGColor;
            }
    return _headPortrait;
}

#pragma markr - init
#warning 后期初始化时添加一个字典接收数据
-(instancetype)initWithFrame:(CGRect)frame Type:(UserType)type{
    
    self = [[WPUserInformationView alloc]initWithFrame:frame];
    self.selfFrame = frame;
    self.clipsToBounds = YES;
    [self addSubview:self.bgImage];
    
    
    self.backgroundColor = [UIColor whiteColor];
    [self createWithType:type];
    return self;
}
#pragma mark - 创建不同样式
-(void)createWithType:(UserType)type
{
    switch (type) {
        case UserTypeNotLoggedIN:
        {
            [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.mas_offset(0);
            }];
            //未登录样式
            UIButton * login = [UIButton buttonWithType:UIButtonTypeCustom];
            [login setTitle:@"登录" forState:UIControlStateNormal];
            [login addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:login];
            [login mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_bgImage.mas_centerX);
                make.centerY.mas_equalTo(_bgImage.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
            break;
            //登录样式
        case UserTypeHaveLogin:
        {
            RCIMClient * client = [[RCIMClient alloc]init];
            NSLog(@"%d",[client getTotalUnreadCount]);
            
            [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_offset(0);
                make.top.mas_equalTo(self).offset(-40);
                make.height.mas_equalTo(WINDOW_HEIGHT);
            }];
            //位置板
            UIView * view = [[UIView alloc]init];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(0);
            }];
            //白边背景
            UILabel * label = [[UILabel alloc]init];
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.centerY.mas_equalTo(self.mas_bottom).offset(-self.bounds.size.height / 2);
                make.size.mas_equalTo(CGSizeMake(84, 84));
            }];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 42;
            label.backgroundColor = [UIColor whiteColor];
            
            //白色大圆背景
            UIView * whiteBg = [[UIView alloc]init];
            whiteBg.backgroundColor = [UIColor whiteColor];
            [self addSubview:whiteBg];
            whiteBg.layer.masksToBounds = YES;
            whiteBg.layer.cornerRadius = 400;
            
            [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(label.mas_centerY);
                make.centerX.mas_equalTo(view.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(800, 800));
            }];
            
            //覆盖头像按钮
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.centerY.mas_equalTo(self.mas_bottom).offset(-self.bounds.size.height / 2);
                make.size.mas_equalTo(CGSizeMake(80, 80));
            }];
            [button addTarget:self action:@selector(selectCameraOrPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            [self addSubview:self.headPortrait];
            [_headPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(view.mas_centerX);
                make.centerY.mas_equalTo(self.mas_bottom).offset(-self.bounds.size.height / 2);
                make.size.mas_equalTo(CGSizeMake(80, 80));
            }];
            [self createSetUpAndMessageBtn];
            [self createInforMation];
        }
            break;
    }
}

//创建用户名、签名、关注、粉丝、喜欢部分
-(void)createInforMation{
    self.userName = [[UILabel alloc]init];
    self.vipLogo = [[UIImageView alloc]init];
    self.signature = [[UILabel alloc]init];
    self.attentionNumber = [[UILabel alloc]init];
    self.fansNumber = [[UILabel alloc]init];
    self.enjoyNumber = [[UILabel alloc]init];
    
    [self addSubview:self.userName];
    [self addSubview:self.vipLogo];
    [self addSubview:self.signature];
    [self addSubview:self.attentionNumber];
    [self addSubview:self.fansNumber];
    [self addSubview:self.enjoyNumber];
#warning 后期修改数据
    
    
    _userName.text          = @"                               ";
    _signature.text         = @"                               ";
    _attentionNumber.text   = @" ";
    _fansNumber.text        = @" ";
    _enjoyNumber.text       = @" ";
    //设置居中
    _userName.textAlignment = NSTextAlignmentCenter;
    _signature.textAlignment = NSTextAlignmentCenter;
    _attentionNumber.textAlignment = NSTextAlignmentCenter;
    _fansNumber.textAlignment = NSTextAlignmentCenter;
    _enjoyNumber.textAlignment = NSTextAlignmentCenter;
    //设置字体大小
    _userName.font = [UIFont systemFontOfSize:17];
    _signature.font = [UIFont systemFontOfSize:15];
    _attentionNumber.font = [UIFont systemFontOfSize:14];
    _fansNumber.font = [UIFont systemFontOfSize:14];
    _enjoyNumber.font = [UIFont systemFontOfSize:14];
    //设置字体颜色
    _userName.textColor = [UIColor blackColor];
    _signature.textColor = [UIColor lightGrayColor];
    _attentionNumber.textColor = [UIColor orangeColor];
    _fansNumber.textColor = [UIColor orangeColor];
    _enjoyNumber.textColor = [UIColor orangeColor];
    
    //设置约束
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headPortrait.mas_bottom).offset(5);
        CGSize size = [_userName.text getSizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(WINDOW_WIDTH, MAXFLOAT)];
        make.size.mas_equalTo(CGSizeMake(size.width, 30));
        make.centerX.mas_equalTo(_headPortrait.mas_centerX);
    }];
    [_vipLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userName.mas_right).offset(3);
        make.centerY.mas_equalTo(_userName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        
    }];
    [_signature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userName.mas_bottom).offset(3);
        make.centerX.mas_equalTo(_userName.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH, 30));
        
    }];
    
    [_attentionNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_signature.mas_bottom).offset(10);
        make.left.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH / 3, 30));
    }];
    [_fansNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_signature.mas_bottom).offset(10);
        make.left.mas_equalTo(_attentionNumber.mas_right);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH / 3, 30));
    }];
    [_enjoyNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_signature.mas_bottom).offset(10);
        make.left.mas_equalTo(_fansNumber.mas_right);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH / 3, 30));
    }];
    
    UILabel * attention = [[UILabel alloc]init];
    UILabel * fans      = [[UILabel alloc]init];
    UILabel * enjoy     = [[UILabel alloc]init];
    [self addSubview:attention];
    [self addSubview:fans];
    [self addSubview:enjoy];
    
    attention.text  = @"关注";
    fans.text       = @"粉丝";
    enjoy.text      = @"喜欢";
    
    attention.textAlignment = NSTextAlignmentCenter;
    fans.textAlignment      = NSTextAlignmentCenter;
    enjoy.textAlignment     = NSTextAlignmentCenter;
    
    attention.font          = [UIFont systemFontOfSize:14];
    fans.font               = [UIFont systemFontOfSize:14];
    enjoy.font              = [UIFont systemFontOfSize:14];
    
    attention.textColor     = [UIColor blackColor];
    fans.textColor          = [UIColor blackColor];
    enjoy.textColor         = [UIColor blackColor];
    
    [attention  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_attentionNumber.mas_bottom);
        make.left.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH / 3, 30));
    }];
    
    [fans mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_attentionNumber.mas_bottom);
        make.left.mas_equalTo(_attentionNumber.mas_right);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH / 3, 30));
    }];
    
    [enjoy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_attentionNumber.mas_bottom);
        make.left.mas_equalTo(_fansNumber.mas_right);
        make.size.mas_equalTo(CGSizeMake(WINDOW_WIDTH / 3, 30));
    }];
    
    UIButton * attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * fansBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * enjoyBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionBtn.tag        = 1;
    fansBtn.tag             = 2;
    enjoyBtn.tag            = 3;

    [self addSubview:attentionBtn];
    [self addSubview:fansBtn];
    [self addSubview:enjoyBtn];
    
    [attentionBtn addTarget:self action:@selector(goNetxViewController:) forControlEvents:UIControlEventTouchUpInside];
    [fansBtn addTarget:self action:@selector(goNetxViewController:) forControlEvents:UIControlEventTouchUpInside];
    [enjoyBtn addTarget:self action:@selector(goNetxViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(_attentionNumber).offset(0);
        make.bottom.mas_equalTo(fans.mas_bottom);
    }];
    
    [fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(_fansNumber).offset(0);
        make.bottom.mas_equalTo(attention.mas_bottom);
    }];
    
    [enjoyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(_enjoyNumber).offset(0);
        make.bottom.mas_equalTo(enjoy.mas_bottom);
    }];
    [self loadDatas];
}
-(void)loadDatas{
    __weak WPUserInformationView * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":[self getSelfUid]} datas:^(NSDictionary *responseObject) {
        weakSelf.userName.text = [responseObject objectForKey:@"uname"];
        [weakSelf.headPortrait sd_setImageWithURL:[NSURL URLWithString:[responseObject objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"1.png"]];
        NSLog(@"%@",[responseObject objectForKey:@"url"]);
        weakSelf.signature.text = [responseObject objectForKey:@"signature"];
    }];
}

#pragma mark - 创建设置按钮和消息按钮
- (void)createSetUpAndMessageBtn{
    
    UIButton * setUp = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * message = [UIButton buttonWithType: UIButtonTypeCustom];
    setUp.tag = 111;
    message.tag = 222;
    [self addSubview:setUp];
    [self addSubview:message];
    self.message = message;
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(44);
        make.left.mas_equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(25, 21));
    }];
    [setUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(44);
        make.right.mas_equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [setUp setBackgroundImage:[UIImage imageNamed:@"setup"] forState:UIControlStateNormal];
    
#warning 后期修改成根据数据显示不同图标
    
    [message setBackgroundImage:[UIImage imageNamed:@"message_normal"] forState:UIControlStateNormal];
    
    [setUp addTarget:self action:@selector(jumpViewController:) forControlEvents:UIControlEventTouchUpInside];
    [message addTarget:self action:@selector(jumpViewController:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)goNetxViewController:(UIButton *)sender{
    UINavigationController * nav = [self getNavigationControllerOfCurrentView];
    switch (sender.tag) {
        case 1:
        {
            [self showAlter];
//            WPConcernUserViewController * vc = [[WPConcernUserViewController alloc]init];
//            [nav pushViewControllerAndHideBottomBar:vc animated:YES];
        }
            break;
        case 2:
        {
            [self showAlter];
//            WPFansViewController * vc = [[WPFansViewController alloc]init];
//            [nav pushViewControllerAndHideBottomBar:vc animated:YES];
            
        }
            break;
        case 3:
        {
            //[self showAlter];
            WPEnjoyViewController * vc = [[WPEnjoyViewController alloc]init];
            [nav pushViewControllerAndHideBottomBar:vc animated:YES];
        }
            break;
    }
}


-(void)showAlter{
    [[self findViewController:self] showAlertWithAlertTitle:@"提示" message:@"功能暂未开放" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
}


-(void)selectCameraOrPhotoLibrary
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self jumpCamera];
    }];
    UIAlertAction * photoLibrary = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self jumpPhotoLibrary];
    }];
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:camera];
    [alertController addAction:photoLibrary];
    [alertController addAction:cancle];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

-(void)jumpCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        SKFCamera *homec=[[SKFCamera alloc]init];
        __weak typeof(self)myself=self;
        homec.fininshcapture=^(UIImage *ss){
            if (ss) {
                myself.headPortrait.image= ss;
#warning 后期上传服务器
            }
        } ;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:homec animated:NO completion:^{}];}
    else{
        //NSLog(@"相机调用失败");
    }
}

-(void)jumpPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        WPPhotoLibrary * photoLibrary = [[WPPhotoLibrary alloc]init];
        photoLibrary.photoDelegate = self;
    }
}

-(void)getSelectPhotoWithImage:(UIImage *)image
{
    self.headPortrait.image = image;
    [WPNetWorking uploadedMorePhotosWithUrlString:UpdataUserHeaderImage image:image params:@{@"uid":[self getSelfUid]}];
    NSData * headimage = [NSKeyedArchiver archivedDataWithRootObject:image];
    [[NSUserDefaults standardUserDefaults]setObject:headimage forKey:User_Head];
}

- (void)jumpViewController:(UIButton *)sender
{
    
    WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
    UINavigationController * nav = [tabBar.childViewControllers lastObject];
    switch (sender.tag) {
        case 111:
        {
            WPSetUpViewController * setUp = [[WPSetUpViewController alloc]init];
            setUp.userName = self.userName.text;
            setUp.signature = self.signature.text;
            [nav pushViewControllerAndHideBottomBar:setUp animated:YES];
        }
            break;
        case 222:
        {   
//            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            LYConversationListController * message = [[LYConversationListController alloc]init];
            [nav pushViewControllerAndHideBottomBar:message animated:YES];
        }
            break;
    }
}



-(void)goLogin{
    LoginViewController * vc = [[LoginViewController alloc]init];
    UINavigationController *vc1 =[self findViewController:self].navigationController;
    [vc1 pushViewController:vc animated:YES];
}
@end
