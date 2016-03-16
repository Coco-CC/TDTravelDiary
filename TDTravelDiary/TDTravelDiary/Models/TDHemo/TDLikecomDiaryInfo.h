//
//  TDLikecomDiaryInfo.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDLikecomDiaryInfo : NSObject

@property (nonatomic,strong) NSString *likeID;
@property (nonatomic,strong) NSString *comments_count;//评论数
@property (nonatomic,strong) NSString *likes_count;//喜欢数
@property (nonatomic,strong) NSString *current_user_like; //当前用户喜欢
@property (nonatomic,strong) NSString *current_user_comment;//当前用户收藏


@end
