//
//  DriverInfoController.h
//  CarKey
//
//  Created by jiangyuanlu on 15/5/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DriverModel;

@interface DriverInfoController : UIViewController

/**
 *  登录司机的唯一身份标识
 */
@property (nonatomic,copy) NSString *sid;
@end
