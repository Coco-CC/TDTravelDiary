//
//  TDFindManager.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDPlaceModel.h"
#import "TDTripModel.h"
#import "TDDetailsModel.h"
#import <UIKit/UIKit.h>
@interface TDFindManager : NSObject

+(TDFindManager *)defaultManager;
/**
 *  网络解析的方法
 *
 *  @param stringID 传过来的值
 *  @param handler
 */
-(void)parsingDataReturnMessagewith:(NSString *)stringID UIViewController:(UIViewController *)viewController Handler:(void(^)())handler Fail:(void(^)())fail;
/**
 *  返回的数组的个数
 *
 *  @return
 */
-(NSInteger)plaveArrayCount;

/**
 *  返回model
 *
 *  @param index 点击cell
 *
 *  @return 返回相对应的model
 */
-(TDPlaceModel *)getTDPlaceModelWithIndex:(NSInteger)index;

-(void)parsingTirpDataReturnMessagewith:(NSString *)stringID UIViewController:(UIViewController *)viewController Handler:(void(^)())handler;
-(NSInteger)tripArrayCount;
-(TDTripModel *)getTDTripModelWithIndex:(NSInteger)index;
#pragma mark - Details的网络解析，以及数据的返回
/**
 *  解析details数据
 *
 *  @param stringID       id
 *  @param viewController 视图
 *  @param handler        回调通知
 */
-(void)parsingDetailsDataReturnMessagewith:(NSString *)stringID UIViewController:(UIViewController *)viewController Handler:(void(^)())handler;
-(NSInteger)detailsArrayCount;
-(TDDetailsModel *)getTDDetailModelWithIndex:(NSInteger)index;

-(NSString *)detailsImage_url;

/**
 *  弹框视图
 *
 *  @param viewController
 *  @param titleString    标题
 *  @param messageString  错误信息
 */
- (void)showOkayCancelAlert:(UIViewController *)viewController titleString:(NSString *)titleString messageString:(NSString *)messageString;

@end
