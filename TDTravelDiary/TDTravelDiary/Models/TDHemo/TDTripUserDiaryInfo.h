//
//  TDTripUserDiaryInfo.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTirpNodesInfo.h"
@interface TDTripUserDiaryInfo : NSObject
@property (nonatomic,strong) NSString *tripID; //id
@property (nonatomic,strong) NSString *trip_date;// 旅行日期
@property (nonatomic,strong) NSString *day;//天数
@property (nonatomic,strong) NSString *updated_at;//
@property (nonatomic,strong) NSString *destinationID;//
@property (nonatomic,strong) NSString *destinationName_zh_cn;// 地点
@property (nonatomic,strong) NSMutableArray *nodesArray;
@property (nonatomic,strong) NSMutableArray *sourceArray;


@end
