//
//  TDNetWorkingTools.m
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDNetWorkingTools.h"

@implementation TDNetWorkingTools


+(void)checkNetWorkTools{

    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    //检查网络状态变化，必须用检测管理器的单例
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    //网络变化时回调的方法
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    }];
}

+(void)jsonDataWithUrl:(NSString *)url succes:(void (^)(id))success fail:(void (^)())fail{

    //所有的网络请求，均由manager 发起
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = @{@"format":@"json"};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
     // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情  
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (fail) {
            fail();
        }
    }];
}

//通过url 请求XML 数据
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 返回的数据格式是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    NSDictionary *dict = @{@"format": @"xml"};
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}
@end
