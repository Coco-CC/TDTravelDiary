//
//  TDNetWorkingTools.h
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface TDNetWorkingTools : NSObject


/**
 *  对象
 */
+(void)checkNetWorkTools;

/**
 *  通过url 解析JSON 数据
 *
 *  @param url     链接
 *  @param success 返回值
 *  @param fail    异常信息
 */
+(void)jsonDataWithUrl:(NSString *)url succes:(void(^)(id json))success fail:(void(^)())fail;

/**
 *  通过url 解析XML 数据
 *
 *  @param urlStr  链接
 *  @param success 返回请求成功的参数
 *  @param fail    请求失败
 */
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail  ;
@end
