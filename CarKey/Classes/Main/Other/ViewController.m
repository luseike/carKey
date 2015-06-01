//
//  ViewController.m
//  CarKey
//
//  Created by jiangyuanlu on 15/5/26.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MANaviRoute.h"
#import "CommonUtility.h"

@interface ViewController ()<MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) AMapSearchAPI *search;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@property (nonatomic, strong) AMapRoute *route;
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
@end

@implementation ViewController

@synthesize startCoordinate         = _startCoordinate;
@synthesize destinationCoordinate   = _destinationCoordinate;
@synthesize currentCourse = _currentCourse;

#define TileOverlayViewControllerCoordinate CLLocationCoordinate2DMake(39.910695, 116.372830)

-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
        _mapView.delegate = self;
    }
    return _mapView;
}
-(AMapSearchAPI *)search{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] initWithSearchKey:@"093e6544b2c64b36134e853c1f88bebb" Delegate:self];
        _search.language = AMapSearchLanguage_zh_CN;
    }
    return _search;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.startCoordinate = CLLocationCoordinate2DMake(39.910267, 116.370888);
    self.destinationCoordinate  = CLLocationCoordinate2DMake(39.989872, 116.481956);
    

    //MAMapTypeSatellite 卫星地图;MAMapTypeStandardNight 夜景地图;MAMapTypeStandard 正常地图
    self.mapView.mapType = MAMapTypeStandard;
    
    //不显示指南针
    self.mapView.showsCompass = NO;
    
    //不显示比例尺
    self.mapView.showsScale = NO;
    
    self.mapView.rotateEnabled = NO;
    
    //开启定位
    self.mapView.showsUserLocation = YES;
    
    /** 
     MAUserTrackingModeFollow 跟随用户位置移动，并将定位点设置成地图中心点
     MAUserTrackingModeFollowWithHeading 跟随用户的位置和角度移动
     */
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow];
    
    //若想自定义定位经度圈样式，需先将 MAMapView 的customizeUserLocationAccuracyCircleRepresentation 属性设置为 YES。
    //self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    
    /** 关键字搜索
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = @"KTV";
    poiRequest.city = @[@"shanghai"];
    poiRequest.requireExtension = YES;
    [self.search AMapPlaceSearch:poiRequest];
    */
    
    /** 路径搜索
     AMapNavigationSearchRequest *naviRequest = [[AMapNavigationSearchRequest alloc] init];
     naviRequest.searchType = AMapSearchType_NaviDrive;
     naviRequest.requireExtension = YES;
     naviRequest.origin = [AMapGeoPoint locationWithLatitude:39.994949 longitude:116.447265];
     naviRequest.destination = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
     //发起路径搜索
     [self.search AMapNavigationSearch:naviRequest];
     */
    
    /** 正向地理编码
    AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init];
    geoRequest.searchType = AMapSearchType_Geocode;
    geoRequest.address = @"闵行";
    geoRequest.city = @[@"shanghai"];
    [self.search AMapGeocodeSearch:geoRequest];
     */
    
    /** 逆地理编码
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:31.111658 longitude:121.375969];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeoRequest];
    
    //31.111658, 121.375969
     */
    
    /** 输入提示
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = @"国";
    tipsRequest.city = @[@"shanghai"];
    [self.search AMapInputTipsSearch:tipsRequest];
     */
    
    /** 行政区划查询
    AMapDistrictSearchRequest *districtRequest = [[AMapDistrictSearchRequest alloc] init];
    districtRequest.keywords = @"闵行区";
    districtRequest.requireExtension = YES;
    [self.search AMapDistrictSearch:districtRequest];
     */
    
//    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.989614 longitude:116.481763];
//    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.983456 longitude:116.315495];
//    
//    NSArray *startPoints = @[startPoint];
//    NSArray *endPoints   = @[endPoint];
//    
//    //驾车路径规划（未设置途经点、导航策略为速度优先）
//    [_naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
//    
//    //步行路径规划
//    [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
    
    
    /* 驾车导航搜索. */
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviDrive;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    
    
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapNavigationSearch:navi];
    
    
    [self.view addSubview:self.mapView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //添加标注数据对象
    // iOS SDK提供标注点的协议<MAAnnotation>，它包含一个标注的基本信息：标注View的中心点坐标、标题和副标题。同时还封装了一个标注类MAPointAnnotation，它定义了一个位于指定位置的标注数据对象
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    [self.mapView addAnnotation:pointAnnotation];
}

#pragma mark - AMapSearchDelegate
/**
 *  实现行政区划查询的回调函数
 */
-(void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response{
    NSLog(@"%@",response);
}

/**
 *  实现输入提示的回调函数
 */
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    if (response.tips.count == 0) {
        return;
    }
    for (AMapTip *tip in response.tips) {
        NSLog(@"%@",tip.description);
    }
}
/**
 *  实现逆地理编码的回调函数
 */
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != nil) {
        NSLog(@"%@",response.regeocode);
    }
}
/**
 *  实现正向地理编码的回调函数
 */
-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (response.geocodes.count == 0) {
        return;
    }
    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
    NSString *strGeocodes = @"";
    for (AMapTip *p in response.geocodes) {
        strGeocodes = [NSString stringWithFormat:@"%@\n geocode:%@",strGeocodes,p.description];
    }
    
    NSString *result = [NSString stringWithFormat:@"%@ \n %@",strCount,strGeocodes];
    NSLog(@"Geocode: %@",result);
}
/**
 *  实现路径搜索的回调函数
 */
-(void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response{
//    if (response.route == nil) {
//        return;
//    }
//    NSString *route = [NSString stringWithFormat:@"Navi: %@",response.route];
//    NSLog(@"%@",route);
    
//    if (self.searchType != request.searchType)
//    {
//        return;
//    }
    
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
//    [self updateTotal];
    self.currentCourse = 0;
//
//    [self updateCourseUI];
//    [self updateDetailUI];
    
    [self presentCurrentCourse];
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    /* 公交导航. */
//    if (self.searchType == AMapSearchType_NaviBus)
//    {
//        self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse]];
//    }
    /* 步行，驾车导航. */
//    else
//    {
    MANaviType type = MANaviType_Drive;//self.searchType == AMapSearchType_NaviDrive? MANaviType_Drive : MANaviType_Walking;
    
    
        self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type];
//    }
    
    //    [self.naviRoute setNaviAnnotationVisibility:NO];
    
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines] animated:YES];
}

/**
 *  实现POI搜索的回调函数
 */
-(void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response{
    if (response.pois.count == 0) {
        return;
    }
    
    NSString *strCount = [NSString stringWithFormat:@"count:%d",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion:%@",response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI:%@",strPoi,p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@",strCount,strSuggestion,strPoi];
    
    NSLog(@"Place:%@",result);
}

#pragma mark - MAMapViewDelegate
/**
 *  当位置更新时，会进定位回调，通过回调函数，能够获取到定位点的经纬度坐标
 */
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
//        NSLog(@"latitude:%f,longitude:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}



/**
 *  设置标注样式
 *  iOS SDK提供了一个默认的大头针标注view——MAPinAnnotationView，通过它可以设置大头针是否被拾起拖拽、是否以动画效果显示等等
 */
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout = YES; //设置气泡可以弹出
        annotationView.image = [UIImage imageNamed:@"haha"];
        annotationView.animatesDrop = YES; //设置标注动画显示
//        annotationView.pinColor = MAPinAnnotationColorGreen;
        annotationView.centerOffset = CGPointMake(0, -11);
        return annotationView;
    }
    return nil;
}

@end
