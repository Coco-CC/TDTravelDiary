//
//  TDHomeSearchListInfo.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHomeSearchListInfo.h"

@implementation TDHomeSearchListInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.serachID = value;
    }
}

@end
