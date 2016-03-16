//
//  TDTirpNodesInfo.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDTirpNodesInfo.h"

@implementation TDTirpNodesInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    
    if ([key isEqualToString:@"id"]) {
        
        self.noID = value;
    }else if ([key isEqualToString:@"notes"]){
        
        self.notesArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in value) {
            TDTirpNotesNotesInfo *notesNotesInfo = [[TDTirpNotesNotesInfo alloc]init];
            [notesNotesInfo setValuesForKeysWithDictionary:dict];
            [self.notesArray addObject:notesNotesInfo];
        }
    }
}


@end
