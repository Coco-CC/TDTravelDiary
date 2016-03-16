//
//  TDDiaryTextViewCell.h
//  TDTravelDiary
//
//  Created by co on 15/11/19.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDTirpNodesInfo.h"
#import "TDTirpNotesNotesInfo.h"


@protocol ClickCommentDelegate <NSObject>


-(void)didClickCommentToShowComment:(TDTirpNotesNotesInfo *)notesInfo;

@end

@interface TDDiaryTextViewCell : UITableViewCell

@property (nonatomic,strong) TDTirpNodesInfo *tirpNotesInfo;
@property (nonatomic,strong) TDTirpNotesNotesInfo *tirpNotesNotesInfo;
@property (nonatomic,assign) id<ClickCommentDelegate>delegate;



//返回行高
+(CGFloat)heightForTDDiaryTextViewCellWithName:(TDTirpNotesNotesInfo *)tirpNotesNotesInfo
                                      andWidth:(CGFloat)width;



@end
