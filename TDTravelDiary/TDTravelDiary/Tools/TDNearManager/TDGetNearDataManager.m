//
//  TDGetNearDataManager.m
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDGetNearDataManager.h"
#import "URL.h"
#import "TDGetNearModel.h"
@import CoreLocation;

@interface TDGetNearDataManager ()<CLLocationManagerDelegate>


@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;

@property (nonatomic,strong) NSString *la;
@property (nonatomic,strong) NSString *lo;
@property (nonatomic,strong) NSString *middle;
@property (nonatomic,strong) NSMutableArray *sourceArray;//数据源数组
@end

@implementation TDGetNearDataManager
static TDGetNearDataManager *dataManager = nil;
+(TDGetNearDataManager *)getDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[TDGetNearDataManager alloc]init];
        
    });
    return dataManager;
    
    

}
//初始化
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.sourceArray = [NSMutableArray array];
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.la = @"&latitude=";
        self.lo = @"&longitude=";
            [self.locationManager startUpdatingLocation];
            [self.locationManager requestAlwaysAuthorization];

    }
    return self;

}



#pragma mark----changenumber
- (NSString *)getlatitude
{
    
  
    NSString *latitude = [NSString stringWithFormat:@"%f",self.latitude];
    return latitude;

}
- (NSString *)getLongitude
{
 
    NSString *longitude = [NSString stringWithFormat:@"%f",self.longitude];
    
    
    return longitude;
}

#pragma mark----Session and Json
- (NSURL *)getAllDataURL

{
    self.middle = [[[self.la stringByAppendingString:[self getlatitude]]stringByAppendingString:self.lo]stringByAppendingString:[self getLongitude]];
    NSString *str = [[nearAllListFirst stringByAppendingString:self.middle]stringByAppendingString:nearAllListLast];
    
    
    NSURL *url = [NSURL URLWithString:str];
    
    
    
    return url;
    
}
- (NSURL *)getSpotDataURL
{
    self.middle = [[[self.la stringByAppendingString:[self getlatitude]]stringByAppendingString:self.lo]stringByAppendingString:[self getLongitude]];

    NSURL *url = [NSURL URLWithString:[[spotListFirst stringByAppendingString:self.middle]stringByAppendingString:spotListLast]];
    return url;
}

- (NSURL *)getAccomdationDataURL
{
    self.middle = [[[self.la stringByAppendingString:[self getlatitude]]stringByAppendingString:self.lo]stringByAppendingString:[self getLongitude]];

    NSURL *url = [NSURL URLWithString:[[accomdationListFirst stringByAppendingString:self.middle]stringByAppendingString:accomdationListLast]];
    return url;

}
- (NSURL *)getHallDataURL
{
    self.middle = [[[self.la stringByAppendingString:[self getlatitude]]stringByAppendingString:self.lo]stringByAppendingString:[self getLongitude]];

    NSURL *url = [NSURL URLWithString:[[hallListFirst stringByAppendingString:self.middle]stringByAppendingString:hallListLast]];
    return url;
}
- (NSURL *)getAmusementDataURL
{
    self.middle = [[[self.la stringByAppendingString:[self getlatitude]]stringByAppendingString:self.lo]stringByAppendingString:[self getLongitude]];

    NSURL *url = [NSURL URLWithString:[[amusementListFirst stringByAppendingString:self.middle]stringByAppendingString:amusementListLast]];
    
    return url;

}
- (NSURL *)getShopDataURL
{
    self.middle = [[[self.la stringByAppendingString:[self getlatitude]]stringByAppendingString:self.lo]stringByAppendingString:[self getLongitude]];

    NSURL *url = [NSURL URLWithString:[[shopListFirst stringByAppendingString:self.middle]stringByAppendingString:shopListLast]];
    return url;
    
    
//    [self getDataWithURL:url handle:^(NSArray *result) {
//        //qqqqqq
//        [self.table reload];
    
   // }];
    
    
}

- (void)getDataWithURL:(NSURL*)url handle:(void(^)(NSMutableArray * result))handle
{
    [self.sourceArray removeAllObjects];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    
  
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *jsonArray = jsonDic[@"items"];
        for (NSDictionary *dic in jsonArray) {
            TDGetNearModel *nearModel = [[TDGetNearModel alloc]init];
            [nearModel setValuesForKeysWithDictionary:dic];
            [self.sourceArray addObject:nearModel];
        
        }
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            handle(self.sourceArray);
        });
        
        
       
    }];
    
    [dataTask resume];
    
  
    
    
}



#pragma mark----LocationManager delegate


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.latitude = locations.firstObject.coordinate.latitude;
    self.longitude = locations.firstObject.coordinate.longitude;
    

    
    //停止位置的获取
    [self.locationManager stopUpdatingLocation];
}




@end
