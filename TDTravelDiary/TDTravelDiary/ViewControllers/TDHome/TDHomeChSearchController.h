//
//  TDHomeChSearchController.h
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "ViewController.h"

@protocol TDTapGesteraDelegate <NSObject>

-(void)didClickTapUpGeater;

@end

@interface TDHomeChSearchController : ViewController
@property (nonatomic,strong) NSMutableArray *chSourceArray;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,assign) id<TDTapGesteraDelegate>delegate;
@end
