//
//  TDDiaryTextViewCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDDiaryTextViewCell.h"

#import "NSString+Categorys.h"
@interface TDDiaryTextViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *rongView;

@end

@implementation TDDiaryTextViewCell




- (void)awakeFromNib {
    // Initialization code
}





-(void)setTirpNotesInfo:(TDTirpNodesInfo *)tirpNotesInfo{
    if (_tirpNotesInfo!= tirpNotesInfo) {
        _tirpNotesInfo = nil;
        _tirpNotesInfo = tirpNotesInfo;
        [self layoutModea];
    }
}
-(void)setTirpNotesNotesInfo:(TDTirpNotesNotesInfo *)tirpNotesNotesInfo{
    if (_tirpNotesNotesInfo!= tirpNotesNotesInfo) {
        _tirpNotesNotesInfo = nil;
        _tirpNotesNotesInfo = tirpNotesNotesInfo;
        [self layourModeb];
    }
}

-(void)layoutModea{
    if (!self.tirpNotesInfo.entry_name ) {
       
        self.addressView.hidden = YES;
    }else{
        self.addressLabel.text = self.tirpNotesInfo.entry_name;
    }
}
-(void)layourModeb{
    
    self.rongView.layer.cornerRadius = 5;
    self.rongView.layer.masksToBounds = YES;
    
    self.nameLabel.text = self.tirpNotesNotesInfo.descriptions;
    CGRect nameFrame = self.nameLabel.frame;
    CGSize nameSize = [self.nameLabel.text sizeWithMaxSize:CGSizeMake(self.frame.size.width, MAXFLOAT)  fontSize:15];
    nameFrame.size = nameSize;
}
//返回行高
+(CGFloat)heightForTDDiaryTextViewCellWithName:(TDTirpNotesNotesInfo *)tirpNotesNotesInfo
                                      andWidth:(CGFloat)width{

   return   [tirpNotesNotesInfo.descriptions sizeWithMaxSize:CGSizeMake(width, MAXFLOAT) fontSize:15].height + 8 +16+30;

}

//点击喜欢的方法
- (IBAction)didClickloveButton:(id)sender {
    
    if (self.tirpNotesNotesInfo.isLove) {
        [self.loveButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zhstxihuan_hemo"] forState:UIControlStateNormal];
        self.tirpNotesNotesInfo.isLove = NO;
    }else{
        [self.loveButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zhstxihuan (1)_hemo"] forState:UIControlStateNormal];
        self.tirpNotesNotesInfo.isLove = YES;
        
    }
}

//点击评论的方法
- (IBAction)didClickCommentButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didChangeValueForKey:)]) {
        [self.delegate didClickCommentToShowComment:self.tirpNotesNotesInfo];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
