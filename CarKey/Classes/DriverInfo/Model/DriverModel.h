//
//  DriverModel.h
//  CarKey
//
//  Created by jiangyuanlu on 15/5/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverModel : NSObject

//driverMobile":"13888889999","driverName":"刘强军","driverLevel":4,
//"driverOrderCount":516,"driverAcount":1200,"driverStatus":1

@property (nonatomic,copy) NSString *driverMobile;
@property (nonatomic,copy) NSString *driverName;
@property (nonatomic,assign) int driverLevel;
@property (nonatomic,copy) NSString *driverOrderCount;
@property (nonatomic,copy) NSString *driverAcount;
@property (nonatomic,assign) int driverStatus;
@property (nonatomic,copy) NSString *headUrl;

@end
