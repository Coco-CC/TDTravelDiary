//
//  Name+CoreDataProperties.h
//  TDTravelDiary
//
//  Created by co on 15/11/29.
//  Copyright © 2015年 Coco. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Name.h"

NS_ASSUME_NONNULL_BEGIN

@interface Name (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *currentuserID;
@property (nullable, nonatomic, retain) NSString *otheruserID;
@property (nullable, nonatomic, retain) NSSet<Content *> *message;

@end

@interface Name (CoreDataGeneratedAccessors)

- (void)addMessageObject:(Content *)value;
- (void)removeMessageObject:(Content *)value;
- (void)addMessage:(NSSet<Content *> *)values;
- (void)removeMessage:(NSSet<Content *> *)values;

@end

NS_ASSUME_NONNULL_END
