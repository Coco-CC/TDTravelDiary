//
//  TDTirpNotesNotesInfo.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTripNotesNotesPotoInfo.h"

@interface TDTirpNotesNotesInfo : NSObject

@property (nonatomic,strong) NSString  *notesID;
@property (nonatomic,strong) NSString *row_order; //顺序
@property (nonatomic,strong) NSString *layout; // 布局
@property (nonatomic,strong) NSString *col; //上校
@property (nonatomic,strong) NSString *descriptions;//描述
@property (nonatomic,strong) NSMutableArray *commentsArray;//评论
@property (nonatomic,strong) NSString *updated_at; //更新
@property (nonatomic,strong) TDTripNotesNotesPotoInfo *photoInfo;
@property (nonatomic,assign,getter=isLove) BOOL isLove; //是否喜欢


@end
