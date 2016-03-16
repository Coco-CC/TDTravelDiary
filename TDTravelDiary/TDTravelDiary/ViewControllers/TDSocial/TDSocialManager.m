//
//  TDSocialManager.m
//  TDTravelDiary
//
//  Created by co on 15/11/26.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDSocialManager.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
@interface TDSocialManager ()<AVIMClientDelegate>
@property (nonatomic,strong) AVIMClient *client;


@end


@implementation TDSocialManager
static TDSocialManager *scialManager = nil;
+(TDSocialManager *)socialManager
{
   static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scialManager = [[TDSocialManager alloc]
        init];
    });
    return scialManager;
    
}


//关注某人
- (void)FolloweeSomeOneWithUserID:(NSString *)userObjectId objects:(NSArray *)object target:(id)target
{
    
    
//    [[AVUser currentUser]getFollowees:^(NSArray *objects, NSError *error) {
//        for (NSDictionary *dic in objects) {
//            for (NSString *username in dic[@"objectId"]) {
//                if([username isEqualToString:[object.firstObject objectForKey:@"objectId"]])
//                {
//                    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"关注成功！" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        
//                    }];
//                    [alertvc addAction:action1];
//                    
//                }
//            }
//        }
//    }];
    
    NSString *userID = [[object objectAtIndex:0] objectForKey:@"objectId"];
    
    
 [[AVUser currentUser] follow:userID andCallback:^(BOOL succeeded, NSError *error) {

     if(succeeded)
     {
//         NSLog(@"关注成功");
         UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"关注成功！" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             
         }];
         [alertvc addAction:action1];
         [target presentViewController:alertvc animated:YES completion:nil];
         
         
     }
     else if(!succeeded)
     {
//         NSLog(@"关注失败");
         UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"关注失败" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             
         }];
         [alertvc addAction:action1];
         [target presentViewController:alertvc animated:YES completion:nil];

     
     }
     else if(error)
     {
//         NSLog(@"关注出错%@",error);
         
         UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"关注出错！" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             
         }];
         [alertvc addAction:action1];
         [target presentViewController:alertvc animated:YES completion:nil];

         NSLog(@"%@",error);
         
     
     }
     else
     {
         NSLog(@"草泥马");
     }
 }];
    


}
//查询并添加关注某人

- (void)addFollowee:(NSString *)userID target:(id)target

{
    
   
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:userID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
        {
            NSLog(@"发生错误%@",error);
        }
        else if(objects.count == 0)
        {
//            NSLog(@"没有这个人");
            UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"并没有此用户" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
            [alertvc addAction:action1];
            
        
        }
        else if ([userID isEqualToString:[AVUser currentUser].username])
        {
            UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"不能添加自己哦" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertvc addAction:action1];
            
        
        }
        else
        {
            [self FolloweeSomeOneWithUserID:userID objects:objects target:target];
           
        
        
        }
    }];
    
    


}
- (void)CancelFolloweeSomeOneWithUserID:(NSString *)userObjectId
{
[[AVUser currentUser]unfollow:userObjectId andCallback:^(BOOL succeeded, NSError *error) {
    if(succeeded)
    {
//        NSLog(@"取消关注成功");
        
    }
    else if(!succeeded)
    {
//        NSLog(@"取消关注失败");
        
    }
    else if(error)
    {
//        NSLog(@"取消关注出错！");
        NSLog(@"%@",error);
        
        
    }

    
}];

}
//获取粉丝列表
- (void)getFollowersList:(void(^)(NSArray *resultArray))handel
{
[[AVUser currentUser]getFollowers:^(NSArray *objects, NSError *error) {
    NSArray *followers = objects;
    
    //返回主线程
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        handel(followers);
        

    });
    
    
}];
    

}
//获取关注列表
- (void)getFolloweesList:(void(^)(NSMutableArray *resultArray))handel
{
[[AVUser currentUser]getFollowees:^(NSArray *objects, NSError *error) {
    NSMutableArray *followArray = [NSMutableArray arrayWithArray:objects];
    //返回主线程
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        handel(followArray);
        
    });
    
}];
    
}

- (instancetype)init
{
   self = [super init];
    if(self)
    {
        self.client =[[ AVIMClient alloc]init];

        
    
    }
    return self;

}
//发送消息
- (void)sendMessageFromuser:(NSString *)senduser toUser:(NSString *)getUser withMessage:(NSString *)message
{
    

    //self.client = [[AVIMClient alloc]init];
    [self.client openWithClientId:senduser callback:^(BOOL succeeded, NSError *error) {
        [self.client createConversationWithName:@"对话" clientIds:@[getUser] callback:^(AVIMConversation *conversation, NSError *error) {
            [conversation sendMessage:[AVIMTextMessage messageWithText:message attributes:nil] callback:^(BOOL succeeded, NSError *error) {
                if(succeeded)
             {
//                 NSLog(@"发送信息成功");
//                    NSLog(@"%@",message);
                }
                
            }];
        }];
    }];

}

//接收消息
- (void)getMessageWithUserID:(NSString *)userID delegate:(id)delegate
{
    
    //self.client = [[AVIMClient alloc]init];

    //self.client.delegate = self;
    self.client.delegate = delegate;

    [self.client openWithClientId:userID callback:^(BOOL succeeded, NSError *error) {
        if(succeeded)
            
        {
//            NSLog(@"接收消息成功");
            
        
        }
    }];

}





@end
