//
//  TDUserDiaryCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/29.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDUserDiaryCell.h"



@interface TDUserDiaryCell ()

//@property (weak, nonatomic) IBOutlet UIView *rongView;
@property (weak, nonatomic) IBOutlet UIImageView *diaryImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *diaryTimeLabel;

@end
@implementation TDUserDiaryCell

- (void)awakeFromNib {
    // Initialization code
}



-(void)setTdDiary:(AVObject *)tdDiary{

    if (_tdDiary!= tdDiary) {
        _tdDiary = nil;
        _tdDiary = tdDiary;
        [self layoutMode];
        
    }
}

-(void)layoutMode{


//    self.rongView.layer.cornerRadius = 8;
//    self.rongView.layer.masksToBounds = YES;
    NSDate *createTime = self.tdDiary[@"createdAt"];
    NSString *isEndTDDiary = self.tdDiary[@"isEndTDDiary"];
    NSDate *updateTime = self.tdDiary[@"updatedAt"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *crTime = [formatter stringFromDate:createTime];
    NSString *endTime = [formatter stringFromDate:updateTime];
    
    
    if ([isEndTDDiary isEqualToString:@"YES"]) {
        
        NSString *tdTimes = [NSString stringWithFormat:@"%@%@%@",crTime,@" - ",endTime];
        self.diaryTimeLabel.text = tdTimes;
        
    }else{
    
        NSString *tdTimes = [NSString stringWithFormat:@"%@%@%@",crTime,@" - ",@" "];
        self.diaryTimeLabel.text = tdTimes;
    
    
    }
    
    
    
    
    

    
   
    AVFile *tdImageFile= [self.tdDiary objectForKey:@"backImageName"];
    NSData *imageData = [tdImageFile getData];
    self.diaryImageView.image = [UIImage imageWithData:imageData];
    self.nameLabel.text = self.tdDiary[@"nameDiary"];
    
    
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:19];
     self.diaryTimeLabel.font = [UIFont italicSystemFontOfSize:12];


}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
