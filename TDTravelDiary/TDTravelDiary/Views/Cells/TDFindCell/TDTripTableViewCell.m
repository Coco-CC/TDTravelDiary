//
//  TDTripTableViewCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDTripTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface TDTripTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *tripImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *describeLabe;

@end
@implementation TDTripTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setTripModel:(TDTripModel *)tripModel{
    if (_tripModel != tripModel) {
        _tripModel = nil;
        _tripModel = tripModel;
        [self layoutModel];
    }
}
-(void)layoutModel{
//    self.describeLabe.layer.borderColor = [[UIColor grayColor] CGColor];
//    self.describeLabe.layer.borderWidth = 2;
    self.describeLabe.layer.cornerRadius = 10;
    [self.tripImageView sd_setImageWithURL:[NSURL URLWithString:self.tripModel.image_url]];
    self.nameLabel.text = self.tripModel.name;
    self.timeLabel.text = [[NSString stringWithFormat:@"%ld",(long)self.tripModel.plan_days_count] stringByAppendingString:@"天"];
    self.addressLabel.text =[[NSString stringWithFormat:@"%ld",(long)self.tripModel.plan_nodes_count] stringByAppendingString:@"旅游地点"];
    self.describeLabe.text = self.tripModel.descriptions;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
