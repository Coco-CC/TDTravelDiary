//
//  TDGetNearModel.h
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TDGetNearModel : NSObject
@property (nonatomic,strong) NSNumber *rating;
@property (nonatomic,strong) NSNumber *visited_count;
@property (nonatomic,strong) NSNumber *wish_to_go_count;

@property (nonatomic,strong) NSString *cover_s;


@property (nonatomic,strong) NSString *descrip;
@property (nonatomic,assign) double distance;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *tel;

@end
