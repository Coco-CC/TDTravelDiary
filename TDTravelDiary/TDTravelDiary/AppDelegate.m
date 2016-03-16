//
//  AppDelegate.m
//  TDTravelDiary
//
//  Created by co on 15/11/16.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "AppDelegate.h"
#import "TDWelcomeController.h"
#import "TDHomeViewController.h"
#import "TDFindViewController.h"
#import "TDToolsViewController.h"
#import "TDUserViewController.h"
#import "TDEditMessageController.h"
#import "TDCircleViewController.h"
#import "TDAddMessageController.h"
//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Name.h"
#import "Content.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    //==========================================================
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"gLKRflsuOF1zC9oU28NlHQ6c" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    [self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    //    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //    [self.window makeKeyAndVisible];
    //    self.window.backgroundColor = [UIColor whiteColor];
    

    //==========================================================
    
    //如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId:@"Fkw9EEa69M2kznCvhCFcMlpL"
                      clientKey:@"UAri9Qxgog9btr9cN4fwMEJK"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
    //============================================================
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    BOOL isFirstOpenTD = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstOpenTD"];
    
    if (isFirstOpenTD) {
        
        
        
        TDHomeViewController *hemoVC = [[TDHomeViewController alloc]init];
        TDFindViewController *findVC = [[TDFindViewController alloc]init];
        TDCircleViewController *circleVC = [[TDCircleViewController alloc]init];
        // TDToolsViewController *toolsVC = [[TDToolsViewController alloc]init];
        TDAddMessageController *addMessageVC = [[TDAddMessageController alloc]init];
        TDUserViewController *userVC = [[TDUserViewController alloc]init];
        hemoVC.tabBarItem= [[UITabBarItem alloc]initWithTitle:@"推荐" image:[UIImage imageNamed:@"iconfont-tuijian"] tag:10001];
        circleVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"圈儿" image:[UIImage imageNamed:@"iconfont-msg"] tag:10002];
        addMessageVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"添加" image:[UIImage imageNamed:@"iconfont-add"] tag:10003];
        findVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"视界" image:[UIImage imageNamed:@"iconfont-gonglve"] tag:10004];
        userVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"iconfont-wode"] tag:10005];

        
        UINavigationController *hemoNC = [[UINavigationController alloc]initWithRootViewController:hemoVC];
        UINavigationController *findNC = [[UINavigationController alloc]initWithRootViewController:findVC];
        UINavigationController *editMessageNC = [[UINavigationController alloc]initWithRootViewController:addMessageVC];
        UINavigationController *circleNC = [[UINavigationController alloc]initWithRootViewController:circleVC];
        UINavigationController *userNC = [[UINavigationController alloc]initWithRootViewController:userVC];
        
        UITabBarController * TBC = [[UITabBarController alloc]init];
        TBC.viewControllers = @[hemoNC,circleNC,editMessageNC,findNC,userNC];
        TBC.tabBar.barTintColor = [UIColor whiteColor];//[UIColor colorWithRed:89/255.0 green:191/255.0 blue:253/255.0 alpha:1];
        TBC.tabBar.tintColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];    //设置window 跟视图控制器
        TBC.delegate = self;
        //设置导航栏颜色
        [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
        //[UIColor colorWithRed:89/255.0 green:191/255.0 blue:253/255.0 alpha:1];;
        
        
        //设置tabbarItem的字体
        //设置字体颜色
        //        [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
        
        self.window.rootViewController =TBC;
    }else{
        
        self.window.rootViewController = [[TDWelcomeController alloc]init];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstOpenTD"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    [ShareSDK registerApp:@"c80ec0a75f20" activePlatforms:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                [appInfo SSDKSetupSinaWeiboByAppKey:@"3533088725" appSecret:@"a453dce8a43050b8738386cef888375c" redirectUri:@"http://www.baidu.com" authType:SSDKAuthTypeSSO];
                break;
                
            default:
                break;
        }
    }];

    
    return YES;
}









- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark----记账本增删改查方法
//查询
- (NSArray *)fetchallDataFromentityName:(NSString*)entityName
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    return result;
    
    
}
//删除表
- (void)removeDataWithEntityName:(NSString *)entityName
{
    NSEntityDescription *description = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:description];
    NSError *error = nil;
    NSArray *datas = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    
    if(!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas) {
            [self.managedObjectContext deleteObject:obj];
            [self saveContext];
        }
    }
    if (![self.managedObjectContext save:&error]) {
    }
    
    
}

#pragma mark----聊天的增删改查
//查询跟我聊过天的人的方法
- (NSArray *)fetchPersonTalkWithMeWithMyID:(NSString *)OtherID
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Name"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"otherName = %@",OtherID];
    [request setPredicate:predicate];
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:nil];
    if(request == nil)
    {
        
        
    }
    return result;
    
}


//查询本地是否已经存在聊天对象

- (BOOL)fetchHadTalkPersonWithMyID:(NSString *)MyID OtherID:(NSString *)otherID
{
    NSFetchRequest *fetch = [[NSFetchRequest alloc]initWithEntityName:@"Name"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"otheruserID = %@ && currentuserID = %@",otherID,MyID];
    [fetch setPredicate:predicate];
    
    NSArray *fetchArray = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    if (fetchArray.count == 0) {
        return NO;
        
    }
    else
    {
        return YES;
    }
    
}


//本地查询聊天记录

- (NSArray *)fetchArrayWithOtherID:(NSString *)otherID MyID:(NSString *)MyID EntityName:(NSString *)entityName
{
    //实例化查询请求对象
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    //实体描述
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Name" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"otheruserID = %@ && currentuserID = %@",otherID,MyID];
    
    
    [fetch setPredicate:predicate];
    NSError *error = nil;
    //使用管理对象上下文执行搜索请求
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    if (fetchedObjects == nil) {
        
    }
    
    return fetchedObjects;
    
    
}

//排序

- (NSMutableArray *)getMessageSortWithOtherID:(NSString *)OtherID andMyID:(NSString *)MyID
{
    Name *name = [self fetchArrayWithOtherID:OtherID MyID:MyID EntityName:@"Name"].lastObject;
    //NSArray *array= [self fetchArrayWithOtherID:OtherID MyID:MyID EntityName:@"Name"].lastObject;
    NSMutableArray *messageArray = [NSMutableArray new];
    
    
    for (Content *message in name.message) {
        
        [messageArray addObject:message];
    }
    
    
    
    [messageArray sortUsingComparator:^NSComparisonResult(Content *obj1, Content *obj2) {
        return [obj1.time compare:obj2.time];
        
    }];
    
    return messageArray;
    
    
}

//查询聊过天的人
- (NSArray *)fetchAllPersonTalkedWithMeWithEntityName:(NSString *)entityName
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entityName];
    [request setPredicate:[NSPredicate predicateWithFormat:@"currentuserID = %@",[AVUser currentUser].username]];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:nil];
    return  fetchedObjects;
    
    
}






#pragma mark----core Data
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "tpa.CoreDataSmaple2" in the application's documents directory.
    NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TDTravelCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TDTravelCoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}






@end
