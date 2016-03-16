//
//  TDUserTDDiaryView.m
//  TDTravelDiary
//
//  Created by co on 15/11/29.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDUserTDDiaryView.h"

@interface TDUserTDDiaryView ()


@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titTimesLabel;

@end

@implementation TDUserTDDiaryView





-(void)setTdDiary:(AVObject *)tdDiary{

    if (_tdDiary != tdDiary) {
        _tdDiary = nil;
        _tdDiary = tdDiary;
        
        [self layoutMode];
    }
}
-(void)layoutMode{
    
    AVFile *tdImageFile= [self.tdDiary objectForKey:@"backImageName"];
    NSData *imageData = [tdImageFile getData];
    self.titleImageView.image = [UIImage imageWithData:imageData];
    self.titleNameLabel.text = self.tdDiary[@"nameDiary"];
    NSString *isEndTDDiary = self.tdDiary[@"isEndTDDiary"];
    NSDate *createTime = self.tdDiary[@"createdAt"];
    NSDate *updateTime = self.tdDiary[@"updatedAt"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *crTime = [formatter stringFromDate:createTime];
    NSString *endTime = [formatter stringFromDate:updateTime];
    
    
    if ([isEndTDDiary isEqualToString:@"YES"]) {
        
        NSString *tdTimes = [NSString stringWithFormat:@"%@%@%@",crTime,@" - ",endTime];
        self.titTimesLabel .text = tdTimes;
        
    }else{
        
        NSString *tdTimes = [NSString stringWithFormat:@"%@%@%@",crTime,@" - ",@" "];
        self.titTimesLabel.text = tdTimes;
    }
    
    
    
    
    //    self.titView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 15.0 * 8.0)];
    //    [self.titView layoutIfNeeded];
    //    UIImageView *titImageView = [[UIImageView alloc]initWithFrame:self.titView.frame];
    //    AVFile *tdImageFile= [self.tdDiary objectForKey:@"backImageName"];
    //    NSData *imageData = [tdImageFile getData];
    //    titImageView.image = [UIImage imageWithData:imageData];
    //
    //
    //    UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, _titView.frame.size.width - 20, 40)];
    //    titLabel.numberOfLines = 0;
    //    titLabel.textColor = [UIColor whiteColor];
    //    titLabel.text = self.tdDiary[@"nameDiary"];
    //    titLabel.font = [UIFont boldSystemFontOfSize:19];
    //
    //
    //
    //
    //
    //    CGRect titNameFrame = titLabel.frame;
    //    CGSize titNameSize = [self.tdDiary[@"nameDiary"] sizeWithMaxSize:CGSizeMake(_titView.frame.size.width - 20, MAXFLOAT) fontSize:19];
    //    titNameFrame.size = titNameSize;
    //    titLabel.frame = titNameFrame;
    //
    //
    //    UILabel *titTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titNameSize.height  + 20, _titView.frame.size.width - 20, 40)];
    //    titTimeLabel.numberOfLines = 0;
    //    titTimeLabel.textColor = [UIColor whiteColor];
    //    titTimeLabel.font = [UIFont italicSystemFontOfSize:11];
    //
    //    CGRect titTiemFrame = titTimeLabel.frame;
    //
    //    NSDate *createTime = self.tdDiary[@"createdAt"];
    //    NSString *isEndTDDiary = self.tdDiary[@"isEndTDDiary"];
    //    NSDate *updateTime = self.tdDiary[@"updatedAt"];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    NSString *crTime = [formatter stringFromDate:createTime];
    //    NSString *endTime = [formatter stringFromDate:updateTime];
    //
    //
    //    if ([isEndTDDiary isEqualToString:@"YES"]) {
    //
    //        NSString *tdTimes = [NSString stringWithFormat:@"%@%@%@",crTime,@" - ",endTime];
    //        titTimeLabel.text = tdTimes;
    //
    //    }else{
    //
    //        NSString *tdTimes = [NSString stringWithFormat:@"%@%@%@",crTime,@" - ",@" "];
    //        titTimeLabel.text = tdTimes;
    //    }
    //
    //    CGSize titTimeSize = [titTimeLabel.text sizeWithMaxSize:CGSizeMake(_titView.frame.size.width - 20, MAXFLOAT) fontSize:11];
    //
    //
    //    titTiemFrame.size = titTimeSize;
    //    titTimeLabel.frame = titTiemFrame;
    //
    //
    //
    
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
