//
//  TDTripModel.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDTripModel : NSObject
@property(nonatomic,strong)NSString *name;//名称
@property(nonatomic,assign)NSInteger plan_days_count;//天数
@property(nonatomic,assign) NSInteger plan_nodes_count;//旅游地点
@property(nonatomic,strong)NSString *image_url;//图片地址
@property(nonatomic,strong)NSString *descriptions;//秒数
@property(nonatomic,strong)NSString *tripID;

@end
