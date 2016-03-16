//
//  TDNearDetailCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/25.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDNearDetailCell.h"
#import "TDGetNearModel.h"
#import "UIImageView+WebCache.h"

@interface TDNearDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *descripLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *telLable;
@property (weak, nonatomic) IBOutlet UILabel *gaikuangLable;
@property (weak, nonatomic) IBOutlet UILabel *dizhiLable;
@property (weak, nonatomic) IBOutlet UILabel *lianxiLable;


@end

@implementation TDNearDetailCell

- (void)setGetModel:(TDGetNearModel *)getModel
{
if(_getModel != getModel)
{
    _getModel = nil;
    _getModel = getModel;
    [self setData];
    
}
}

- (void)setData
{
    NSURL *url = [NSURL URLWithString:self.getModel.cover_s];
    
    
    
    CGFloat descriptionHeight = [[self class]heigthForText:self.getModel.descrip FontSize:10 width:355];
;
    CGRect desFrame = self.descripLable.frame;
    desFrame.size.height = descriptionHeight;

    self.descripLable.frame = desFrame;
    self.descripLable.layer.cornerRadius = 6;
    self.descripLable.layer.masksToBounds = YES;
    
    
    CGFloat addressHeight = [[self class]heigthForText:self.getModel.address FontSize:10 width:355];
    CGRect addFrame = self.addressLable.frame;
    addFrame.size.height = addressHeight;
    self.addressLable.frame = addFrame;
    
    
    
    [self.imageview sd_setImageWithURL:url];
    self.nameLable.text = self.getModel.name;
    self.descripLable.text = self.getModel.descrip;
    self.addressLable.text = self.getModel.address;
    
    self.telLable.text = self.getModel.tel;
    
    

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
