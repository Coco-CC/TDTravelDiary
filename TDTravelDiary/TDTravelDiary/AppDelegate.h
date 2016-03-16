//
//  AppDelegate.h
//  TDTravelDiary
//
//  Created by co on 15/11/16.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <CoreData/CoreData.h>
#import <CoreFoundation/CoreFoundation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)UINavigationController *navigationController;
@property(nonatomic,strong)BMKMapManager *mapManager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark----记账本增删改查方法
- (NSArray *)fetchallDataFromentityName:(NSString*)entityName;
- (void)removeDataWithEntityName:(NSString *)entityName;

#pragma mark----聊天的增删改查方法
- (NSArray *)fetchPersonTalkWithMeWithMyID:(NSString *)OtherID;
//本地获取聊天记录的方法
- (NSArray *)fetchArrayWithOtherID:(NSString *)otherID MyID:(NSString *)MyID EntityName:(NSString *)entityName;
//获取时间排序后的聊天
- (NSMutableArray *)getMessageSortWithOtherID:(NSString *)OtherID andMyID:(NSString *)MyID;
//判断数据库内是否已经存在聊天对
- (BOOL)fetchHadTalkPersonWithMyID:(NSString *)MyID OtherID:(NSString *)otherID;

- (NSArray *)fetchAllPersonTalkedWithMeWithEntityName:(NSString *)entityName;


@end

