//
//  RequestManager.h
//  CarKey
//
//  Created by jiangyuanlu on 15/5/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessBlock)(NSDictionary* dictResult);
typedef void(^FailureBlock)(NSString *errorMessage);

@interface RequestManager : AFHTTPRequestOperationManager

+ (RequestManager*)getInstance;

- (void)cancel;

- (AFHTTPRequestOperation*)getWithUrlStr:(NSString*)urlStr
                                    Para:(NSDictionary*)paraDic
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure;


- (AFHTTPRequestOperation*)postWithUrlStr:(NSString*)urlStr
                                     Para:(NSDictionary*)paraDic
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure;

//司机登录
- (AFHTTPRequestOperation*)driverLoginWithServicePara:(NSDictionary*)paraDic
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure;

//获得司机信息
- (AFHTTPRequestOperation*)driverInfoWithServicePara:(NSDictionary*)paraDic
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure;

//司机上下班的开关
- (AFHTTPRequestOperation*)driverOnOffWorkWithServicePara:(NSDictionary*)paraDic
                                             success:(SuccessBlock)success
                                             failure:(FailureBlock)failure;

//更新司机经纬度信息
- (AFHTTPRequestOperation*)driverUpdateLocWithServicePara:(NSDictionary*)paraDic
                                                  success:(SuccessBlock)success
                                                  failure:(FailureBlock)failure;

//取消订单
- (AFHTTPRequestOperation*)cancelOrderWithServicePara:(NSDictionary*)paraDic
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure;
//订单详情
- (AFHTTPRequestOperation*)orderDetailWithServicePara:(NSDictionary*)paraDic
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure;
//充值
- (AFHTTPRequestOperation*)discountRechargeWithServicePara:(NSDictionary*)paraDic
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure;

//获取优惠券列表
- (AFHTTPRequestOperation*)GetDisCountListWithServicePara:(NSDictionary*)paraDic
                                                   success:(SuccessBlock)success
                                                   failure:(FailureBlock)failure;
//兑换优惠券
- (AFHTTPRequestOperation*)setDiscountWithServicePara:(NSDictionary*)paraDic
                                                  success:(SuccessBlock)success
                                                  failure:(FailureBlock)failure;

//意见反馈
- (AFHTTPRequestOperation*)feedbackWithServicePara:(NSDictionary*)paraDic
                                              success:(SuccessBlock)success
                                           failure:(FailureBlock)failure;
//附件司机列表
- (AFHTTPRequestOperation*)getNearDriverListWithServicePara:(NSDictionary*)paraDic
                                           success:(SuccessBlock)success
                                           failure:(FailureBlock)failure;
//城市是否开通
- (AFHTTPRequestOperation*)isOpenCityWithServicePara:(NSDictionary*)paraDic
                                                    success:(SuccessBlock)success
                                                    failure:(FailureBlock)failure;
//用户信息
- (AFHTTPRequestOperation*)customerInfoWithServicePara:(NSDictionary*)paraDic
                                             success:(SuccessBlock)success
                                             failure:(FailureBlock)failure;
//订单列表
- (AFHTTPRequestOperation*)orderListWithServicePara:(NSDictionary*)paraDic
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure;

//创建订单
- (AFHTTPRequestOperation*)createOrderWithServicePara:(NSDictionary*)paraDic
                                            success:(SuccessBlock)success
                                            failure:(FailureBlock)failure;

//创建多人订单
- (AFHTTPRequestOperation*)createMultipleOrderWithServicePara:(NSDictionary*)paraDic
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure;

//城市价格
- (AFHTTPRequestOperation*)cityPriceWithServicePara:(NSDictionary*)paraDic
                                                      success:(SuccessBlock)success
                                                      failure:(FailureBlock)failure;


- (AFHTTPRequestOperation*)customerRechargeListWithServicePara:(NSDictionary*)paraDic
                                            success:(SuccessBlock)success
                                            failure:(FailureBlock)failure;

//订单状态
- (AFHTTPRequestOperation*)getOrderStatusWithServicePara:(NSDictionary*)paraDic
                                                       success:(SuccessBlock)success
                                                       failure:(FailureBlock)failure;

//优惠券详情
- (AFHTTPRequestOperation*)discountDetailWithServicePara:(NSDictionary*)paraDic
                                                 success:(SuccessBlock)success
                                                 failure:(FailureBlock)failure;

//上传图片
-(void)uploadImg:(UIImage *)img;
@end
