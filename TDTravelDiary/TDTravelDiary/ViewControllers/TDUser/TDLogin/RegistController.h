//
//  RegistController.h
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,SMSSendMode) {
    SMSSendModeSimple = 0,
    SMSSendModeFlex,
    SMSSendModeTemplate,
    SMSSendModeVoice

};


@interface RegistController : ViewController

@property(nonatomic)SMSSendMode mode;

@end
