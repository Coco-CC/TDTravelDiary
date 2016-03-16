//
//  TDHomeListTitView.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHomeListTitView.h"
#import "UIImageView+WebCache.h"
@interface TDHomeListTitView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *startTimesLabel;
@property (weak, nonatomic) IBOutlet UIView *dayContentView;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *userBackView;

@end
@implementation TDHomeListTitView


-(void)setUserDiaryInfo:(TDUserDiaryListInfo *)userDiaryInfo{


    if (_userDiaryInfo != userDiaryInfo) {
        _userDiaryInfo = nil;
        _userDiaryInfo = userDiaryInfo;
        
        [self layoutMode];
    }
}

-(void)layoutMode{

    self.nameLabel.text = self.userDiaryInfo.name;

    NSString *timeStringa = [self.userDiaryInfo.start_date stringByAppendingString:@"~"];
    NSString *timeStringb = [timeStringa stringByAppendingString:self.userDiaryInfo.end_date];
    self.startTimesLabel .text = timeStringb;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.userDiaryInfo.front_cover_photo_url]];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:self.userDiaryInfo.userImage]];
    self.userNameLabel.text = self.userDiaryInfo.userName;
    
    self.timesLabel.text = [NSString stringWithFormat:@"第%@天  %@",@1,self.userDiaryInfo.start_date];
    
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.startTimesLabel.font = [UIFont italicSystemFontOfSize:13];
    self.timesLabel.font = [UIFont italicSystemFontOfSize:13];
    
    self.userBackView.layer.cornerRadius = 31.5;
    self.userImageView.layer.cornerRadius = 30;
    
    self.userImageView.layer.masksToBounds = YES;
    self.userBackView.layer.masksToBounds = YES;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
