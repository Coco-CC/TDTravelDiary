//
//  TDCostDetailCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDCostDetailCell.h"
#import "CostDetailModel.h"
@interface TDCostDetailCell()
@property (nonatomic,strong) UILabel *costTypeLable;
@property (nonatomic,strong) UILabel *moneyLable;
@property (nonatomic,strong) UILabel *costDetailLabe;
@property (nonatomic,strong) UILabel *costcontent;

@property (nonatomic,strong) UILabel *dateLable;

@end
@implementation TDCostDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setcellFrame];
        
    
    }
    return self;
}
- (void)setCostModel:(CostDetailModel *)costModel
{
if(_costModel != costModel)
    
{
    _costModel = nil;
    _costModel = costModel;
    
    [self setcellData];
}

}
- (void)setcellFrame
{
    self.costTypeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 75, 20)];
    self.moneyLable = [[UILabel alloc]initWithFrame:CGRectMake(105, 10, 150, 20)];
    self.costcontent = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 75, 20)];
    self.costcontent.numberOfLines = 0;
    
    self.costDetailLabe = [[UILabel alloc]initWithFrame:CGRectMake(105, 40, 150, 20)];
    
    
    self.costDetailLabe.numberOfLines = 0;
    self.dateLable = [[UILabel alloc]initWithFrame:CGRectMake(275, 100, 100, 20)];
    
    [self.contentView addSubview:self.costTypeLable];
    [self.contentView addSubview:self.moneyLable];
    [self.contentView addSubview:self.costcontent];
    [self.contentView addSubview:self.costDetailLabe];
    [self.contentView addSubview:self.dateLable];
    
    
}
- (void)setcellData
{
    //self.costTypeLable.text = self.costModel.costType;
    self.costTypeLable.text = @"本次消费";
    self.costcontent.text = @"消费内容";
    
    self.moneyLable.text = [self.costModel.costMoney stringByAppendingString:@"  RMB"];
    self.costDetailLabe.text = self.costModel.costDetail;
    self.dateLable.text = self.costModel.costDate;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
