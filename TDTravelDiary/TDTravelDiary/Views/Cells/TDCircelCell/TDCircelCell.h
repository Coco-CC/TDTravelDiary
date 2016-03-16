//
//  TDCircelCell.h
//  TDTravelDiary
//
//  Created by co on 15/11/25.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDCircel.h"
#import <AVOSCloud/AVOSCloud.h>





@protocol herePushToCommentsDelegate <NSObject>

-(void)didCommentsButtonPush:(AVObject *)tdListDiary;

-(void)didAddFriendButtonAction;

@end



@interface TDCircelCell : UITableViewCell
@property (nonatomic,strong) AVObject *tdListDiary;
@property (nonatomic,strong) id<herePushToCommentsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *addsButton;

-(void)removeLoveButtonImage;



@end
