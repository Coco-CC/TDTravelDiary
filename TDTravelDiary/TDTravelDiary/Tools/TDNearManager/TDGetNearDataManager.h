//
//  TDGetNearDataManager.h
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TDGetNearDataManager : NSObject
+(TDGetNearDataManager *)getDataManager;
- (NSString *)getlatitude;
- (NSString *)getLongitude;

- (void)getDataWithURL:(NSURL*)url handle:(void(^)(NSMutableArray * result))handle;

- (NSURL *)getAllDataURL;
- (NSURL *)getSpotDataURL;
- (NSURL *)getAccomdationDataURL;
- (NSURL *)getHallDataURL;

- (NSURL *)getAmusementDataURL;

- (NSURL *)getShopDataURL;




@end
