//
//  TDHomeSearchCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/21.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDHomeSearchCell.h"

@interface TDHomeSearchCell ()

@property (nonatomic,strong) UIView *conView;
@property (nonatomic,strong) UILabel *nameLabel;

@end
@implementation TDHomeSearchCell


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setSubupView];
    }
    return self;
}

-(void)setSubupView{
    self.conView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.conView.layer.cornerRadius = 5;
    self.conView.layer.masksToBounds = YES;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,5, self.frame.size.width -10, self.frame.size.height -10 )];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.conView addSubview:self.nameLabel];
    self.conView.backgroundColor =[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self.contentView addSubview:self.conView];
}
-(void)setListInfo:(TDHomeSearchListInfo *)listInfo{
    if (_listInfo != listInfo) {
        _listInfo = nil;
        _listInfo = listInfo;
        [self layoutMode];
    }
}
-(void)layoutMode{
    self.nameLabel.text = self.listInfo.name;
}
- (void)awakeFromNib {
    // Initialization code
}
@end
