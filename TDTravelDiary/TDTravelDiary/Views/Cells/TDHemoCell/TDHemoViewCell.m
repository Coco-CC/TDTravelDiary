//
//  TDHemoViewCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHemoViewCell.h"
#import "UIImageView+WebCache.h"

@interface TDHemoViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImage; // 背景图片
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //标题
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 时间
@property (weak, nonatomic) IBOutlet UIView *imageContentView; // 存放用户头像的view
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage; // 用户头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel; //用户姓名
//@property (weak, nonatomic) IBOutlet UILabel *addressLabel; // 地点


@end
@implementation TDHemoViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setHomeInfo:(TDHomeDiaryInfo *)homeInfo{

    if (_homeInfo != homeInfo) {
        _homeInfo = nil;
        _homeInfo = homeInfo;
    }
    [self layoutMode];
}
-(void)layoutMode{

    
    UIImage *avaImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"hemo_back_user.png" ofType:nil]];
    UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"hemo_back.png"ofType:nil]];

    self.imageContentView.layer.cornerRadius = 17.5;
    self.imageContentView.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = 16.5;
    self.avatarImage.layer.masksToBounds = YES;
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.homeInfo.front_cover_photo_url] placeholderImage:coverImage];
    self.nameLabel.text =self.homeInfo.name;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    NSString *timeTexta = [self.homeInfo.start_date stringByAppendingString:@"  /"] ;
    NSString *timeTextb =[NSString stringWithFormat:@"%@ %@天",timeTexta, self.homeInfo.days];
     self.timeLabel.text = timeTextb;
    self.timeLabel.font = [UIFont italicSystemFontOfSize:11];
    [self.avatarImage  sd_setImageWithURL:[NSURL URLWithString:self.homeInfo.userImage] placeholderImage:avaImage];
      self.userNameLabel.text = self.homeInfo.userName;
    
    

    

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
