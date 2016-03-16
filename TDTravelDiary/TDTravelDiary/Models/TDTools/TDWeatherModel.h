//
//  TDWeatherModel.h
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDWeatherModel : NSObject
@property (nonatomic,strong) NSString *max;
@property (nonatomic,strong) NSString *min;
@property (nonatomic,strong) NSString *loc;
@property (nonatomic,strong) NSString *txt;
@property (nonatomic,strong) NSString *city;

@end
