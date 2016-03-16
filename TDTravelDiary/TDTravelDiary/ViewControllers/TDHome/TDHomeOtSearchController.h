//
//  TDHomeOtSearchController.h
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "ViewController.h"
@protocol TDTapGesterDelegate <NSObject>

-(void)didClickTapUpGeater;

@end
@interface TDHomeOtSearchController : ViewController
@property (nonatomic,strong) NSMutableArray *otSourceArray;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,assign) id<TDTapGesterDelegate>delegate;
@end
