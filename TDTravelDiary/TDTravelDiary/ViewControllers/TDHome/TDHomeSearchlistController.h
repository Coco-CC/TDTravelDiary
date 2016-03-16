//
//  TDHomeSearchlistController.h
//  TDTravelDiary
//
//  Created by co on 15/11/21.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "ViewController.h"
#import "TDHomeSearchListInfo.h"
@interface TDHomeSearchlistController : ViewController
@property (nonatomic,strong) TDHomeSearchListInfo *listInfo;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,assign,getter=isisAddress) BOOL isisAddress; //是否拥有地址
@property (nonatomic,strong) NSString *addressText;
@end
