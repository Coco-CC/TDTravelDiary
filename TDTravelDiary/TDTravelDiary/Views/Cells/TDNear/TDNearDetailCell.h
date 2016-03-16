//
//  TDNearDetailCell.h
//  TDTravelDiary
//
//  Created by co on 15/11/25.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TDGetNearModel;
@interface TDNearDetailCell : UITableViewCell
@property (nonatomic,strong) TDGetNearModel *getModel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


@end
