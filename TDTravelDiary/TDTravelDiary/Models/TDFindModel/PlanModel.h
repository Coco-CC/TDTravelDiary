//
//  PlanModel.h
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanModel : NSObject
@property(nonatomic,strong)NSString *tips;//描述
@property(nonatomic,strong)NSString *entry_name;//地点名称
@property(nonatomic,strong)NSString *image_url;//图片URL
@property(nonatomic,strong)NSString *entry_id;//id
@property(nonatomic,strong)NSString *lat;//维度
@property(nonatomic,strong)NSString *lng;//经度
@end
