//
//  WPAddressEditViewController.m
//  Wongo
//
//  Created by rexsu on 2016/12/26.
//  Copyright © 2016年 Wongo. All rights reserved.
//

#import "WPAddressEditViewController.h"
#import "WPRegionTableViewCell.h"
#import "WPAddressOtherTableViewCell.h"
#import "CityPickView.h"
#import "WPMyNavigationBar.h"
#import "WPAddressOtherTableViewCell.h"

@interface WPAddressEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSDictionary * dateSource;

@property (nonatomic,strong)NSString * recipient;
@property (nonatomic,strong)NSString * phone;
@property (nonatomic,strong)NSString * address;
@property (nonatomic,strong)NSString * detailAddress;
@property (nonatomic,assign)NSInteger  adid;
@property (nonatomic, strong) WPMyNavigationBar * customNav;
@property (nonatomic,assign)WPAddressManageStyle style;
@end

@implementation WPAddressEditViewController

- (void)setIsPresent:(BOOL)isPresent{
    _isPresent = isPresent;
    if (isPresent) {
        [self.customNav.leftButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(instancetype)initWithStyle:(WPAddressManageStyle)style dateSource:(NSDictionary *)dateSource{
    self = [super init];
    if (self) {
        [self.view addSubview:self.tableView];
        self.style = style;
        
        WPMyNavigationBar * customNav = [[WPMyNavigationBar alloc]init];
        
        [self.view addSubview:customNav];
        [customNav.leftButton addTarget:self action:@selector(w_popViewController) forControlEvents:UIControlEventTouchUpInside];
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [customNav addSubview:rightButton];
        self.customNav = customNav;
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(customNav.leftButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
        if (style == WPAddressNewStyle) {
            customNav.title.text = @"新建地址";
        }
        else{
        if (dateSource) {
            self.dateSource         = dateSource;
            customNav.title.text    = @"修改地址";
            self.address                = [dateSource objectForKey:@"address"];
            self.recipient              = [dateSource objectForKey:@"recipient"];
            self.phone                  = [dateSource objectForKey:@"phone"];
            self.detailAddress = [dateSource objectForKey:@"detailAddress"];
            self.adid                   = [dateSource objectForKey:@"adid"];
            }
        }
    }
    return self;
}
//保存地址
-(void)saveAddress{
    if (_address.length ==0||_recipient.length==0||_detailAddress.length == 0) {
        [self showAlertWithAlertTitle:@"提示" message:@"请输入完整的信息" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    if (![self isMobileNumber:_phone]) {
        [self showAlertWithAlertTitle:@"提示" message:@"电话号码格式不正确" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
        return;
    }
    //新建
    if (self.style == WPAddressNewStyle) {
        [WPNetWorking createPostRequestMenagerWithUrlString:AddAddressedUrl params:@{@"uid":[self getSelfUid],@"phone":_phone,@"address":[NSString stringWithFormat:@"%@%@",self.address,self.detailAddress],@"consignee":self.recipient} datas:^(NSDictionary *responseObject) {
            
            
            if (self.saveBlock) {
                self.saveBlock(_recipient,_phone,_address,_detailAddress,[[responseObject objectForKey:@"adid"] integerValue]);
            }
            if (_isPresent) {
                [self disablesAutomaticKeyboardDismissal];
                [self dismissViewControllerAnimated:YES completion:nil];
                return ;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    //修改
    else{
        [WPNetWorking createPostRequestMenagerWithUrlString:UpdateAddressedUrl params:@{@"adid":@(self.adid),@"phone":self.phone,@"address":[NSString stringWithFormat:@"%@%@",self.address,self.detailAddress],@"consignee":self.recipient} datas:^(NSDictionary *responseObject) {
            
            if (self.saveBlock) {
                self.saveBlock(_recipient,_phone,_address,_detailAddress,[[responseObject objectForKey:@"adid"] integerValue]);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    
}

-(UITableView *)tableView
{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WINDOW_WIDTH, WINDOW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[WPRegionTableViewCell class] forCellReuseIdentifier:@"regionCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"WPAddressOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = ColorWithRGB(230, 230, 230);
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        WPRegionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"regionCell" forIndexPath:indexPath];
        cell.initialAddress = [self.dateSource objectForKey:@"address"];
        [cell getAddressDataWithBlock:^(NSString *address) {
            _address = address;
            [self.view endEditing:YES];
        }];
        [cell cancelChangeAddress:^{
            [self.view endEditing:YES];
        }];
        [cell cityViewAction];
        return cell;
    }
    
    WPAddressOtherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textField.delegate = self;
    
    //设置监听试试监听输入框内容改变
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (indexPath.section == 0 ) {
        cell.textField.tag = indexPath.row;
        switch (indexPath.row) {
            case 0:
            {
                cell.title.text = @"收件人:";
                cell.textField.placeholder = @"请输入收件人姓名";
                if (self.dateSource) {
                    cell.textField.text = [self.dateSource objectForKey:@"recipient"];
                }
            }
                break;
            case 1:
            {
                cell.title.text = @"联系方式:";
                cell.textField.placeholder = @"请输入联系人电话";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                if (self.dateSource) {
                    cell.textField.text = [self.dateSource objectForKey:@"phone"];
                }
                
            }
                break;
            
        }
    }else{
        cell.textField.tag = 3;
        cell.title.text = @"详细地址:";
        cell.textField.placeholder = @"请输入详细地址";
        if (self.dateSource) {
            cell.textField.text = [self.dateSource objectForKey:@"detailAddress"];
        }
        
    }
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.markedTextRange == nil) {
        switch (textField.tag) {
            case 0:
            {
                _recipient = textField.text;
            }
                break;
            case 1:
            {
               _phone = textField.text;
                
            }
                break;
            case 3:
            {
                _detailAddress = textField.text;
            }
                break;
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
