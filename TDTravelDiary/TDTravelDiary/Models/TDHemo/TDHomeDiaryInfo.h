//
//  TDHomeDiaryInfo.h
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDHomeDiaryInfo : NSObject

@property (nonatomic,strong) NSString *diaryID;// id
@property (nonatomic,strong) NSString *name;// 名称
@property (nonatomic,strong) NSString *photos_count; //照片数量
@property (nonatomic,strong) NSString *start_date;//开始时间
@property (nonatomic,strong) NSString *end_date;//结束时间
@property (nonatomic,strong) NSString *days; //天数
@property (nonatomic,strong) NSString *level; // 水平
@property (nonatomic,strong) NSString *views_count; // 视图数
@property (nonatomic,strong) NSString *comments_count; //评论数
@property (nonatomic,strong) NSString *likes_count; //喜欢数
@property (nonatomic,strong) NSString *source; //源
@property (nonatomic,strong) NSString *front_cover_photo_url; //背景图片
@property (nonatomic,strong) NSString *featured; // 特色
@property (nonatomic,strong) NSString *userID; // 用户ID
@property (nonatomic,strong) NSString *userName;//用户名称
@property (nonatomic,strong) NSString *userImage; // 用户头像

@end
