//
//  WPDreamingDetailViewController.m
//  Wongo
//
//  Created by rexsu on 2017/2/27.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情

#import "WPDreamingDetailViewController.h"
#import "SDCycleScrollView.h"
#import "WPDreamingCommentsModel.h"
#import "WPSearchModel.h"
#import "WPSearchUserTableViewCell.h"
#import "WPDreamingIntroduceModel.h"
#import "WPDreamingIntroduceView.h"
#import "WPDreamingModel.h"
#import "WPProgressTableViewCell.h"
#import "WPParticipateDreamingViewController.h"
#import "LYConversationController.h"
#import "WPDreamingDetailListTableViewCell.h"
#import "WPDreamingDetailIntroduceTableViewCell.h"
#import "WPCommentModel.h"


static NSString * const listCell        = @"listCell";
static NSString * const introduceCell   = @"introduceCell";
static NSString * const userCell        = @"UserCell";
static NSString * const progressCell    = @"ProgressCell";
static NSString * const reuseIdentifier = @"ReuseIdentifier";

@interface WPDreamingDetailViewController ()<ChatKeyBoardDataSource,ChatKeyBoardDelegate,UITableViewDelegate,UITableViewDataSource>
//参与交换
@property (nonatomic,strong)UIButton * joinDreaming;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * dataSource;

@property (nonatomic,strong)SDCycleScrollView * rollPlay;

@property (nonatomic,strong)NSMutableArray * rollPlayImages;

@property (nonatomic,strong)WPDreamingModel * model;

@property (nonatomic,strong)NSString * plid;

@property (nonatomic,strong)NSString * subid;

@property (nonatomic,strong)UIButton * backBtn;

@property (nonatomic,strong)UIButton * chatBtn;

@property (nonatomic,strong)ChatKeyBoard * commentKeyBoard;
@end

@implementation WPDreamingDetailViewController


-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _backBtn.frame = CGRectMake(10, 20, 30, 30);
    }
    return _backBtn;
}
-(SDCycleScrollView *)rollPlay{
    if (!_rollPlay) {
        _rollPlay = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH) imageURLStringsGroup:_rollPlayImages];
    }
    return _rollPlay;
}

-(ChatKeyBoard *)commentKeyBoard{
    if (!_commentKeyBoard) {
        _commentKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _commentKeyBoard.delegate = self;
        _commentKeyBoard.dataSource = self;
        _commentKeyBoard.allowVoice = NO;
        _commentKeyBoard.allowFace = NO;
        _commentKeyBoard.allowMore = NO;
        _commentKeyBoard.allowSwitchBar = NO;
        _commentKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        [self.view addSubview:_commentKeyBoard];
        [self.view bringSubviewToFront:_commentKeyBoard];
    }
    return _commentKeyBoard;
}

-(UIButton *)chatBtn{
    if (!_chatBtn) {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chatBtn.frame = CGRectMake(0, WINDOW_HEIGHT - 50, 50, 50);
        _chatBtn.backgroundColor = ColorWithRGB(45, 102, 139);
        [_chatBtn addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_chatBtn];
        [_chatBtn setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];

    }
    return _chatBtn;
}
-(UIButton *)joinDreaming{
    if (!_joinDreaming) {
        _joinDreaming = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinDreaming.frame = CGRectMake(self.chatBtn.right, WINDOW_HEIGHT - 50, WINDOW_WIDTH - 50, 50);
        [_joinDreaming setTitle:@"参与造梦" forState:UIControlStateNormal];
        _joinDreaming.titleLabel.font = [UIFont systemFontOfSize:15];
        [_joinDreaming setBackgroundColor:ColorWithRGB(105, 152, 192)];
        [_joinDreaming setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_joinDreaming setTitleColor:WhiteColor forState:UIControlStateHighlighted];
        [_joinDreaming addTarget:self action:@selector(goNextViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinDreaming;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - 50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"WPSearchUserTableViewCell"  bundle:nil]forCellReuseIdentifier:userCell];
        [_tableView registerNib:[UINib nibWithNibName:@"WPDreamingDetailIntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:introduceCell];
        [_tableView registerClass:[WPProgressTableViewCell class] forCellReuseIdentifier:progressCell];
        [_tableView registerClass:[WPDreamingDetailListTableViewCell class] forCellReuseIdentifier:listCell];
        
        _tableView.tableHeaderView  = self.rollPlay;
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView.backgroundColor = WhiteColor;
    }
    return _tableView;
}

+(instancetype)createDreamingDetailWithProid:(NSString *)proid subid:(NSString *)subid{
    WPDreamingDetailViewController * vc = [[WPDreamingDetailViewController alloc]init];
    vc.plid = proid;
    vc.subid = subid;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self loadDatas];
    [self.view addSubview:self.joinDreaming];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.backBtn];
}

-(void)loadDatas{
    self.model          = [[WPDreamingModel alloc]init];
    self.rollPlayImages = [NSMutableArray arrayWithCapacity:3];
    _plid = @"1";
    /**查询商品所有信息*/
    [WPNetWorking createPostRequestMenagerWithUrlString:GetPlanUrl params:@{@"proid":_plid} datas:^(NSDictionary *responseObject) {
        
        
        
    }];
    /**轮播图*/
    [WPNetWorking createPostRequestMenagerWithUrlString:SelectProduct params:nil datas:^(NSDictionary *responseObject) {
        NSArray * array = responseObject[@"list"];
        NSMutableArray * images = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0 ; i < array.count; i++) {
            NSDictionary * dic = array[i];
            [images addObject:dic[@"url"]];
        }
        _rollPlay.imageURLStringsGroup = images;
    }];
    
    
    
    [_rollPlayImages addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488343696607&di=6b2b2d9170e81866eb10ce92ffd729b1&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fa2cc7cd98d1001e9460fd63bbd0e7bec54e797d7.jpg"];
    [_rollPlayImages addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488343753469&di=bd25b0ec8294590994f1d587d50bb702&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fb2de9c82d158ccbf79a00f8c1cd8bc3eb1354163.jpg"];
    [_rollPlayImages addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488343764929&di=c9611e27e8ac4193f78590e3ef862c8a&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F55e736d12f2eb93895023c7fd7628535e4dd6fcb.jpg"];
    [_rollPlayImages addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488343781255&di=ba9989ee0369ff1e81b45f49cad2befe&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F1e30e924b899a901760b8f321f950a7b0208f5fc.jpg"];
    _model.images_url   = _rollPlayImages;
    
    WPSearchUserModel * userModel = [[WPSearchUserModel alloc]init];
    userModel.url           = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488344992155&di=844982cc46812af732872ffe8609c6ce&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F08f790529822720e561834f379cb0a46f31fabe1.jpg";
    userModel.uname         = @"优品家居";
    userModel.signature     = @"klllll;";
    userModel.attention     = @"1";
    userModel.fansNumber    = @"123";
    userModel.goodsNum      = @"45";
    userModel.uid           = @"1111";
    _model.userModel = userModel;
    
    NSMutableArray * commentArray               = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i<4; i++) {
        WPDreamingCommentsModel * commentsModel = [[WPDreamingCommentsModel alloc]init];
        commentsModel.name = @"Random";
        commentsModel.comments                  = @"这卖的是什么鬼玩意垃圾坑死人了，大家不要被他骗 了，真的黑心商家，去你妹的混蛋的点点滴滴多";
        [commentArray addObject:commentsModel];
    }
    _model.commentsModelArray                   = commentArray;
    
    
    WPDreamingIntroduceModel * introduceModel   = [[WPDreamingIntroduceModel alloc]init];
    
    introduceModel.dreamingIntroduce    = @"吉欧斯额衣服哦私有化覅搜一苏覅护士看见对方换了卡健身房苦涩合肥路设法看似简单护肤开始交电话费了速尔还管一UR涵盖了客家话粒子开始交电话费构建动画进入韩国如何管理局开始离开惊魂甫定蓝思科技东方红赶快来就肯定会放假了可是看见的复合弓快捷快递健身房韩国肯定就是发过火流口水的脚后跟故人具借款人离开在路上的人工湖软件管理看似简单立刻感觉";
    introduceModel.dreamingRules        = @"我们的规则就是:会计核算的购房款三国杀要发个一uetfgbuygsirugbjaskjdfblkjblkjasbdkjf极乐空间如果邻居家哈哈无色偶记哈维尔 为很快就好   几块了好人纷纷离开文件 啦看江山如画了案例为客户发热";
    introduceModel.dreamingStory        = @"我的故事是:空间的书房里就开始点开链接刚回到家空间链接拉市人大良好看到了；看见对方；离开金额非人工 ser；沟通困了就睡的；更健康吃饭了接口；立刻进入；觉得愧疚；记录大雪纷飞快递费更健康劳动者发来了登录；科技六路董事长卡罗拉的高素质开了蓝灯个同时了；空间的风格；空间相册；铝扣板功能老师";
    _model.introduceModel               = introduceModel;
    
    
    NSString * price        = @"120";
    NSString * unit         = @"￥";
    NSString * progress     = @"0.3";
    _model.price            = price;
    _model.unit             = unit;
    _model.progress         = progress;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) {
        if (_model.commentsModelArray.count >= 5) {
            return 5;
        }
        return _model.commentsModelArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WPDreamingDetailListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
        cell.subid = self.subid;
        cell.dataSourceArray = [NSMutableArray arrayWithObjects:@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",@"123",nil];
        return cell;
    }
    if (indexPath.section == 1) {
        WPProgressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:progressCell forIndexPath:indexPath];
        cell.model = _model;
        return cell;
    }
    
    if (indexPath.section == 2) {
        WPSearchUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userCell forIndexPath:indexPath];
        cell.model = _model.userModel;;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 3) {
        WPDreamingDetailIntroduceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:introduceCell forIndexPath:indexPath];
        
        return cell;
    }
    else if (indexPath.section == 4){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        WPDreamingCommentsModel * model = _model.commentsModelArray[indexPath.row];
        [self createCommentsLabelWithModel:model cell:cell];
        return cell;
    }
    else if (indexPath.section == 5){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        [self createCommentsTextFieldWithCell:cell];
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WPDreamingIntroduceView * view = [[WPDreamingIntroduceView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 240)];
    view.model = self.model.introduceModel;
    [cell.contentView addSubview:view];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 65;
    }
    if (indexPath.section == 1) {
        return (WINDOW_WIDTH - 80)/3+40;
    }
    if (indexPath.section == 2) {
        return 80;
    }
    if (indexPath.section == 3) {
        return 160;
    }
    else if (indexPath.section == 4){
        NSArray * array = _model.commentsModelArray;
        WPDreamingCommentsModel * model = array[indexPath.row];
        NSString * name = model.name;
        NSString * comments = model.comments;
        NSString * totle = [NSString stringWithFormat:@"%@:%@",name,comments];
        CGSize size = [totle getSizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WINDOW_WIDTH, MAXFLOAT)];
        return size.height;
    }
    else if (indexPath.section == 5){
        return 40;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return 50;
    }
    if (section == 5||section == 0) {
        return 0;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = WhiteColor;
    if (section == 4) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, WINDOW_WIDTH, 20)];
        label.backgroundColor = WhiteColor;
        NSArray * array = _model.commentsModelArray;
        label.text = [NSString stringWithFormat:@"    所有%ld条评论",array.count];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = GRAY_COLOR;
        [view addSubview:label];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = WhiteColor;
    
}
#pragma mark - ChatKeyBoardDelegate 发送评论
-(void)chatKeyBoardSendText:(NSString *)text{
    if (![self determineWhetherTheLogin]) {
        return;
    }
    WPCommentModel * commentModel = [[WPCommentModel alloc]init];
    commentModel.subid = self.subid;
    commentModel.uname = [self getUserName];
    commentModel.comment = text;
    commentModel.commenttime = [self getNowTime];
    commentModel.headImage = [self getUserHeadPortrait];
    
//    __block WPCommentModel * model = commentModel;
//    __block WPDreamingDetailViewController * weakSelf = self;
//    [WPNetWorking createPostRequestMenagerWithUrlString:AddCommentUrl params:@{@"uid":[self getSelfUid],@"gid":commentModel.gid,@"comment":commentModel.comment,@"commenttime":commentModel.commenttime} datas:^(NSDictionary *responseObject) {
//        
//        [weakSelf.exchangeModel.commentsModelArray insertObject:model atIndex:0];
//        [weakSelf.tableView reloadData];
//    }];
    
    [self.view endEditing:YES];
}
//创建评论信息内容
-(void)createCommentsLabelWithModel:(WPDreamingCommentsModel*)model cell:(UITableViewCell *)cell{
    [cell.contentView removeAllSubviews];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    NSString * name         = model.name;
    NSString * comments     = model.comments;
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",name,comments]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, name.length+comments.length+1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, name.length)];
    
    cell.textLabel.numberOfLines    = 0;
    cell.textLabel.attributedText   = attributedString;
    [cell.textLabel yb_addAttributeTapActionWithStrings:@[name] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        
    }];
}

//创建评论框
-(void)createCommentsTextFieldWithCell:(UITableViewCell *)cell{
    
    [cell.contentView removeAllSubviews];
    UITextField * commentsTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, WINDOW_WIDTH - 110, 30)];
    commentsTextField.placeholder = @"我来说两句";
    commentsTextField.layer.masksToBounds   = YES;
    commentsTextField.layer.cornerRadius    = 15;
    commentsTextField.font = [UIFont systemFontOfSize:15];
    [commentsTextField addTarget:self action:@selector(commentGoods) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:commentsTextField];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.frame = CGRectMake(WINDOW_WIDTH - 80, 5, 60, 30);
    button.backgroundColor = SelfOrangeColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius  = 10;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(pushComments) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
}

-(void)commentGoods{
    [self.commentKeyBoard keyboardUpforComment];
}



-(void)pushComments{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    if (scrollView.contentOffset.y >= 700) {
        UIViewController * vc = [[UIViewController alloc]init];
        WPDreamingIntroduceView * dv = [[WPDreamingIntroduceView alloc]initWithFrame:vc.view.frame];
        dv.model = self.model.introduceModel;
        [vc.view addSubview:dv];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

#pragma mark 界面跳转
-(void)goNextViewController{
    WPParticipateDreamingViewController * vc = [[WPParticipateDreamingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goChat{
    if ([self determineWhetherTheLogin]) {
        LYConversationController *vc = [[LYConversationController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.model.userModel.uid];
        vc.title = self.model.userModel.uname;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
