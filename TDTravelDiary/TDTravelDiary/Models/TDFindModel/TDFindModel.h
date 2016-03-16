//
//  TDFindModel.h
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFindModel : NSObject
@property(nonatomic,strong)NSString *name_zh_cn;//地名-中文
@property(nonatomic,strong)NSString *name_en;//地名-英文
@property(nonatomic,strong)NSString *poi_count;//旅游地
@property(nonatomic,strong)NSString *image_url;//图片URL
@property(nonatomic,strong)NSString *userID;//点击获取下一页面值得标识
@end
