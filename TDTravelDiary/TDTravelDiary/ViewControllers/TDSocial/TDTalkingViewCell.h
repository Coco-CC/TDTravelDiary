//
//  TDTalkingViewCell.h
//  TDTravelDiary
//
//  Created by co on 15/11/28.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDTalkingViewCell : UITableViewCell
@property(strong,nonatomic) NSDictionary *model;


- (UIView *)bubbleViewWithText:(NSString *)text form:(BOOL)fromSelf withPosition:(int)position;


@end
