//
//  TDUserDiaryListInfo.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDUserDiaryListInfo.h"


@implementation TDUserDiaryListInfo


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"user"]) {
        
        self.userID = value[@"id"];
        self.userName = value[@"name"];
        self.userImage = value[@"image"];
    }else if ([key isEqualToString:@"trip_days"]){
    
        self.tripArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in value) {
            TDTripUserDiaryInfo *tripInfo = [[TDTripUserDiaryInfo alloc]init];
            [tripInfo setValuesForKeysWithDictionary:dict];
            [self.tripArray addObject:tripInfo];
            
            
            
            
            
            
            
        }
    }else if ([key isEqualToString:@"notes_likes_comments"]){
        self.notesLikesArray = [NSMutableArray array];
        for (NSDictionary *dict in value) {
            TDLikecomDiaryInfo *likeInfo = [[TDLikecomDiaryInfo alloc]init];
            [likeInfo setValuesForKeysWithDictionary:dict];
            [self.notesLikesArray addObject:likeInfo];
        }
    }
}

@end
