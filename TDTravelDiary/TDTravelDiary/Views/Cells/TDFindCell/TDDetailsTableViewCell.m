//
//  TDDetailsTableViewCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface TDDetailsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailsImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation TDDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setPlanModel:(PlanModel *)planModel{

    if (_planModel != planModel) {
        _planModel =nil;
        _planModel = planModel;
        [self layoutModel];
    }
}
-(void)layoutModel{

    [self.detailsImageView sd_setImageWithURL:[NSURL URLWithString:self.planModel.image_url]];
    self.nameLabel.text = self.planModel.entry_name;
    self.tipsLabel.text = self.planModel.tips;


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
