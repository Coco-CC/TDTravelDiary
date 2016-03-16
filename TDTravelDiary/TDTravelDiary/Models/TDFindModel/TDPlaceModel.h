//
//  TDPlaceModel.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDPlaceModel : NSObject
@property(nonatomic,strong)NSString *name_zh_cn;//中文名字
@property(nonatomic,strong)NSString *name_en;//英文名字
@property(nonatomic,strong)NSString *image_url;//图片地址
@property(nonatomic,strong)NSString *placeID;

@end
