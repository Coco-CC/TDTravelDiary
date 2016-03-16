//
//  TDAccountBookCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDAccountBookCell.h"

@interface TDAccountBookCell()
@property (nonatomic,strong) UIImageView *imageview;


@end

@implementation TDAccountBookCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setcellFrame];
        
    
    }
    return self;

}
- (void)setcellFrame
{


}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
