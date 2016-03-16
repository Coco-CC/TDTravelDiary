//
//  TDCircleCommentController.h
//  TDTravelDiary
//
//  Created by co on 15/11/26.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "ViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface TDCircleCommentController : ViewController
@property (nonatomic,strong) AVObject *tdListDiary;

@property (nonatomic,assign,getter=isPinglun) BOOL isPinglun;

@end
