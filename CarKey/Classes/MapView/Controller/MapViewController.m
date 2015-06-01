//
//  MapViewController.m
//  CarKey
//
//  Created by jiangyuanlu on 15/5/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CommonUtility.h"
#import "LineDashPolyline.h"
#import "MANaviRoute.h"

const NSString *NavigationViewControllerStartTitle       = @"起点";
const NSString *NavigationViewControllerDestinationTitle = @"终点";

@interface MapViewController ()<MAMapViewDelegate, AMapSearchDelegate>
@property (nonatomic,assign) AMapSearchType searchType;
@property (nonatomic, strong) AMapRoute *route;

@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic,assign) NSInteger totalCourse;

@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;

/* 起始点经纬度. */
@property (nonatomic,assign) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic,assign) CLLocationCoordinate2D destinationCoordinate;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
@end

@implementation MapViewController

-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:_mapView];
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

#pragma mark - MAMapViewDelegate
/**
 *  当位置更新时，会进定位回调，通过回调函数，能够获取到定位点的经纬度坐标
 */
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
                NSLog(@"latitude:%f,longitude:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

#pragma mark - Utility

- (void)updateTotal
{
    NSUInteger total = 0;
    
    if (self.route != nil)
    {
        switch (self.searchType)
        {
            case AMapSearchType_NaviDrive   :
            case AMapSearchType_NaviWalking : total = self.route.paths.count;    break;
            case AMapSearchType_NaviBus     : total = self.route.transits.count; break;
            default: total = 0; break;
        }
    }
    
    self.totalCourse = total;
}

- (BOOL)increaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse < self.totalCourse - 1)
    {
        self.currentCourse++;
        
        result = YES;
    }
    
    return result;
}

- (BOOL)decreaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse > 0)
    {
        self.currentCourse--;
        
        result = YES;
    }
    
    return result;
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    /* 公交导航. */
    if (self.searchType == AMapSearchType_NaviBus)
    {
        self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse]];
    }
    /* 步行，驾车导航. */
    else
    {
        MANaviType type = self.searchType == AMapSearchType_NaviDrive? MANaviType_Drive : MANaviType_Walking;
        self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type];
    }
    
    //    [self.naviRoute setNaviAnnotationVisibility:NO];
    
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines] animated:YES];
}

/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
}

/* 将selectedIndex 转换为响应的AMapSearchType. */
- (AMapSearchType)searchTypeForSelectedIndex:(NSInteger)selectedIndex
{
    AMapSearchType searchType = 0;
    
    switch (selectedIndex)
    {
        case 0: searchType = AMapSearchType_NaviDrive;   break;
        case 1: searchType = AMapSearchType_NaviWalking; break;
        case 2: searchType = AMapSearchType_NaviBus;     break;
        default:NSAssert(NO, @"%s: selectedindex = %ld is invalid for Navigation", __func__, (long)selectedIndex); break;
    }
    
    return searchType;
}

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        overlayView.lineWidth    = 4;
        overlayView.strokeColor  = self.naviRoute.routeColor;//[UIColor magentaColor];
        overlayView.lineDash     = YES;
        
        return overlayView;
    }
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        overlayView.lineWidth    = 8;
        overlayView.strokeColor  = self.naviRoute.routeColor;//[UIColor magentaColor];
        
        return overlayView;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:navigationCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviType_Bus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviType_Drive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviType_Walking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)NavigationViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)NavigationViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* 导航搜索回调. */
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request
                      response:(AMapNavigationSearchResponse *)response
{
    if (self.searchType != request.searchType)
    {
        return;
    }
    
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
    [self presentCurrentCourse];
}

#pragma mark - Navigation Search

/* 公交导航搜索. */
- (void)searchNaviBus
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviBus;
    navi.requireExtension = YES;
    navi.city             = @"beijing";
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapNavigationSearch:navi];
}

/* 步行导航搜索. */
- (void)searchNaviWalk
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviWalking;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapNavigationSearch:navi];
}

/* 驾车导航搜索. */
- (void)searchNaviDrive
{
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
}

/* 根据searchType来执行响应的导航搜索*/
- (void)SearchNaviWithType:(AMapSearchType)searchType
{
    switch (searchType)
    {
        case AMapSearchType_NaviDrive:
        {
            [self searchNaviDrive];
            
            break;
        }
        case AMapSearchType_NaviWalking:
        {
            [self searchNaviWalk];
            
            break;
        }
        default:AMapSearchType_NaviBus:
        {
            [self searchNaviBus];
            
            break;
        }
    }
}

#pragma mark - Handle Action

/* 切换导航搜索类型. */
- (void)searchTypeAction:(UISegmentedControl *)segmentedControl
{
    self.searchType = [self searchTypeForSelectedIndex:segmentedControl.selectedSegmentIndex];
    
    self.route = nil;
    self.totalCourse   = 0;
    self.currentCourse = 0;
    
    [self clear];
    
    /* 发起导航搜索请求. */
    [self SearchNaviWithType:self.searchType];
}

#pragma mark - Initialization


- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    /* 导航类型. */
    UISegmentedControl *searchTypeSegCtl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             @"  驾 车  ",
                                             @"  步 行  ",
                                             @"  公 交  ",
                                             nil]];
    
    [searchTypeSegCtl addTarget:self action:@selector(searchTypeAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *searchTypeItem = [[UIBarButtonItem alloc] initWithCustomView:searchTypeSegCtl];
    
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, searchTypeItem, flexbleItem, nil];
}

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)NavigationViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)NavigationViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.startCoordinate        = CLLocationCoordinate2DMake(39.910267, 116.370888);
        self.destinationCoordinate  = CLLocationCoordinate2DMake(39.989872, 116.481956);
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.mapView.rotateEnabled = NO;
    
    //开启定位
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow];
    
    [self initToolBar];
    
    [self addDefaultAnnotations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.toolbar.barStyle      = UIBarStyleDefault;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
    
    
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//}
//
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

@end
