//
//  TDGetdataManager.h
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TDCostDetailViewController;
@class TDAddCostController;
@interface TDGetdataManager : NSObject
+ (TDGetdataManager *)defaultManager;

- (NSMutableArray *)getDataWithcostType:(NSString *)costType target:(TDCostDetailViewController*)TDC;
- (NSString *)getAllMoneyCost;

- (CGFloat)getCostCountWithEntityName:(NSString *)entityName;
- (void)insertDataWithAddType:(NSString *)addType target:(TDAddCostController *)TDA;
- (NSString *)getCurrentTime;



@end
