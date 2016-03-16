//
//  TDUserCollectionViewCell.h
//  TDTravelDiary
//
//  Created by co on 15/11/25.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDUserCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
