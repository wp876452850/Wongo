//
//  WPHomeHeaderSearchView.m
//  Wongo
//
//  Created by rexsu on 2017/2/7.
//  Copyright © 2017年 Winny. All rights reserved.
//

#import "WPHomeHeaderSearchView.h"
#import "WPSearchGuideViewController.h"
#import <MapKit/MapKit.h>

@interface WPHomeHeaderSearchView ()<UICollectionViewDelegate,CLLocationManagerDelegate>
{
    CGFloat headerViewHeight;
}

@property (nonatomic,strong)UIButton * positioningButton;

@property (nonatomic,strong)UIButton * searchButton;

@property (nonatomic,strong)UIButton * shoppingCarButton;

@property (strong,nonatomic) CLLocationManager* locationManager;
@end
static NSString * contentOffset = @"contantOffset";


@implementation WPHomeHeaderSearchView


-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, WINDOW_WIDTH, 64);
        self.backgroundColor = ColorWithRGB(33, 34, 36);
        [self selfSubViewsFrame];
        [self startLocation];
        self.shoppingCarButton.hidden = YES;
    }
    return self;
}

-(void)showSearchView{
    self.hidden = NO;
    self.searchButton.hidden = NO;
    self.searchButton.alpha = self.alpha;
    [UIView animateWithDuration:0.25 animations:^{
        self.searchButton.frame = CGRectMake( - CGRectGetMaxX(self.positioningButton.frame) + 10 , 27, WINDOW_WIDTH - CGRectGetMaxX(self.positioningButton.frame) - CGRectGetMidX(self.shoppingCarButton.frame) - 20, 30);
    }];
}
//开始定位
-(void)startLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100.0f;
        if ([[[UIDevice currentDevice]systemVersion]doubleValue] >8.0){
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    else{
        [[self findViewController:self]showAlertWithAlertTitle:@"提示" message:@"定位失败,请在设置管理中开启" preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"确定"]];
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }break;
        default:break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    
    
    CLLocation *newLocation = locations[0];
    
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    
    
    [manager stopUpdatingLocation];
    
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        
        
        
        for (CLPlacemark * place in placemarks) {
            
            NSLog(@"name,%@",place.name);                      // 位置名
            
            NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
            
            NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
            
            NSLog(@"locality,%@",place.locality);              // 市
            
            NSLog(@"subLocality,%@",place.subLocality);        // 区
            
            NSLog(@"country,%@",place.country);                // 国家
            [_positioningButton setTitle:place.locality forState:UIControlStateNormal];
        }
    }];
    
}
-(void)hidenSearchView{
    self.hidden = YES;
    
    self.searchButton.hidden = YES;
}
-(void)animationForSearchButton{
    [UIView animateWithDuration:0.25 animations:^{
        self.positioningButton.alpha = 1;
        self.searchButton.alpha = 1;
        self.shoppingCarButton.alpha = 1;
        self.searchButton.frame = CGRectMake(CGRectGetMaxX(self.positioningButton.frame) + 10 , 27, WINDOW_WIDTH - CGRectGetMaxX(self.positioningButton.frame) - (WINDOW_WIDTH - CGRectGetMidX(self.shoppingCarButton.frame)) - 35, 30);
    }];
}
-(void)selfSubViewsFrame{
    [self.positioningButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.mas_equalTo(self.mas_centerY).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    [self.shoppingCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.centerY.mas_equalTo(self.mas_centerY).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

-(UIButton *)positioningButton{
    if (!_positioningButton) {
        _positioningButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _positioningButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_positioningButton];
    }
    return _positioningButton;
}

-(UIButton *)searchButton{
    if (!_searchButton) {
         _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"SearchBarBG"] forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"searchbtn"] forState:UIControlStateNormal];
        [_searchButton setTitle:@"输入商品名称" forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_searchButton setTitleColor:ColorWithRGB(102, 102, 102) forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(goSearchGuide) forControlEvents:UIControlEventTouchUpInside];
        _searchButton.frame = CGRectMake(CGRectGetMaxX(self.positioningButton.frame) + 10 , 27, WINDOW_WIDTH - CGRectGetMaxX(self.positioningButton.frame) - (WINDOW_WIDTH - CGRectGetMidX(self.shoppingCarButton.frame)) - 35, 28);
        [_searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        [self addSubview:_searchButton];
    }
    return _searchButton;
}

-(UIButton *)shoppingCarButton{
    if (!_shoppingCarButton) {
         _shoppingCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shoppingCarButton.backgroundColor = ColorWithRGB(23, 23, 23);
        [self addSubview:_shoppingCarButton];
    }
    return _shoppingCarButton;
}

-(void)goSearchGuide{
    //FIXME:功能暂未开放
    [[self findViewController:self]showAlertNotOpenedWithBlock:nil];
    return;
    WPSearchGuideViewController * vc = [[WPSearchGuideViewController alloc]init];
    WPTabBarController * tabBar = [WPTabBarController sharedTabbarController];
    UINavigationController * nav = [tabBar.childViewControllers firstObject];
    [nav pushViewControllerAndHideBottomBar:vc animated:YES];
}

#warning 1.0不做定位和购物车
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}

@end
