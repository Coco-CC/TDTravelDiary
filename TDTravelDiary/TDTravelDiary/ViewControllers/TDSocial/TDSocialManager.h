//
//  TDSocialManager.h
//  TDTravelDiary
//
//  Created by co on 15/11/26.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDSocialManager : NSObject

+ (TDSocialManager *)socialManager;
//关注某人
//- (void)FolloweeSomeOneWithUserID:(NSString *)userObjectId;
//取消关注某人
- (void)CancelFolloweeSomeOneWithUserID:(NSString *)userObjectId;

//查询添加关注某人
- (void)addFollowee:(NSString *)userID target:(id)target
;



//获取关注列表
- (void)getFolloweesList:(void(^)(NSMutableArray *resultArray))handel;
//获取粉丝列表
- (void)getFollowersList:(void(^)(NSArray *resultArray))handel;
//- (void)sendMessageToSomeOneWithUserId:(NSString *)userObjectId message:(NSString *)message;
//- (void)reciveMessageFromSomeOne;
- (void)sendMessageFromuser:(NSString *)senduser toUser:(NSString *)getUser withMessage:(NSString *)message;
- (void)getMessageWithUserID:(NSString *)userID delegate:(id)delegate;



@end
