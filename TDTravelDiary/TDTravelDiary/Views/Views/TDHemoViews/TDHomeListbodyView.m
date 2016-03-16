//
//  TDHomeListbodyView.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHomeListbodyView.h"

@interface TDHomeListbodyView ()
@property (weak, nonatomic) IBOutlet UIView *dayContentView;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TDHomeListbodyView



-(void)setTripInfo:(TDTripUserDiaryInfo *)tripInfo{


    if (_tripInfo != tripInfo) {
        _tripInfo = nil;
        _tripInfo = tripInfo;
        
        [self layoutMode];
    }


}

-(void)layoutMode{
    self.timeLabel.text = [NSString stringWithFormat:@"第%@天  %@ ",self.tripInfo.day,self.tripInfo.trip_date];
     self.timeLabel.font = [UIFont italicSystemFontOfSize:13];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
