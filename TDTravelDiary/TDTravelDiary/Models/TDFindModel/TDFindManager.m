//
//  TDFindManager.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDFindManager.h"
#import "TDNetWorkingTools.h"

@interface TDFindManager ()
@property(nonatomic,strong)NSMutableArray *plaveArray;
@property(nonatomic,strong)NSMutableArray *tripArray;
@property(nonatomic,strong)NSMutableArray *detailsArray;
@property(nonatomic,strong)NSString *detailsImage;
@end

@implementation TDFindManager

static TDFindManager *s_defaultManager = nil;
+(TDFindManager *)defaultManager{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        s_defaultManager = [[self alloc] init];
    });
    return s_defaultManager;
}
#pragma mark - plave的网络解析，以及数据的返回
-(void)parsingDataReturnMessagewith:(NSString *)stringID UIViewController:(UIViewController *)viewController Handler:(void(^)())handler Fail:(void(^)())fail{
    //解析数据
     NSString *urlString =[NSString stringWithFormat:@"http://chanyouji.com/api/destinations/%@.json",stringID];

    //每次调用改获取接口内容的方法，先清除播放列表中已有的数据避免重复
    [self.plaveArray removeAllObjects];
    [TDNetWorkingTools jsonDataWithUrl:urlString succes:^(id json) {
        for (NSDictionary *placeDict in json) {
        TDPlaceModel *placeModel = [[TDPlaceModel alloc] init];
             [placeModel setValuesForKeysWithDictionary:placeDict];
        [self.plaveArray addObject:placeModel];
    }
      //调用主线程 通知可以刷新数据
    dispatch_async(dispatch_get_main_queue(), ^{
        //调用block通知外部
        handler();
    });
        
} fail:^{
      [self showOkayCancelAlert:viewController titleString:@"警告" messageString:@"你的信息有错误请刷"];
        fail();
}];
   }
//返回数组的个数
-(NSInteger)plaveArrayCount{
    return self.plaveArray.count;
}
//返回model  ,点击cell  返回相对应的model
-(TDPlaceModel *)getTDPlaceModelWithIndex:(NSInteger)index{
    return self.plaveArray[index];
}

#pragma mark - trip的网络解析，以及数据的返回
-(void)parsingTirpDataReturnMessagewith:(NSString *)stringID UIViewController:(UIViewController *)viewController Handler:(void(^)())handler{
    //解析数据
    NSString *urlString =[NSString stringWithFormat:@"http://chanyouji.com/api/destinations/plans/%@.json?page=1",stringID];
    //每次调用改获取接口内容的方法，先清除播放列表中已有的数据避免重复
    [self.tripArray removeAllObjects];
    [TDNetWorkingTools jsonDataWithUrl:urlString succes:^(id json) {
        for (NSDictionary *placeDict in json) {
            TDTripModel *tripModel = [[TDTripModel alloc] init];
            [tripModel setValuesForKeysWithDictionary:placeDict];
            [self.tripArray addObject:tripModel];
        }
        //调用主线程 通知可以刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用block通知外部
            handler();
        });
    } fail:^{
        [self showOkayCancelAlert:viewController titleString:@"警告" messageString:@"你的信息有错误请刷"];
  
    }];
}
//返回数组的个数
-(NSInteger)tripArrayCount{
    return self.tripArray.count;
}
//返回model  ,点击cell  返回相对应的model
-(TDTripModel *)getTDTripModelWithIndex:(NSInteger)index{
    return self.tripArray[index];
}
#pragma mark - Details的网络解析，以及数据的返回
-(void)parsingDetailsDataReturnMessagewith:(NSString *)stringID UIViewController:(UIViewController *)viewController Handler:(void(^)())handler{
    //解析数据
    NSString *urlString =[NSString stringWithFormat:@"http://chanyouji.com/api/plans/%@.json",stringID];
    //每次调用改获取接口内容的方法，先清除播放列表中已有的数据避免重复
    [self.detailsArray removeAllObjects];
    [TDNetWorkingTools jsonDataWithUrl:urlString succes:^(id json) {
     self.detailsImage = json[@"image_url"];
        NSArray *plan_daysArr = json[@"plan_days"];
        for (NSDictionary *dict in plan_daysArr) {
            TDDetailsModel *detailsModel = [[TDDetailsModel alloc] init];
            [detailsModel setValuesForKeysWithDictionary:dict];
            [self.detailsArray addObject:detailsModel];
        }
        //调用主线程 通知可以刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用block通知外部
            handler();
        });
    } fail:^{
        [self showOkayCancelAlert:viewController titleString:@"警告" messageString:@"你的信息有错误请刷"];
    }];
}
//返回数组的个数
-(NSInteger)detailsArrayCount{
    return self.detailsArray.count;
}

//返回model  ,点击cell  返回相对应的model
-(TDDetailsModel *)getTDDetailModelWithIndex:(NSInteger)index{
    return self.detailsArray[index];
}

-(NSString *)detailsImage_url{

    return self.detailsImage;
}
#pragma mark - UIAlertcontroller

- (void)showOkayCancelAlert:(UIViewController *)viewController titleString:(NSString *)titleString messageString:(NSString *)messageString{
    NSString *title = NSLocalizedString(titleString, nil);
    NSString *message = NSLocalizedString(messageString, nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"确定", nil);
//    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
//    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
//    [alertController addAction:otherAction];
    
    [viewController showDetailViewController:alertController sender:nil];
}
#pragma mark - 懒加载
-(NSMutableArray *)plaveArray{
    if (_plaveArray == nil) {
        _plaveArray = [[NSMutableArray alloc] init];
    }
    return _plaveArray;
}
-(NSMutableArray *)tripArray{
    if (_tripArray == nil) {
        _tripArray = [[NSMutableArray alloc] init];
    }
    return _tripArray;
}
-(NSMutableArray *)detailsArray{
    if (_detailsArray == nil) {
        _detailsArray = [[NSMutableArray alloc] init];
    }
    return _detailsArray;
}


@end
