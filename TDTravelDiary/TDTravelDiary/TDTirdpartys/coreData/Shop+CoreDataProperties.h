//
//  Shop+CoreDataProperties.h
//  TDTravelDiary
//
//  Created by co on 15/11/29.
//  Copyright © 2015年 Coco. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Shop.h"

NS_ASSUME_NONNULL_BEGIN

@interface Shop (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *costdate;
@property (nullable, nonatomic, retain) NSString *costdetail;
@property (nullable, nonatomic, retain) NSString *costmoney;
@property (nullable, nonatomic, retain) NSString *shopallmoney;

@end

NS_ASSUME_NONNULL_END
