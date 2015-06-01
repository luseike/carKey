//
//  RequestManager.m
//  CarKey
//
//  Created by jiangyuanlu on 15/5/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import "RequestManager.h"
#import "NetWorking_API_Define.h"
#import "NSString+MD5Addition.h"


@implementation RequestManager

+ (RequestManager*)getInstance
{
    static dispatch_once_t predicate = 0;
    
    static RequestManager *object = nil; // Object
    dispatch_once(&predicate, ^{
        
        object = [self new];
        object.requestSerializer.timeoutInterval = 30;
        object.requestSerializer.HTTPShouldHandleCookies = YES;
        
    });
    
    return object; // singleton
}

- (void)cancel
{
    [[RequestManager getInstance].operationQueue cancelAllOperations];
}

-(NSString *)toJson:(id)dicData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicData options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length]>0 && error ==nil) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

- (AFHTTPRequestOperation*)getWithUrlStr:(NSString*)urlStr
                 Para:(NSDictionary*)paraDic
              success:(SuccessBlock)success
              failure:(FailureBlock)failure
{
    
    NSString *paramStr = [self toJson:paraDic];
    NSString *strMd5 = [NSString stringWithFormat: @"%@aidaijia_API", paramStr];
    NSString *strMd5Result = [strMd5 stringFromMD5];
    NSDictionary *postParamsDic = @{
                                    @"params":paramStr,
                                    @"safecode":strMd5Result
                                    };

    AFHTTPRequestOperation* operate = [[RequestManager getInstance] GET:urlStr parameters:postParamsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (error.code == -1005)
//        {
//            failure(@"网络请求出错");
//        }else
        {
            failure(error.localizedDescription);

        }
    }];
    return operate;
}

- (AFHTTPRequestOperation*)postWithUrlStr:(NSString*)urlStr
                  Para:(NSDictionary*)paraDic
               success:(SuccessBlock)success
               failure:(FailureBlock)failure
{

    NSString *paramStr = [self toJson:paraDic];
//    NSString *strMd5 = [NSString stringWithFormat: @"%@aidaijia_API", paramStr];
//    NSString *strMd5Result = [strMd5 stringFromMD5];
//    NSDictionary *postParamsDic = @{
//                                    @"params":paramStr,
//                                    @"safecode":strMd5Result
//                                    };
    
    AFHTTPRequestOperation* operate = [[RequestManager getInstance] POST:urlStr
              parameters:paramStr
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"%@,%@,%@",error.description,error.localizedDescription,error.localizedRecoverySuggestion);
//                     failure(error.localizedDescription);
                 }];
    return operate;
}

-(AFHTTPRequestOperation *)driverLoginWithServicePara:(NSDictionary *)paraDic       success:(SuccessBlock)success failure:(FailureBlock)failure{
    return [self postWithUrlStr:API_Login Para:paraDic success:success failure:failure];
}

-(AFHTTPRequestOperation *)driverInfoWithServicePara:(NSDictionary *)paraDic success:(SuccessBlock)success failure:(FailureBlock)failure{
    return [self postWithUrlStr:API_DriverInfo Para:paraDic success:success failure:failure];
}

-(AFHTTPRequestOperation *)driverOnOffWorkWithServicePara:(NSDictionary *)paraDic success:(SuccessBlock)success failure:(FailureBlock)failure{
    return [self postWithUrlStr:API_OnOffWork Para:paraDic success:success failure:failure];
}

-(AFHTTPRequestOperation *)driverUpdateLocWithServicePara:(NSDictionary *)paraDic success:(SuccessBlock)success failure:(FailureBlock)failure{
    return [self postWithUrlStr:API_UpdateLoc Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)cancelOrderWithServicePara:(NSDictionary *)paraDic
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure
{
     return [self postWithUrlStr:API_CancelOrder Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)orderDetailWithServicePara:(NSDictionary*)paraDic
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_OrderDetail Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)discountRechargeWithServicePara:(NSDictionary*)paraDic
                                                   success:(SuccessBlock)success
                                                   failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_CustomerDiscountRecharge Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)GetDisCountListWithServicePara:(NSDictionary*)paraDic
                                                  success:(SuccessBlock)success
                                                  failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_GetDisCountList Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)setDiscountWithServicePara:(NSDictionary*)paraDic
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_SetDiscount Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)feedbackWithServicePara:(NSDictionary*)paraDic
                                           success:(SuccessBlock)success
                                           failure:(FailureBlock)failure
{
    return [self getWithUrlStr:API_Feedback Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)getNearDriverListWithServicePara:(NSDictionary*)paraDic
                                                    success:(SuccessBlock)success
                                                    failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_GetNearDriverList Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)isOpenCityWithServicePara:(NSDictionary*)paraDic
                                             success:(SuccessBlock)success
                                             failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_IsOpenCity Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)customerInfoWithServicePara:(NSDictionary*)paraDic
                                               success:(SuccessBlock)success
                                               failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_CustomerInfo Para:paraDic success:success failure:failure];
}

- (AFHTTPRequestOperation*)orderListWithServicePara:(NSDictionary*)paraDic
                                            success:(SuccessBlock)success
                                            failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_OrderList Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)createOrderWithServicePara:(NSDictionary*)paraDic
                                              success:(SuccessBlock)success
                                              failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_CreateOrder Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)createMultipleOrderWithServicePara:(NSDictionary*)paraDic
                                                      success:(SuccessBlock)success
                                                      failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_CreateMultipleOrder Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)cityPriceWithServicePara:(NSDictionary*)paraDic
                                            success:(SuccessBlock)success
                                            failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_CityPrice Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)customerRechargeListWithServicePara:(NSDictionary*)paraDic
                                                       success:(SuccessBlock)success
                                                       failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_CustomerRechargeList Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)getOrderStatusWithServicePara:(NSDictionary*)paraDic
                                                 success:(SuccessBlock)success
                                                 failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_GetOrderStatus Para:paraDic success:success failure:failure];
}
- (AFHTTPRequestOperation*)discountDetailWithServicePara:(NSDictionary*)paraDic
                                                 success:(SuccessBlock)success
                                                 failure:(FailureBlock)failure
{
    return [self postWithUrlStr:API_DiscountDetail Para:paraDic success:success failure:failure];
}

-(void)uploadImg:(UIImage *)img{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:@"http://localhost/upload"
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
                                        //[formData appendPartWithFileURL:uploadFilePath name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
                                        
                                        [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 1) name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
                                    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}

@end
