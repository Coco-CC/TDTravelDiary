//
//  TDMsgCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDMsgCell.h"
#import "NSString+Categorys.h"
#import "UIImageView+WebCache.h"
#import "URL.h"
@interface TDMsgCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userTitImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;


@property (weak, nonatomic) IBOutlet UIView *bodyView;

@end
@implementation TDMsgCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setHomeMsgInfo:(TDHomeMsgInfo *)homeMsgInfo{

    if (_homeMsgInfo != homeMsgInfo) {
        _homeMsgInfo = nil;
        _homeMsgInfo = homeMsgInfo;
        
        [self layoutMode];
    }
}

-(void)setTdCommentsObject:(AVObject *)tdCommentsObject{
 
    if (_tdCommentsObject != tdCommentsObject) {
        _tdCommentsObject = nil;
        _tdCommentsObject = tdCommentsObject;
        [self layoutMode2];
    }
    
    
}


-(void)layoutMode2{

    self.bodyView.layer.cornerRadius = 8;
    self.bodyView.layer.masksToBounds = YES;
    self.userTitImage.layer.cornerRadius = 20;
    self.userTitImage.layer.masksToBounds = YES;
    AVFile *tdImageFile= self.tdCommentsObject[@"userImage"];//[self.tdListDiary objectForKey:@"diaryImage"];
    NSData *imageData = [tdImageFile getData];
    if (self.tdCommentsObject[@"userImage"]) {
         self.userTitImage.image = [UIImage imageWithData:imageData];
    }else{
       self.userTitImage.image = [UIImage imageNamed:@"shu.jpg"];
    }
    self.userNameLabel.text = self.tdCommentsObject[@"nickname"];
    self.contentLabel.text = self.tdCommentsObject[@"commentsText"];
    CGRect conFrame = self.contentLabel.frame;
    CGSize conSize = [self.tdCommentsObject[@"commentsText"] sizeWithMaxSize:CGSizeMake(conFrame.size.width, MAXFLOAT) fontSize:15];
    conFrame.size = conSize;
    self.contentLabel.frame = conFrame;
    self.timesLabel.text = self.tdCommentsObject[@"tdCreateTimes"];
}



-(void)layoutMode{


    
    self.bodyView.layer.cornerRadius = 8;
    self.bodyView.layer.masksToBounds = YES;
    self.userTitImage.layer.cornerRadius = 20;
    self.userTitImage.layer.masksToBounds = YES;
    
    
    if (self.homeMsgInfo.userImage) {
        self.userTitImage.image = self.homeMsgInfo.userImage;
    }else{
     [self.userTitImage sd_setImageWithURL:[NSURL URLWithString:self.homeMsgInfo.titImage]];
    }

    self.userNameLabel.text = self.homeMsgInfo.userName;
    self.contentLabel.text = self.homeMsgInfo.contentText;
    
    CGRect conFrame = self.contentLabel.frame;
    CGSize conSize = [self.homeMsgInfo.contentText sizeWithMaxSize:CGSizeMake(conFrame.size.width, MAXFLOAT) fontSize:15];
    conFrame.size = conSize;
    self.contentLabel.frame = conFrame;
    self.timesLabel.text = self.homeMsgInfo.timesText;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
