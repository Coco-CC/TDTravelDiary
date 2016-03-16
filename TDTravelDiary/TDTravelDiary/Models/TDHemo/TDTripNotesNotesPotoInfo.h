//
//  TDTripNotesNotesPotoInfo.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDTripNotesNotesPotoInfo : NSObject

@property (nonatomic,strong) NSString *photoID;//id
@property (nonatomic,strong) NSString *image_width;//图片的宽
@property (nonatomic,strong) NSString *image_height;//图片的高
@property (nonatomic,strong) NSString *image_file_size;//图片文件的大小
@property (nonatomic,strong) NSString *exif_lat;
@property (nonatomic,strong) NSString *exif_lng;
@property (nonatomic,strong) NSString *exif_date_time_original; //原始日期
@property (nonatomic,strong) NSString *url;
@end
