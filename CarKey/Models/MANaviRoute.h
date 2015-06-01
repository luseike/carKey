//
//  MANaviRoute.h
//  OfficialDemo3D
//
//  Created by yi chen on 1/7/15.
//  Copyright (c) 2015 songjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MANaviAnnotation.h"

@interface MANaviRoute : NSObject


@property (nonatomic, strong) NSArray * routePolylines;
@property (nonatomic, strong) NSArray * naviAnnotations;
@property (nonatomic, strong) UIColor * routeColor;

- (void)addToMapView:(MAMapView *)mapView;

- (void)removeFromMapView;

- (void)setNaviAnnotationVisibility:(BOOL)visible;

+ (instancetype)naviRouteForTransit:(AMapTransit *)transit;
+ (instancetype)naviRouteForPath:(AMapPath *)path withNaviType:(MANaviType)type;
+ (instancetype)naviRouteForPolylines:(NSArray *)polylines andAnnotations:(NSArray *)annotations;

+ (MAPolyline *)polylineForBusLine:(AMapBusLine *)busLine;

- (id)initWithTransit:(AMapTransit *)transit;
- (id)initWithPath:(AMapPath *)path withNaviType:(MANaviType)type;
- (id)initWithPolylines:(NSArray *)polylines andAnnotations:(NSArray *)annotations;

@end
