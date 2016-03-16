//
//  CostDetailModel.h
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CostDetailModel : NSObject
//Model的数据从数据库(本地)获取
//@property (nonatomic,strong) NSString *costType;
@property (nonatomic,strong) NSString *costMoney;
@property (nonatomic,strong) NSString *costDetail;
//@property (nonatomic,strong) NSString *costcontent;
@property (nonatomic,strong) NSString *costDate;
@property (nonatomic,strong) NSString *allMoney;
@end
