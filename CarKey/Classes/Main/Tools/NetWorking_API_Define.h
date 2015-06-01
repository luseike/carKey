//
//  NetWorking_API_Define.h
//  CarKey
//
//  Created by jiangyuanlu on 15/5/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#ifndef CarKey_NetWorking_API_Define_h
#define CarKey_NetWorking_API_Define_h

//司机登录
#define API_Login [NSString stringWithFormat:@"%@driver/account/login",HTTP_BLOCK_URL]

//获得司机信息
#define API_DriverInfo [NSString stringWithFormat:@"%@driver/account/info",HTTP_BLOCK_URL]

//司机上下班的开关
#define API_OnOffWork [NSString stringWithFormat:@"%@driver/account/work",HTTP_BLOCK_URL]

//更新司机经纬度信息
#define API_UpdateLoc [NSString stringWithFormat:@"%@driver/account/updatePos",HTTP_BLOCK_URL]

//取消订单
#define API_CancelOrder [NSString stringWithFormat:@"%@Order/CancelOrder.ashx",HTTP_BLOCK_URL]

//订单详情
#define API_OrderDetail [NSString stringWithFormat:@"%@Order/OrderDetail.ashx",HTTP_BLOCK_URL]

//充值
#define API_CustomerDiscountRecharge [NSString stringWithFormat:@"%@Customer/CustomerDiscountRecharge.ashx",HTTP_BLOCK_URL]

//获取优惠券列表
#define API_GetDisCountList [NSString stringWithFormat:@"%@Discount/GetDisCountListByCellphone.ashx",HTTP_BLOCK_URL]

//兑换优惠券
#define API_SetDiscount [NSString stringWithFormat:@"%@Discount/SetDiscount.ashx",HTTP_BLOCK_URL]

//意见反馈
#define API_Feedback [NSString stringWithFormat:@"%@Customer/CustomerFeedback.ashx",HTTP_BLOCK_URL]

//获取司机列表
#define API_GetNearDriverList [NSString stringWithFormat:@"%@Driver/GetNearDriverList.ashx",HTTP_BLOCK_URL]

//检查城市是否开通
#define API_IsOpenCity [NSString stringWithFormat:@"%@Common/IsOpenCity.ashx",HTTP_BLOCK_URL]

//用户信息
#define API_CustomerInfo [NSString stringWithFormat:@"%@Customer/CustomerInfo.ashx",HTTP_BLOCK_URL]

//订单列表
#define API_OrderList [NSString stringWithFormat:@"%@Order/OrderList.ashx",HTTP_BLOCK_URL]

//创建订单
#define API_CreateOrder [NSString stringWithFormat:@"%@Order/CreateOrder.ashx",HTTP_BLOCK_URL]

//创建多人订单
#define API_CreateMultipleOrder [NSString stringWithFormat:@"%@Order/CreateMultipleOrder.ashx",HTTP_BLOCK_URL]

//城市价格
#define API_CityPrice [NSString stringWithFormat:@"%@Common/CityPrice.ashx",HTTP_BLOCK_URL]

//个人消费记录
#define API_CustomerRechargeList [NSString stringWithFormat:@"%@Customer/CustomerRechargeList.ashx",HTTP_BLOCK_URL]

//订单状态
#define API_GetOrderStatus [NSString stringWithFormat:@"%@Order/GetOrderStatus.aspx",HTTP_BLOCK_URL]

//优惠券详情
#define API_DiscountDetail [NSString stringWithFormat:@"%@Discount/DiscountDetail.ashx",HTTP_BLOCK_URL]

//司机评价
#define API_DriverComment [NSString stringWithFormat:@"%@Driver/DriverComment.ashx",HTTP_BLOCK_URL]

//提交评论
#define API_SubmitComment [NSString stringWithFormat:@"%@Customer/SubmitComment.ashx",HTTP_BLOCK_URL]

//
#define API_GetVoiceVerification [NSString stringWithFormat:@"%@Common/GetVoiceVerification.ashx",HTTP_BLOCK_URL]

//
#define API_SendVerificationCode [NSString stringWithFormat:@"%@Customer/SendVerificationCode.ashx",HTTP_BLOCK_URL]

//
#define API_RechargeList [NSString stringWithFormat:@"%@Customer/RechargeList.ashx",HTTP_BLOCK_URL]
//获取支付宝单号
#define API_CustomerRecharge [NSString stringWithFormat:@"%@Customer/CustomerRecharge.ashx",HTTP_BLOCK_URL]

//多个订单详情
#define API_OrderDetailMulite [NSString stringWithFormat:@"%@Order/OrderDetailMulite.ashx",HTTP_BLOCK_URL]

//获取短信上行通道
#define API_GetsMessageUplink   [NSString stringWithFormat:@"%@Common/GetsMessageUplink.ashx",HTTP_BLOCK_URL]

//获取远程司机打赏明细(传参DisCountNo，需要打赏的司机的距离)
#define API_GetRemotePrice [NSString stringWithFormat:@"%@Driver/GetRemotePrice.ashx",HTTP_BLOCK_URL]

//打赏失败获取优惠券的接口
#define API_CustomerRewards [NSString stringWithFormat:@"%@Customer/CustomerRewards.ashx",HTTP_BLOCK_URL]


#endif
