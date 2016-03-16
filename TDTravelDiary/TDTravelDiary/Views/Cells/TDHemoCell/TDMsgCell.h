//
//  TDMsgCell.h
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDHomeMsgInfo.h"
#import <AVOSCloud/AVOSCloud.h>
@interface TDMsgCell : UITableViewCell

@property (nonatomic,strong) TDHomeMsgInfo *homeMsgInfo;
@property (nonatomic,strong)  AVObject *tdCommentsObject;
@end
