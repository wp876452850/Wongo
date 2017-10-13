//
//  WPDreamingDetailViewController.m
//  Wongo
//
//  Created by rexsu on 2017/2/27.
//  Copyright © 2017年 Winny. All rights reserved.
//  造梦详情

#import "WPDreamingDetailViewController.h"
#import "SDCycleScrollView.h"
#import "WPDreamingGoodsIntroduceModel.h"
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
#import "WPDreamingDetailRecommendTableViewCell.h"


static NSString * const listCell        = @"listCell";
static NSString * const introduceCell   = @"introduceCell";
static NSString * const userCell        = @"UserCell";
static NSString * const progressCell    = @"ProgressCell";
static NSString * const reuseIdentifier = @"ReuseIdentifier";
static NSString * const recommendCell   = @"recommendCell";

@interface WPDreamingDetailViewController ()<ChatKeyBoardDataSource,ChatKeyBoardDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField * _comment;
    CGFloat _detailIntroduceTableViewCellHeight;
}
//参与交换
@property (nonatomic,strong)UIButton * joinDreaming;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * dataSource;

@property (nonatomic,strong)SDCycleScrollView * rollPlay;

@property (nonatomic,strong)NSMutableArray * rollPlayImages;



@property (nonatomic,strong)NSMutableArray * listDatas;

@property (nonatomic,strong)NSString * plid;

@property (nonatomic,strong)NSString * proid;

@property (nonatomic,strong)UIButton * backBtn;

@property (nonatomic,strong)UIButton * chatBtn;

@property (nonatomic,strong)ChatKeyBoard * commentKeyBoard;
//右侧功能按钮
@property (nonatomic,strong)UIButton * functionButton;

@end

@implementation WPDreamingDetailViewController
-(UIButton *)functionButton{
    if (!_functionButton) {
        _functionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _functionButton.size = _backBtn.size;
        _functionButton.right = WINDOW_WIDTH - _backBtn.left;
        _functionButton.y = _backBtn.y;
        _functionButton.backgroundColor = [UIColor blackColor];
        [_functionButton setTitle:@"···" forState:UIControlStateNormal];
        
        _functionButton.layer.masksToBounds = YES;
        _functionButton.layer.cornerRadius = _functionButton.width/2;
        _functionButton.alpha = 0.4f;
        [_functionButton addTarget:self action:@selector(clickfunctionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _functionButton;
}
-(void)clickfunctionButton{
    [self clickfunctionButtonWithplid:self.plid];
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
        _backBtn.frame = CGRectMake(10, 20, 30, 30);
    }
    return _backBtn;
}
-(SDCycleScrollView *)rollPlay{
    if (!_rollPlay) {
        _rollPlay = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH) imageURLStringsGroup:_rollPlayImages];
        _rollPlay.placeholderImage = [UIImage imageNamed:@"loadimage"];
        _rollPlay.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
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
        [_joinDreaming setTitle:@"参与造梦帮助梦想人实现梦想" forState:UIControlStateNormal];
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
        [_tableView registerNib:[UINib nibWithNibName:@"WPDreamingDetailRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:recommendCell];
        [_tableView registerClass:[WPProgressTableViewCell class] forCellReuseIdentifier:progressCell];
        [_tableView registerClass:[WPDreamingDetailListTableViewCell class] forCellReuseIdentifier:listCell];
        
        _tableView.tableHeaderView  = self.rollPlay;
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView.backgroundColor = WhiteColor;
    }
    return _tableView;
}

+(instancetype)createDreamingDetailWithProid:(NSString *)proid plid:(NSString *)plid{
    WPDreamingDetailViewController * vc = [[WPDreamingDetailViewController alloc]init];
    vc.plid = plid;
    vc.proid = proid;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self loadDatas];
    [self.view addSubview:self.joinDreaming];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.backBtn];
    [self.tableView addSubview:self.functionButton];
}

-(void)loadDatas{
    self.model          = [[WPDreamingModel alloc]init];
    self.rollPlayImages = [NSMutableArray arrayWithCapacity:3];
    self.listDatas = [NSMutableArray arrayWithCapacity:3];
    __block WPDreamingDetailViewController * weakSelf = self;
    /**查询商品所有信息*/
    [WPNetWorking createPostRequestMenagerWithUrlString:GetPlanUrl params:@{@"plid":weakSelf.plid} datas:^(NSDictionary *responseObject) {
        NSDictionary * list = responseObject[@"list"][0];
        weakSelf.model = [WPDreamingModel mj_objectWithKeyValues:list];
        NSMutableArray * rollPlays = [NSMutableArray arrayWithCapacity:3];
//        for (int i = 0; i <weakSelf.model.listimg.count; i++) {
//            [rollPlays addObject:weakSelf.model.listimg[i][@"proimg"]];
//        }
        [rollPlays addObject:list[@"url"]];
        weakSelf.rollPlay.imageURLStringsGroup = rollPlays;
        //查询用户信息
        [WPNetWorking createPostRequestMenagerWithUrlString:UserGetUrl params:@{@"uid":weakSelf.model.uid} datas:^(NSDictionary *responseObject) {
            //查询评论信息
            weakSelf.model.url = responseObject[@"url"];
            [WPNetWorking createPostRequestMenagerWithUrlString:QueryUserCommentproduct params:@{@"proid":weakSelf.model.proid} datas:^(NSDictionary *responseObject) {
                NSArray * list = responseObject[@"list"];
                for (int i = 0;  i<list.count; i++) {
                    WPDreamingCommentsModel * model = [WPDreamingCommentsModel mj_objectWithKeyValues:list[i]];
                    [weakSelf.model.commentsModelArray addObject:model];
                }
                //查询造梦故事
                [WPNetWorking createPostRequestMenagerWithUrlString:QueryPlanStory params:@{@"plan":weakSelf.plid} datas:^(NSDictionary *responseObject) {
                    weakSelf.model.introduceModel.dreamingStory = responseObject[@"strory"];
                    //查询参与商品
                    [WPNetWorking createPostRequestMenagerWithUrlString:QueryProductById params:@{@"plid":weakSelf.plid} datas:^(NSDictionary *responseObject) {
                        weakSelf.model.introduceModel.dreamingIntroduces = responseObject[@"list"];
                        [weakSelf.tableView reloadData];
                    }];
                }];
            }];
        }];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 5) {
        if (_model.commentsModelArray.count >= 5) {
            return 5;
        }
        return _model.commentsModelArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //商品信息
    if (indexPath.section == 0) {
        WPDreamingDetailListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
        cell.dataSourceArray = self.listDatas;
        return cell;
    }
    //平台推荐
    if (indexPath.section == 2) {
        WPDreamingDetailRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:recommendCell forIndexPath:indexPath];
        [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
        return cell;
    }
    //进度条
    if (indexPath.section == 1) {
        WPProgressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:progressCell forIndexPath:indexPath];
        cell.model = _model;
        return cell;
    }
    //用户信息
    if (indexPath.section == 3) {
        WPSearchUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userCell forIndexPath:indexPath];
        [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
        WPSearchUserModel * model = [[WPSearchUserModel alloc]init];
        model.uid = self.model.uid;
        model.uname = self.model.uname;
        model.url = self.model.url;
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.section == 4) {
        WPDreamingDetailIntroduceTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:introduceCell forIndexPath:indexPath];
        }

        cell.name =_model.proname;
        if (!cell.introduce) {
            cell.introduce = _model.remark;
        }
        [cell.layer addSublayer:[WPBezierPath cellBottomDrowLineWithTableViewCell:cell]];
        return cell;
    }
    else if (indexPath.section == 5){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        WPDreamingCommentsModel * model = _model.commentsModelArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCommentsLabelWithModel:model cell:cell];
        return cell;
    }
    else if (indexPath.section == 6){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        [self createCommentsTextFieldWithCell:cell];
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WPDreamingIntroduceView * view = [[WPDreamingIntroduceView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 240)];
    view.vc = self;
    view.dataSource = self.model.introduceModel.dreamingIntroduces;
    view.dreamingStory = self.model.introduceModel.dreamingStory;
    [cell.contentView addSubview:view];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }
    if (indexPath.section == 1) {
        return (WINDOW_WIDTH - 80)/3+20;
    }
    if (indexPath.section == 2) {
        return (WINDOW_WIDTH - 160)/4 +70;
    }
    if (indexPath.section == 3) {
        return 80;
    }
    if (indexPath.section == 4) {
        if (_detailIntroduceTableViewCellHeight > 70) {
            return _detailIntroduceTableViewCellHeight;
        }else{
            CGFloat cellHeight = [self.model.remark getSizeWithFont:[UIFont systemFontOfSize:14.f] maxSize:CGSizeMake(WINDOW_WIDTH, MAXFLOAT)].height + 70;
            _detailIntroduceTableViewCellHeight = cellHeight;
            return cellHeight;
        }
    }
    else if (indexPath.section == 5){
        NSArray * array = _model.commentsModelArray;
        WPDreamingCommentsModel * model = array[indexPath.row];
        NSString * name = model.uname;
        NSString * comments = model.comment;
        NSString * totle = [NSString stringWithFormat:@"%@:%@",name,comments];
        CGSize size = [totle getSizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(WINDOW_WIDTH, MAXFLOAT)];
        return size.height + 5;
    }
    else if (indexPath.section == 6){
        return 40;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 5) {
        return 50;
    }
    return .1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = WhiteColor;
    if (section == 5) {
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
    WPCommentModel * commentModel   = [[WPCommentModel alloc]init];
    commentModel.uname              = [self getUserName];
    commentModel.comment            = text;
    commentModel.commenttime        = [self getNowTime];
    commentModel.headImage          = [self getUserHeadPortrait];
    _comment.text                   = text;
    [self.view endEditing:YES];
}
#pragma mark ChatKeyBoardDataSource
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    return @[item1];
}
- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems{
    return nil;
}
#pragma mark 设置评论信息
//创建评论信息内容
-(void)createCommentsLabelWithModel:(WPDreamingCommentsModel*)model cell:(UITableViewCell *)cell{
    [cell.contentView removeAllSubviews];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    NSString * uname        = model.uname;
    NSString * comments     = model.comment;
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
    __block WPDreamingDetailViewController * weakSelf = self;
    [WPNetWorking createPostRequestMenagerWithUrlString:CommentproductsUrl params:@{@"proid":self.model.proid,@"uid":[self getSelfUid],@"comment":_comment.text,@"commenttime":[self getNowTime]} datas:^(NSDictionary *responseObject) {
        WPDreamingCommentsModel * model = [[WPDreamingCommentsModel alloc]init];
        model.uname = [self getUserName];
        model.comment = _comment.text;
        [weakSelf.model.commentsModelArray insertObject:model atIndex:0];
        [weakSelf.tableView reloadData];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    //获取造梦规则菜单位置
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:7];
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    
    if (scrollView.contentOffset.y >= rect.size.height+rect.origin.y+WINDOW_WIDTH-WINDOW_HEIGHT+80) {
        UIViewController * vc = [[UIViewController alloc]init];
        WPDreamingIntroduceView * dv = [[WPDreamingIntroduceView alloc]initWithFrame:vc.view.frame];
        dv.vc = self;
        dv.dreamingStory = self.model.introduceModel.dreamingStory;
        dv.dataSource = self.model.introduceModel.dreamingIntroduces;        
        [vc.view addSubview:dv];
        [self presentViewController:vc animated:YES completion:nil];
        scrollView.contentOffset = CGPointMake(0, rect.size.height+rect.origin.y+WINDOW_WIDTH-WINDOW_HEIGHT+80);
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
