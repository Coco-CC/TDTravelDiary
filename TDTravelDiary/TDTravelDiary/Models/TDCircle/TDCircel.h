//
//  TDCircel.h
//  TDTravelDiary
//
//  Created by co on 15/11/25.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TDCircel : NSObject

@property (nonatomic,strong) NSString *addressText;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *diaryText;
@property (nonatomic,assign,getter=isPublicShare) BOOL  isPublicShare;
@property (nonatomic,assign) CGFloat imageWith;
@property (nonatomic,assign) CGFloat imageHeight;
@property (nonatomic,strong) UIImage *tdImage;
@property (nonatomic,strong) NSString *imageURL;
@property (nonatomic,strong) NSString *createdAt;
@property (nonatomic,strong) NSString *updatedAt;
@end
