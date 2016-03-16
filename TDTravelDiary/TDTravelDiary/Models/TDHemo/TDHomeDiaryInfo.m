//
//  TDHomeDiaryInfo.m
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHomeDiaryInfo.h"

@implementation TDHomeDiaryInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.diaryID = value;
    }else if ([key isEqualToString:@"user"]){
        self.userID = value[@"id"];
        self.userName = value[@"name"];
        self.userImage = value[@"image"];
    }
}

@end
