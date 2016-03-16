//
//  TDTripViewController.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDPlaceModel.h"
@interface TDTripViewController : UIViewController
@property(nonatomic,strong)TDPlaceModel*placeModel;


@property (nonatomic, assign) BOOL isCollect;

@end
