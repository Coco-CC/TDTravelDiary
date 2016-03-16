//
//  TDHomeSearchController.h
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"
#import "TDHemoSearchInfo.h"
@interface TDHomeSearchController : ViewPagerController
@property (nonatomic,strong)  TDHemoSearchInfo *searchInfo;
@end
