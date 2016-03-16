//
//  TDTripModel.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDTripModel.h"

@implementation TDTripModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.descriptions = value;
    }
    if ([key isEqualToString:@"id"]) {
        self.tripID = value;
    }
}

@end
