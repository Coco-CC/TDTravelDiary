//
//  TDTirpNodesInfo.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTirpNotesNotesInfo.h"
@interface TDTirpNodesInfo : NSObject

@property (nonatomic,strong) NSString *noID;
@property (nonatomic,strong) NSString *row_order; //行顺序
@property (nonatomic,strong) NSString *score; //分数
@property (nonatomic,strong) NSString *comment; // 评论
@property (nonatomic,strong) NSString *tips; //提示
@property (nonatomic,strong) NSString *memo; // 备忘录
@property (nonatomic,strong) NSString *entry_id;//条目ID
@property (nonatomic,strong) NSString *lat; // 纬度
@property (nonatomic,strong) NSString *lng; //经度
@property (nonatomic,strong) NSString *entry_type; //条目类型
@property (nonatomic,strong) NSString *user_entry; //用户输入
@property (nonatomic,strong) NSString *entry_name; // 条目名称
@property (nonatomic,strong) NSString *attraction_type; //  吸引人的类型
@property (nonatomic,strong) NSString *updated_at;
@property (nonatomic,strong) NSMutableArray *notesArray; //


@end
