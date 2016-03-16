//
//  TDFindCollectionViewCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDFindCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface TDFindCollectionViewCell ()
@property(nonatomic,strong)UIImageView *findCellImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *nameENLabel;
@end
@implementation TDFindCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图片
        self.findCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.contentView addSubview:self.findCellImageView];
        //label/添加到北京那个图片上
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.width-40, self.frame.size.width -20, 30)];
        self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.findCellImageView addSubview:self.nameLabel];
        self.nameENLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.width-70, self.frame.size.width -70, 30)];
        self.nameENLabel.textColor = [UIColor whiteColor];
        [self.findCellImageView addSubview:self.nameENLabel];
    }
    return self;
}

//model
-(void)setFindCellModel:(TDFindModel *)findCellModel{
    if (_findCellModel != findCellModel) {
        _findCellModel = nil;
        _findCellModel = findCellModel;
        [self layoutModel];
    }
}
-(void)layoutModel{
    [self.findCellImageView sd_setImageWithURL:[NSURL URLWithString:self.findCellModel.image_url]];
    self.nameLabel.text = self.findCellModel.name_zh_cn;
    self.nameENLabel.text = self.findCellModel.name_en;
}












@end
