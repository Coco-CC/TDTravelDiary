//
//  TDNearViewCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/24.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDNearViewCell.h"
#import "UIImageView+WebCache.h"
@interface TDNearViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageicon;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *ratingLable;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLable;
@property (weak, nonatomic) IBOutlet UILabel *distanceandecount;
@property (weak, nonatomic) IBOutlet UILabel *disTanceLable;

@end

@implementation TDNearViewCell

- (void)setGetModel:(TDGetNearModel *)getModel
{
    if (_getModel != getModel) {
        _getModel = nil;
        _getModel = getModel;
        [self setData];
    }
    
}
- (void)setData
{
    NSURL *url = [NSURL URLWithString:self.getModel.cover_s];
    [self.imageicon sd_setImageWithURL:url];
    
    
    self.imageicon.layer.cornerRadius = self.imageicon.frame.size.width/2;
    self.imageicon.layer.masksToBounds = YES;
    
    
    

    self.nameLable.text = self.getModel.name;
    
    

    
    NSString *rating = [NSString stringWithFormat:@"%@",self.getModel.rating];

    NSString *rat = @"评价：";
    NSString *rati = [rat stringByAppendingString:rating];
    self.ratingLable.text = rati;

    
    CGFloat descriptionHeight = [[self class]heigthForText:self.getModel.descrip FontSize:10 width:223];

    CGRect desFrame = self.descriptionLable.frame;
    desFrame.size.height = descriptionHeight;


    self.descriptionLable.frame = desFrame;


    
    self.descriptionLable.numberOfLines = 2;
    
    self.descriptionLable.text = self.getModel.descrip;

    
    
    //?????
   // NSString *distance = [NSString stringWithFormat:@"%lf",self.getModel.distance];
    NSString *wishcount = [NSString stringWithFormat:@"%@",self.getModel.wish_to_go_count];
    
    self.disTanceLable.text = [wishcount stringByAppendingString:@"人想去"];
    
    
    NSString *count = [NSString stringWithFormat:@"%@",self.getModel.visited_count];
    
    NSString *disandCount = [count stringByAppendingString:@"人去过"];
    self.distanceandecount.text = disandCount;
    
    

}
+(CGFloat)heigthForText:(NSString *)text FontSize:(CGFloat)fontSize width:(CGFloat)width{
    //字符绘制区域
    CGSize size = CGSizeMake(width, 1000);
    CGRect textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    //CGRect textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return textRect.size.height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
