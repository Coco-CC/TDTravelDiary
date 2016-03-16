//
//  TDHemoSearchInfo.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHemoSearchInfo.h"

@implementation TDHemoSearchInfo


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"china_destinations"]) {
        
        self.chArray = [NSMutableArray array];
        for (NSDictionary *diary in value) {
            TDHomeSearchListInfo *listInfo = [[TDHomeSearchListInfo alloc]init];
            [listInfo setValuesForKeysWithDictionary:diary];
            [self.chArray addObject:listInfo];
            
        }
    }else if ([key isEqualToString:@"other_destinations"]){
    
        self.otherArray = [NSMutableArray array];
        for (NSDictionary *diary in value) {
            TDHomeSearchListInfo *listInfo = [[TDHomeSearchListInfo alloc]init];
            [listInfo setValuesForKeysWithDictionary:diary];
            [self.otherArray addObject:listInfo];
        }
    }
}

@end
