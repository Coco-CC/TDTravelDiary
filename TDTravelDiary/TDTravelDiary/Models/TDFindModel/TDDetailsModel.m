//
//  TDDetailsModel.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDDetailsModel.h"
#import "PlanModel.h"

@interface TDDetailsModel ()
@property(nonatomic,strong)NSMutableArray *planModelArray;
@end

@implementation TDDetailsModel


-(NSMutableArray *)planArray{
    
    if (_planArray == nil) {
        _planArray = [[NSMutableArray alloc] init];
    }
    return _planArray;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
  
    if ([key isEqualToString:@"plan_nodes"]) {
       
        for (NSDictionary *dict in value) {
            PlanModel *pModel = [[PlanModel alloc] init];
            [pModel setValuesForKeysWithDictionary:dict];
            [self.planArray addObject:pModel];
        }
    }
}
@end
