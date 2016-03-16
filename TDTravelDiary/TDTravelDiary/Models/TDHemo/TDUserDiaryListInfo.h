//
//  TDUserDiaryListInfo.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTripUserDiaryInfo.h"
#import "TDLikecomDiaryInfo.h"
@interface TDUserDiaryListInfo : NSObject

@property (nonatomic,strong) NSString *diaryID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *start_date;//开始时间
@property (nonatomic,strong) NSString *end_date;//结束时间
@property (nonatomic,strong) NSString *level;//喜欢
@property (nonatomic,strong) NSString *privacy; //隐私
@property (nonatomic,strong) NSString *front_cover_photo_id; //封面照片的ID
@property (nonatomic,strong) NSString *views_count;//视图数
@property (nonatomic,strong) NSString *comments_count;//评论数
@property (nonatomic,strong) NSString *likes_count;//喜欢的数量
@property (nonatomic,strong) NSString *favorites_count;//最喜欢的数量
@property (nonatomic,strong) NSString *state;//状态
@property (nonatomic,strong) NSString *source;//资源
@property (nonatomic,strong) NSString *serial_id;//串行数
@property (nonatomic,strong) NSString *serial_position;//连续的位置
@property (nonatomic,strong) NSString *serial_next_id;//连续的下一个ID
@property (nonatomic,strong) NSString *updated_at; //更新
@property (nonatomic,strong) NSString *upload_token;//
@property (nonatomic,strong) NSString *current_user_favorite;//
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *front_cover_photo_url;//背景图片

@property (nonatomic,strong) NSString *userID;//用户ID
@property (nonatomic,strong) NSString *userName;// 用户名称
@property (nonatomic,strong) NSString *userImage;//用户头像

@property (nonatomic,strong) NSMutableArray *tripArray;// 行程信息
@property (nonatomic,strong) NSMutableArray *notesLikesArray;//评论喜欢的ren





@end
