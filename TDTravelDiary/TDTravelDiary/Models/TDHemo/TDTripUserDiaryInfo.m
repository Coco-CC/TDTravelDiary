//
//  TDTripUserDiaryInfo.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDTripUserDiaryInfo.h"
#import "TDTirpNotesNotesInfo.h"
@implementation TDTripUserDiaryInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"destination"]) {
        
        self.tripID = value;
    }else if([key isEqualToString:@"nodes"]){
    
        self.nodesArray = [[NSMutableArray alloc]init];
        
        self.sourceArray = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            TDTirpNodesInfo *nodesInfo = [[TDTirpNodesInfo alloc]init];
            [nodesInfo setValuesForKeysWithDictionary:dict];
            [self.nodesArray addObject:nodesInfo];
            for (TDTirpNotesNotesInfo *tnNoteInfo in nodesInfo.notesArray) {
                NSArray *array = [NSArray arrayWithObjects:nodesInfo,tnNoteInfo, nil];
                [self.sourceArray addObject:array];
            }
            
        }
        
     
    }
}


//-(NSMutableArray *)sourceArray{
//    if (!_sourceArray) {
//        _sourceArray = [NSMutableArray array];
//    }
//    return _sourceArray;
//}

@end
