//
//  TDGetNearModel.m
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDGetNearModel.h"

@implementation TDGetNearModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
if([key isEqualToString:@"description"])
{
    self.descrip = value;
}
    
}

@end
