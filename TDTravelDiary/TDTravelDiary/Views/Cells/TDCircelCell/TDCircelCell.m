//
//  TDCircelCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/25.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDCircelCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Categorys.h"
#import "URL.h"
#import "TDCircleCommentController.h"
#import "TDDiaryHemoManager.h"

@interface TDCircelCell ()
@property (weak, nonatomic) IBOutlet UIView *rongView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *pingButton;
//@property (weak, nonatomic) IBOutlet  UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIView *addressRongView;
@property (weak, nonatomic) IBOutlet UILabel *diaryTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *diaryImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic,strong) TDDiaryHemoManager *manager;

@property (nonatomic,strong) AVObject *tdLoveDiary;
@property (nonatomic,strong) AVObject *userObject;
@property (nonatomic,assign,getter=isLoveTDiary) BOOL isLoveTDiary;
@property (nonatomic,strong) NSNumber *isLoveTD;
@property (nonatomic,strong) AVUser *currentUser;

@property (weak, nonatomic) IBOutlet UIImageView *loveImageView;
@property (nonatomic,strong) AVObject *otherUserObject;
@property (nonatomic,strong) AVObject *tdFriend ;



@end

@implementation TDCircelCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setTdListDiary:(AVObject *)tdListDiary{
    
    if (_tdListDiary != tdListDiary) {
        _tdListDiary = nil;
        _tdListDiary = tdListDiary;
        [self layoutMode];
    }
}


-(void)layoutMode{
    
    
    
    //self.addsButton.hidden = YES;
    self.loveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickLoveImageVime:)];
    [self.loveImageView addGestureRecognizer:tapGes];
    //    self.loveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //    self.loveButton.frame = self.tdLoveButton.frame;
    //
    //    [self.loveButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zhstxihuan_hemo"] forState:(UIControlStateNormal)];
    //
    //    [self.loveButton addTarget:self action:@selector(didClickLoveButton:) forControlEvents:(UIControlEventTouchUpInside)];
    //
    //    [self.rongView addSubview:self.loveButton];
    //    [self.rongView bringSubviewToFront:self.loveButton];
 
    self.currentUser = [AVUser currentUser];
    if (self.currentUser != nil) {
        // 允许用户使用应用
        //  NSLog(@"%@",self.currentUser);
        
        
        self.manager = [TDDiaryHemoManager defaultManager];
        [self.manager getUserWithusername:self.tdListDiary[@"userKey"] Handler:^(AVObject *object) {
            self.otherUserObject = object;
            UIImage *pleImage = [UIImage imageNamed:@"shu.jpg"];
            if (object[@"nickname"]) {
                self.userNameLabel.text = object[@"nickname"];
            }else{
                self.userNameLabel.text = @"旅迹用户";
            }
            if (object[@"thirdIcon"]) {
                
                [self.userImageView sd_setImageWithURL:object[@"thirdIcon"] placeholderImage:pleImage];
            }else if(object[@"userImage"]){
                
                AVFile *tdImageFile=  object[@"userImage"];//[self.tdListDiary objectForKey:@"diaryImage"];
                NSData *imageData = [tdImageFile getData];
                self.userImageView.image = [UIImage imageWithData:imageData];
                
            }else{
                self.userImageView.image = pleImage;
            }
        
        } Fail:^{
            self.userNameLabel.text = @"旅迹用户";
            self.userImageView.image =[UIImage imageNamed:@"shu.jpg"];
        }];
    } else {
    }
    

        
            [self.manager getUserWithusername:self.currentUser[@"username"] Handler:^(AVObject *object) {
                self.userObject = object;
            } Fail:^{
            }];


    
    self.rongView.layer.cornerRadius = 5;
    self.rongView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 25;
    self.userImageView.layer.masksToBounds = YES;
    self.userNameLabel.text = @"旅迹用户";
    self.userImageView.image =[UIImage imageNamed:@"shu.jpg"];
    
    
    
    //  self.userImageView.image = self.circelInfo.tdImage;
    //   self.timeLabel.text = self.tdListDiary[@"createdAt"];
    
    NSDate *createTime = self.tdListDiary[@"createdAt"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
   //  NSLog(@"%@",self.tdListDiary[@"createdAt"]);
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *tdTime = [formatter stringFromDate:createTime];
    self.timeLabel.text = tdTime;
    AVFile *tdImageFile= [self.tdListDiary objectForKey:@"diaryImage"];
    NSData *imageData = [tdImageFile getData];
    //    //                tdCircel.tdImage = [UIImage imageWithData:imageData];
    self.diaryImageView.image = [UIImage imageWithData:imageData];
    self.diaryTextLabel.text = self.tdListDiary[@"diaryText"];
    
    if (self.tdListDiary[@"addressText"]) {
        self.addressLabel.text = self.tdListDiary[@"addressText"];
        self.addressRongView.hidden = NO;
    }else{
        self.addressRongView.hidden = YES;
    }
    
    CGRect diaryTextFrame = self.diaryTextLabel.frame;
    CGSize textSize = [self.tdListDiary[@"diaryText"] sizeWithMaxSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT) fontSize:15 ];
    diaryTextFrame.size = textSize;
    
    self.diaryTextLabel.frame = diaryTextFrame;
}

- (IBAction)didClickAddButton:(id)sender {
    
    
    
    
    AVQuery *tdFriendQuery = [AVQuery queryWithClassName:@"TdFriendObject"];
    [tdFriendQuery whereKey:@"userKey" equalTo:self.currentUser[@"username"]];
    [tdFriendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
         //   NSLog(@"Successfully retrieved %lu posts.", (unsigned long)objects.count);
            for (AVObject *obj in objects) {
                
                if ([obj[@"tdFUserKey"] isEqualToString:self.otherUserObject[@"userKey"]]) {
                    self.tdFriend = obj;
                }
            }
            if (self.tdFriend ==nil) {
                self.tdFriend = [AVObject objectWithClassName:@"TdFriendObject"];
            }
        } else {
            // 输出错误信息
         //   NSLog(@"Error: %@ %@", error, [error userInfo]);
            self.tdFriend = [AVObject objectWithClassName:@"TdFriendObject"];
        }
    }];
    [self.tdFriend setObject:self.tdListDiary[@"userKey"] forKey:@"tdFUserKey"];
    [self.tdFriend setObject:self.userObject[@"userKey"] forKey:@"userKey"];
    [self.tdFriend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self.addsButton.hidden = YES;
            if ([self.delegate respondsToSelector:@selector(didAddFriendButtonAction)]) {
                self.addsButton.hidden = NO;
                [self.delegate didAddFriendButtonAction];
            }
        }else{
        }
    }];
    
}


- (void)didClickLoveImageVime:(id)sender {
    
}
-(void)removeLoveButtonImage{
    //  [self.loveButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zhstxihuan_hemo"] forState:(UIControlStateNormal)];
    // [self.loveButton removeFromSuperview];
//    
//    if (_isLoveTDiary) {
//        
//        [UIImage imageNamed:@"iconfont-zhstxihuan (1)_hemo"];
//       // [self.loveButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zhstxihuan (1)_hemo"] forState:(UIControlStateNormal)];
//    }else{
//        
//        [UIImage imageNamed:@"iconfont-zhstxihuan_hemo"];
//       // [self.loveButton setBackgroundImage:[UIImage imageNamed:@"iconfont-zhstxihuan_hemo"] forState:(UIControlStateNormal)];
//    }
   
}




- (void)didClickPingButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didCommentsButtonPush:)]) {
        [self.delegate didCommentsButtonPush:self.tdListDiary];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
