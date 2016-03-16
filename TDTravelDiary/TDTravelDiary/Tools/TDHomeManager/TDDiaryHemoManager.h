//
//  TDDiaryHemoManager.h
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDHomeDiaryInfo.h"
#import "TDUserDiaryListInfo.h"
#import "TDHemoSearchInfo.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TDCircel.h"
@interface TDDiaryHemoManager : NSObject

@property (nonatomic,strong) TDUserDiaryListInfo *userDiaryInfo;
@property (nonatomic,assign) NSInteger  searIndexURL;//搜索第几条URL
@property (nonatomic,assign) NSInteger searOldIndexURl ;//


// 创建单例对象
+(TDDiaryHemoManager *)defaultManager;
/**
 *  请求解析数据
 *
 *  @param handler 请求完毕后主页刷新等操作调用的方法
 */
-(void)requestTDDataWithURlHandler:(void(^)())handler Fail:(void(^)())fail;

/**
 *  加载已经刷新过的数据
 *
 *  @param handler 返回
 */
-(void)requestTDOldDataHandler:(void(^)())handler Fail:(void(^)())fail;

/**
 *  获取返回参数的数量
 *
 *  @return 返回值
 */
-(NSUInteger)tdhemoDiaryCount;

/**
 *  根据参数 返回数组中的某条数据
 *
 *  @param index 第几条数据
 *
 *  @return 返回值
 */
-(TDHomeDiaryInfo *)getElementDataWithIndex:(NSInteger )index;

/**
 *  请求用户详情的页面
 *
 *  @param handler 刷新数据
 */
-(void)requestTdUserListDataWitghURL:(TDHomeDiaryInfo *)homeInfo Handler:(void(^)(TDUserDiaryListInfo *diaryInfo))handler Fail:(void(^)())fail;


/**
 *  根据url 获取搜索目录里的国家和省份的信息
 *
 *  @param handler
 */
-(void)requestSearchDataWithURlHandler:(void(^)(TDHemoSearchInfo *searchInfo))handler Fail:(void(^)())fail;

/**
 *  根据url 搜索 信息 传过来地点的ID
 *
 *  @param serId
 *  @param handler
 */
-(void)requestSearchDiaryDataWithID:(NSString *)serId Handler:(void(^)())handler Fail:(void(^)())fail;


/**
 *  加载已经刷新过的数据
 *
 *  @param handler 返回
 */
-(void)requestSearchOldDataWithID:(NSString *)serId Handler:(void(^)())handler Fail:(void(^)())fail;



/**
 *  根据url 搜索 信息 传过来地点的ID
 *
 *  @param serId
 *  @param handler
 */
-(void)requestSearchDiaryDataWithAddress:(NSString *)address Handler:(void(^)())handler Fail:(void(^)())fail;


/**
 *  加载已经刷新过的数据
 *
 *  @param handler 返回
 */
-(void)requestSearchOldDataWithAddress:(NSString *)address Handler:(void(^)())handler Fail:(void(^)())fail;


/**
 *  返回根据地点搜索获取的数组个数
 *
 *  @return
 */
-(NSUInteger)tdhdSearchDidianCount;


/**
 *  根据参数 返回数组中的某条数据
 *
 *  @param index 第几条数据
 *
 *  @return 返回值
 */
-(TDHomeDiaryInfo *)getElementDataSearchDidianWithIndex:(NSInteger )index;


//当退出搜索页面时将数组清空
-(void)removesearDidianArray;



/**
 *  查询圈子信息
 *
 *  @param handler 成功调用
 *  @param fail    失败调用
 */
-(void)requestCircleDataWithuserName:(NSString *)userKey  Handler:(void(^)())handler Fail:(void(^)())fail;

/**
 *  获取圈子内容数量
 *
 *  @return
 */
-(NSInteger)getCircleCount;
/**
 *  根据参数获取响应的内容
 *  @param index
 *  @return
 */
-(AVObject *)getTdCircelDataWithIndex:(NSInteger)indexs;
/**
 *  根据用户名去获取用户的具体信息
 *
 *  @param userKey 这里的userName 并不是用户名，而是用户表中存在的唯一标识
 *  @param handler  成功
 *  @param fail     失败
 */
-(void)getUserWithusername:(NSString *)userKey Handler:(void(^)(AVObject *object))handler Fail:(void(^)())fail;

/**
 *  上拉加载
 *  @param userKey
 *  @param handler
 *  @param fail
 */
-(void)requestCircleOldDataWithuserName:(NSString *)userKey  Handler:(void(^)())handler Fail:(void(^)())fail;


/**
 *  在没有好友的情况下获取数据
 *
 *  @param userKey
 *  @param handler
 *  @param fail
 */
-(void)notFriendrequestCircleDataWithuserName:(NSString *)userKey Handler:(void(^)())handler Fail:(void(^)())fail;

/**
 *  上拉加载 在没有好友的情况下
 *  @param userKey
 *  @param handler
 *  @param fail
 */
-(void)notFriendrequestCircleOldDataWithuserName:(NSString *)userKey Handler:(void(^)())handler Fail:(void(^)())fail;

/**
 *  搜索好友游记
 *
 *  @param userKey
 *  @param nikeName
 *  @param handler
 *  @param fail
 */

-(void)searchRequestCircleDataWithuserKey:(NSString *)userKey  useName:(NSString *)nikeName Handler:(void(^)())handler Fail:(void(^)())fail;


/**
 *  请求自己所有的游记目录
 *
 *  @param userKey 自己的userKey
 *  @param handler 成功
 *  @param fail    失败
 */
-(void)requestUserTravelDiaryWithUserKey:(NSString *)userKey Handler:(void (^)())handler Fail:(void(^)())fail;

-(void)requestOldUserTravelDiaryWithUserKey:(NSString *)userKey Handler:(void (^)())handler Fail:(void(^)())fail;


-(NSInteger)getuserDiaryArrayCount;

-(AVObject *)getTDDiaryWithIndex:(NSInteger)index;



/**
 *  根据 游记总目去查找具体的游记
 *
 *  @param tdDiary 总游记目录
 *  @param handler 成功
 *  @param fail    失败
 */
-(void)requestTDListDiaryWithTdDiary:(AVObject *)tdDiary Handler:(void (^)())handler Fail:(void(^)())fail;

/**
 *  加载后面
 *
 *  @param tdDiary 总游记目录
 *  @param handler 成功
 *  @param fail    失败
 */
-(void)requestOldTDListDiaryWithTdDiary:(AVObject *)tdDiary Handler:(void (^)())handler Fail:(void(^)())fail;

-(NSInteger)getTdListDiaryArrayCount;

-(AVObject *)getTdListDiaryWithIndex:(NSInteger )index;


-(void)deleteListDiaryWithObject:(AVObject *)tdDiary Index:(NSInteger)index Handler:(void(^)())handler Fail:(void(^)())fail;


-(void)deletetdDiaryWithObject:(AVObject *)tdDiary Index:(NSInteger)index Handler:(void (^)())handler Fail:(void (^)())fail;



@end
