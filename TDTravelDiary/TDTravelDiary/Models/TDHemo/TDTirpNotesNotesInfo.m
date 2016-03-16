//
//  TDTirpNotesNotesInfo.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDTirpNotesNotesInfo.h"

@implementation TDTirpNotesNotesInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"photo"]) {
        self.photoInfo = [[TDTripNotesNotesPotoInfo alloc]init];
        [self.photoInfo setValuesForKeysWithDictionary:value];
    }else if ([key isEqualToString:@"description"]){
        self.descriptions = value;
    }

}

@end
