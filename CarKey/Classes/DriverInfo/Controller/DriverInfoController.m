//
//  DriverInfoController.m
//  CarKey
//
//  Created by jiangyuanlu on 15/5/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import "DriverInfoController.h"
#import "DriverModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+Extension.h"
#import "MapViewController.h"
#import "MJExtension.h"
#import <MAMapKit/MAMapKit.h>

@interface DriverInfoController ()<MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *driveInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *driverHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *driverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverPhoneLabel;
@property (weak, nonatomic) IBOutlet UIView *driverStarsView;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;



//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderBtnBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;


@property (nonatomic,strong) DriverModel *driver;
@property (nonatomic,copy) NSString *driverStatus;
//@property (nonatomic,strong) UIButton *orderBtn;
@property (nonatomic,strong) MAMapView *mapView;

@property (nonatomic,assign) int updateCount;
@end

@implementation DriverInfoController
-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
//        [self.view addSubview:_mapView];
        _mapView.distanceFilter = 50.0;
        _mapView.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//        _mapView.delegate = self;
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.driverStatus = @"off";
    self.updateCount = 0;
    
    NSDictionary *driverDict = @{@"driverMobile":@"13888889999",
                                 @"driverName":@"刘强军",
                                 @"driverLevel":@4,
                                 @"driverOrderCount":@516,
                                 @"driverAcount":@1200,
                                 @"driverStatus":@1,
                                 @"headUrl":@"http://www.uimaker.com/uploads/allimg/121112/1_121112112013_5.png"};
    DriverModel *driverModel = [DriverModel objectWithKeyValues:driverDict];
    self.driver = driverModel;
    
    //get driver detail info
    NSDictionary *params = @{@"sid":self.sid};
    
    [[RequestManager getInstance] driverInfoWithServicePara:params success:^(NSDictionary *dictResult) {
        if ([[[dictResult valueForKey:@"code"] stringValue] isEqualToString:@"0"]) {
//            NSDictionary *driverInfoDict = [dictResult valueForKey:@"data"];
//            DriverModel *driverModel = [DriverModel objectWithKeyValues:driverInfoDict];
            
//            NSDictionary *driverDict = @{@"driverMobile":@"13888889999",
//                                         @"driverName":@"刘强军",
//                                         @"driverLevel":@4,
//                                         @"driverOrderCount":@516,
//                                         @"driverAcount":@1200,
//                                         @"driverStatus":@1,
//                                         @"headUrl":@"http://www.uimaker.com/uploads/allimg/121112/1_121112112013_5.png"};
//            DriverModel *driverModel = [DriverModel objectWithKeyValues:driverDict];
//            self.driver = driverModel;
        }
    } failure:^(NSString *errorMessage) {
        JYLLog(@"%@",errorMessage);
    }];
    
    
    
    self.driverNameLabel.text = self.driver.driverName;
    self.driverPhoneLabel.text = self.driver.driverMobile;
    self.orderCountLabel.text = self.driver.driverOrderCount;
    self.accountLabel.text =  self.driver.driverAcount;
    [self.driverHeadImgView sd_setImageWithURL:[NSURL URLWithString:self.driver.headUrl] placeholderImage:[UIImage imageNamed:@"haha"]];
    
    int redStarCount = self.driver.driverLevel;
    for (int i = 0; i < redStarCount; i++) {
        UIImageView *imgView = (UIImageView *)self.driverStarsView.subviews[i];
        imgView.image = [UIImage imageNamed:@"redStar"];
    }
    
    
    [self updateConstraints];
    
    //开启定位
    self.mapView.showsUserLocation = YES;
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.driverHeadImgView.layer.cornerRadius = self.driverHeadImgView.bounds.size.width * 0.5;
    self.driverHeadImgView.layer.masksToBounds = YES;
    
    self.orderBtn.layer.cornerRadius = 5;
    self.orderBtn.layer.masksToBounds = YES;
    
    
    
}
- (IBAction)onOffWork:(id)sender {    
    if ([self.driverStatus isEqualToString:@"on"]) {
        /** 司机下班，结束位置更新 */
        self.mapView.delegate = nil;
        self.driverStatus = @"off";
        [self.orderBtn setTitle:@"onWork" forState:UIControlStateNormal];
    }else{
        /** 司机上班，开始位置更新 */
        [self.mapView userLocation];
        self.mapView.delegate = self;
        self.driverStatus = @"on";
        [self.orderBtn setTitle:@"offWork" forState:UIControlStateNormal];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MapViewController alloc] init]];
//        [self presentViewController:nav animated:YES completion:nil];
    }
    /*
    NSString *status = nil;
    if ([self.driverStatus isEqualToString:@"on"]) {
        status = @"off";
    }else
        status = @"on";
    
    NSDictionary *param = @{@"sid":self.sid,@"status":status};
    [[RequestManager getInstance] driverOnOffWorkWithServicePara:param success:^(NSDictionary *dictResult) {
        if ([[dictResult valueForKey:@"code"]isEqualToString:@"0"]) {
            //if on work success, jump to map view
            if ([status isEqualToString:@"on"]) {
                //change driver status
                self.driverStatus = @"on";
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MapViewController alloc] init]];
                [self presentViewController:nav animated:YES completion:nil];
            }else{
                //change driver status
                self.driverStatus = @"off";
            }
        }
    } failure:^(NSString *errorMessage) {
        JYLLog(@"%@",errorMessage);
    }];
    */
}

/**
 *  当位置更新时，会进定位回调，通过回调函数，能够获取到定位点的经纬度坐标
 */
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
        //        NSLog(@"latitude:%f,longitude:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.updateCount++;
        self.driverNameLabel.text = [NSString stringWithFormat:@"%f-%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
        self.driverPhoneLabel.text = [NSString stringWithFormat:@"更新%d次",self.updateCount];
        
        NSString *lat = [NSString stringWithFormat:@"%f",userLocation.coordinate.latitude];
        NSString *lng = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
        
        NSDictionary *paramDict = @{@"sid":self.sid,@"lat":lat,@"lng":lng};
        [[RequestManager getInstance] driverUpdateLocWithServicePara:paramDict success:^(NSDictionary *dictResult) {
            if ([[[dictResult valueForKey:@"code"] stringValue] isEqualToString:@"0"]) {
                JYLLog(@"位置更新成功");
            }
        } failure:^(NSString *errorMessage) {
            JYLLog(@"%@",errorMessage);
        }];
        
    }
}

-(void)updateConstraints{
    //[super updateViewConstraints];
    
    CGFloat height = kScreenH;
    CGFloat percent = height / 620;
    //    CGFloat percent = 240 / 620;
    self.bottomViewHeightConstraint.constant = self.bottomViewHeightConstraint.constant * percent;
    
    self.headViewTopConstraint.constant = self.headViewTopConstraint.constant * percent;
    self.headViewWidthConstraint.constant = self.headViewWidthConstraint.constant * percent;
    
    self.headViewHeightConstraint.constant = self.headViewWidthConstraint.constant;
    
    self.orderBtnBottomConstraint.constant *= percent;
    self.orderBtnHeightConstraint.constant *= percent;
    if (height<=480) {
        self.orderBtnBottomConstraint.constant = 20;
        self.orderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    
    self.driverHeadImgView.layer.cornerRadius = self.headViewWidthConstraint.constant *0.5;
}

@end
