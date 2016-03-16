//
//  TDHomeListViewController.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "ViewController.h"
#import "TDUserDiaryListInfo.h"
#import "TDHomeDiaryInfo.h"
@interface TDHomeListViewController : ViewController
@property (nonatomic,strong) TDUserDiaryListInfo *diaryInfo;

@property (nonatomic,strong) TDHomeDiaryInfo *homeInfo;
@end
