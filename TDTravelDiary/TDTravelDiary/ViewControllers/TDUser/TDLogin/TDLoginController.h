//
//  TDLoginController.h
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "ViewController.h"

@protocol deliveryDelegate <NSObject>

-(void)deliveryToUserString:(NSString *)userNameString headerImage:(NSString *)userImage;
-(void)passNametoUserString:(NSString *)string;

@end

@interface TDLoginController : ViewController

@property(nonatomic,assign)id<deliveryDelegate> myStringDelegate;

@property (nonatomic,assign,getter= isCircleView) BOOL isCircleView;

@end
