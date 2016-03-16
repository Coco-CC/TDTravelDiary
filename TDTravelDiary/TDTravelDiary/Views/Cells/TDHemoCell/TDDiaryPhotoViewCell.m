//
//  TDDiaryPhotoViewCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDDiaryPhotoViewCell.h"
#import "UIImageView+WebCache.h"

#import "NSString+Categorys.h"
@interface TDDiaryPhotoViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *rongView;


@end

@implementation TDDiaryPhotoViewCell

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
    if (![self.tirpNotesNotesInfo.descriptions isEqualToString:@""]) {
         self.titLabel.text = self.tirpNotesNotesInfo.descriptions;
        CGRect titFrame = self.titLabel.frame;
        CGSize titSize = [self.titLabel.text sizeWithMaxSize:CGSizeMake(self.frame.size .width- 46, MAXFLOAT) fontSize:15];
        
        titFrame.size = titSize;
        self.titLabel.frame = titFrame;
    }
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.tirpNotesNotesInfo.photoInfo.url]];

}

//点击喜欢按钮
- (IBAction)didClickloveButton:(id)sender {
    
    if (self.tirpNotesNotesInfo.isLove) {
        [self.loveButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zhstxihuan_hemo"] forState:UIControlStateNormal];
        
        self.tirpNotesNotesInfo.isLove = NO;
        
    }else{
        
           [self.loveButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zhstxihuan (1)_hemo"] forState:UIControlStateNormal];
        self.tirpNotesNotesInfo.isLove = YES;
        
    }
    
  
}
//点击评论按钮
- (IBAction)didClickComentButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didChangeValueForKey:)]) {
        [self.delegate didClickCommentToShowComment:self.tirpNotesNotesInfo];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
