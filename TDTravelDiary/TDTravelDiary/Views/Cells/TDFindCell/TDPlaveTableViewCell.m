//
//  TDPlaveTableViewCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDPlaveTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface TDPlaveTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *plaveImageView;
@property (weak, nonatomic) IBOutlet UILabel *plaveNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *plaveNameENLabel;
@end
@implementation TDPlaveTableViewCell
- (void)awakeFromNib {
    // Initialization code
}
-(void)setPlaveModel:(TDPlaceModel *)plaveModel{
    if (_plaveModel != plaveModel) {
        _plaveModel = nil;
        _plaveModel = plaveModel;
        [self layoutModel];
    }
}
-(void)layoutModel{
    [self.plaveImageView sd_setImageWithURL:[NSURL URLWithString:self.plaveModel.image_url]];
    self.plaveNameLabel.text =self.plaveModel.name_zh_cn;
    self.plaveNameENLabel.text = self.plaveModel.name_en;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
