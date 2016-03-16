//
//  TDTalkingViewCell.m
//  TDTravelDiary
//
//  Created by co on 15/11/28.
//  Copyright © 2015年 Coco. All rights reserved.
//
#import "TDTalkingViewCell.h"

#import "NSString+Categorys.h"

@interface TDTalkingViewCell ()

@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic,strong) UILabel *messageLable;
@property (nonatomic,strong) UIView *view;


@end

@implementation TDTalkingViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
//        self.imageview = [[UIImageView alloc]init];
//        self.messageLable = [[UILabel alloc]init];
//        [self.contentView addSubview:self.imageview];
//        [self.contentView addSubview:self.messageLable];
        //self.view = [[UIView alloc]init];
        //[self.contentView addSubview:self.view];
        //self.view = [[UIView alloc]init];
        
        
    }
    return self;
    
}






//- (void)setModel:(NSDictionary *)model{
//    if (_model != model) {
//        _model = nil;
//        _model = model;
//        [self layoutModel];
//    }
//}
//- (void)layoutModel{
////    self.messageLable.text = self.model[@"content"];
//    //头像
//    if([self.model[@"name"] isEqualToString:@"Other"])
//    {
////        self.imageview.frame = CGRectMake(0, 30, 30, 30);
////        self.imageview.backgroundColor = [UIColor blueColor];
////        self.messageLable.frame = CGRectMake(45, 30, 300, 30);
////        self.messageLable.backgroundColor = [UIColor grayColor];
//       // UIView *view = [[UIView alloc]init];
//        //UIView *view = [[UIView alloc]init];
//        for (UIView *view in self.subviews) {
//            [view removeFromSuperview];
//            
//        }
//        self.view = [[UIView alloc]init];
//        
//        self.view = [self bubbleViewWithText:self.model[@"content"] form:NO withPosition:50];
//        [self addSubview:self.view];
//        
//        
//    }else
//    {
////        self.imageview.frame = CGRectMake(345, 30, 30, 30);
////        self.imageview.backgroundColor = [UIColor redColor];
////        self.messageLable.frame = CGRectMake(45, 30, 300, 30);
////        self.messageLable.backgroundColor = [UIColor grayColor];
//        //UIView *view = [[UIView alloc]init];
//        for (UIView *view in self.subviews) {
//            [view removeFromSuperview];
//            
//        }
//        self.view = [[UIView alloc]init];
//        
//        self.view = [self bubbleViewWithText:self.model[@"content"] form:YES withPosition:50];
//        [self addSubview:self.view];
//        
//    }
//    
//}

- (UIView *)bubbleViewWithText:(NSString *)text form:(BOOL)fromSelf withPosition:(int)position{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f)];
    
    
    
    //
    UIView *returnView = [[UIView alloc]initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    //背景图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fromSelf ? @"Me.jpg":@"Other.jpg" ofType:nil]];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width /2 ) topCapHeight:floorf(bubble.size.height / 2)]];
    
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf ? 15.0f : 22.0f, 20.f, size.width + 15, size.height + 15)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0 ;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0, 14, bubbleText.frame.size.width + 30, bubbleText.frame.size.height +30);
    
    if(fromSelf)
        returnView.frame = CGRectMake(self.contentView.bounds.size.width-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    else
        returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView;
    
}









@end