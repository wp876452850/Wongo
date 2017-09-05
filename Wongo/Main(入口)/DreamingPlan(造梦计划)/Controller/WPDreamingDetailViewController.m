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
#import "WPListModel.h"
#import "WPSearchUserModel.h"


static NSString * const listCell        = @"listCell";
static NSString * const introduceCell   = @"introduceCell";
static NSString * const userCell        = @"UserCell";
static NSString * const progressCell    = @"ProgressCell";
static NSString * const reuseIdentifier = @"ReuseIdentifier";

@interface WPDreamingDetailViewController ()<ChatKeyBoardDataSource,ChatKeyBoardDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField * _comment;
}
//参与交换
@property (nonatomic,strong)UIButton * joinDreaming;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * dataSource;

@property (nonatomic,strong)SDCycleScrollView * rollPlay;

@property (nonatomic,strong)NSMutableArray * rollPlayImages;

@property (nonatomic,strong)WPDreamingModel * model;

@property (nonatomic,strong)NSMutableArray * listDatas;

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
    self.listDatas = [NSMutableArray arrayWithCapacity:3];
    __block WPDreamingDetailViewController * weakSelf = self;
    /**查询商品所有信息*/
    [WPNetWorking createPostRequestMenagerWithUrlString:GetPlanUrl params:@{@"proid":weakSelf.plid} datas:^(NSDictionary *responseObject) {
        weakSelf.model = [WPDreamingModel mj_objectWithKeyValues:responseObject];
        [WPNetWorking createPostRequestMenagerWithUrlString:QueryProductUser params:@{@"proid":weakSelf.plid} datas:^(NSDictionary *responseObject) {
            NSArray * list = responseObject[@"list"];
            for (int i = 0;  i < list.count; i++) {
                WPListModel * model = list[i];
                [weakSelf.listDatas addObject:model];
            }
            
            [WPNetWorking createPostRequestMenagerWithUrlString:QueryUserCommentproduct params:@{@"proid":weakSelf.model.proid} datas:^(NSDictionary *responseObject) {
                NSArray * list = responseObject[@"list"];
                for (int i = 0;  i<list.count; i++) {
                    WPDreamingCommentsModel * model = [WPDreamingCommentsModel mj_objectWithKeyValues:list[i]];
                    [weakSelf.model.commentsModelArray addObject:model];
                }
                [weakSelf.tableView reloadData];
            }];

        }];
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
        cell.dataSourceArray = self.listDatas;
        return cell;
    }
    if (indexPath.section == 1) {
        WPProgressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:progressCell forIndexPath:indexPath];
        cell.model = _model;
        return cell;
    }
    
    if (indexPath.section == 2) {
        WPSearchUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userCell forIndexPath:indexPath];
        WPSearchUserModel * model = [[WPSearchUserModel alloc]init];
        model.uid = self.model.uid;
        model.uname = self.model.uname;
        model.url = self.model.url;
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 3) {
        WPDreamingDetailIntroduceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:introduceCell forIndexPath:indexPath];
        cell.name =_model.proname;
        cell.introduce = _model.remark;
         [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
        return cell;
    }
    else if (indexPath.section == 4){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        WPDreamingCommentsModel * model = _model.commentsModelArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        NSString * name = model.uname;
        NSString * comments = model.comment;
        NSString * totle = [NSString stringWithFormat:@"%@:%@",name,comments];
        CGSize size = [totle getSizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WINDOW_WIDTH, MAXFLOAT)];
        return size.height+5;
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
    _comment.text = text;
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
    NSString * uname         = model.uname;
    NSString * comments     = model.comment
    
    ;
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",uname,comments]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, uname.length+comments.length+1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, uname.length)];
    
    cell.textLabel.numberOfLines    = 0;
    cell.textLabel.attributedText   = attributedString;
    if (uname) {
        [cell.textLabel yb_addAttributeTapActionWithStrings:@[uname] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            
        }];
    }
}

//创建评论框
-(void)createCommentsTextFieldWithCell:(UITableViewCell *)cell{
    
    [cell.contentView removeAllSubviews];
    UITextField * commentsTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, WINDOW_WIDTH - 110, 30)];
    commentsTextField.placeholder = @"我来说两句";
    
    commentsTextField.font = [UIFont systemFontOfSize:15];
    [commentsTextField addTarget:self action:@selector(commentGoods) forControlEvents:UIControlEventTouchUpInside];

    [cell.contentView addSubview:commentsTextField];
    commentsTextField.userInteractionEnabled = NO;
    _comment = commentsTextField;
    
    UIButton * comment = [UIButton buttonWithType:UIButtonTypeCustom];
    comment.frame = commentsTextField.frame;
    comment.x-=5;
    comment.width+=5;
    comment.layer.masksToBounds   = YES;
    comment.layer.cornerRadius    = 5;
    comment.layer.borderColor     = GRAY_COLOR.CGColor;
    comment.layer.borderWidth     = 0.5f;
    [comment addTarget:self action:@selector(commentGoods) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:comment];
    
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
    //发布评论
    [WPNetWorking createPostRequestMenagerWithUrlString:CommentproductsUrl params:@{@"proid":self.model.proid,@"uid":[self getSelfUid],@"comment":_comment.text,@"commenttime":[self getNowTime]} datas:^(NSDictionary *responseObject) {
        WPDreamingCommentsModel * model = [[WPDreamingCommentsModel alloc]init];
        model.uname = [self getUserName];
        model.comment = _comment.text;
        [_model.commentsModelArray insertObject:model atIndex:0];
        [_tableView reloadData];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    //获取造梦规则菜单位置
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:5];
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    
    if (scrollView.contentOffset.y >= rect.size.height+rect.origin.y+80) {
        UIViewController * vc = [[UIViewController alloc]init];
        WPDreamingIntroduceView * dv = [[WPDreamingIntroduceView alloc]initWithFrame:vc.view.frame];
        self.model.introduceModel.dreamingStory = self.model.story;
        dv.model = self.model.introduceModel;
        [vc.view addSubview:dv];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark 界面跳转
-(void)goNextViewController{
    WPParticipateDreamingViewController * vc = [[WPParticipateDreamingViewController alloc]initWithProid:self.model.plid];
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
