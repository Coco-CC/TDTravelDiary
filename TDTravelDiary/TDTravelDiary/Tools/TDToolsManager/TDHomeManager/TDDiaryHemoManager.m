//
//  TDDiaryHemoManager.m
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDDiaryHemoManager.h"
#import "TDNetWorkingTools.h"
#import "URL.h"
@interface TDDiaryHemoManager ()
@property (nonatomic,strong) NSMutableArray *sourceArray; //存放最新显示的数据
@property (nonatomic,strong) NSMutableArray *urlPathArray; //用于存放url请求参数的数组
@property (nonatomic,assign) NSInteger oldCountIndex;
@property (nonatomic,strong) NSMutableArray *indexssArray;//用于存放 已经读取的第几参数数组
@property (nonatomic,assign) NSInteger urlIndex;//请求第几条URL
@property (nonatomic,strong) NSMutableArray *searDidianArray;//点击搜索 地点 获取的数组
@property (nonatomic,strong) NSMutableArray *circelArray; //圈子数组

@property (nonatomic,assign) NSInteger circleOldIndex;// 用于记录旧的网络访问


@property (nonatomic,strong) NSMutableArray *userDiaryArray; // 用户所有的游记
@property (nonatomic,assign) NSInteger tduOldDiaryIndex;
@property (nonatomic,strong) NSMutableArray *tdListDiaryArray; // 个人具体的详细游记
@property (nonatomic,assign) NSInteger tdListOldDiaryIndex;



@end

@implementation TDDiaryHemoManager
//实现单例
static TDDiaryHemoManager *s_defaultManager = nil;
+(TDDiaryHemoManager *)defaultManager{
    static  dispatch_once_t  oneToken;
    dispatch_once(&oneToken, ^{
        if (s_defaultManager == nil) {
            s_defaultManager = [[self alloc]init];
        }
    });
    return  s_defaultManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.urlIndex = 20;
    }
    return self;
}

//网络请求数据
-(void)requestTDDataWithURlHandler:(void (^)())handler Fail:(void(^)())fail{
    
    
    [TDNetWorkingTools checkNetWorkTools];
    self.oldCountIndex = self.urlIndex;
    
    NSString *url = [NSString stringWithFormat:diaryHemo,self.urlIndex++];
    [TDNetWorkingTools jsonDataWithUrl:url succes:^(id json) {
        if ([json count]) {
            [self.sourceArray removeAllObjects];
        }else{
            self.urlIndex --;
        }
        for (NSDictionary *dataDict in json) {
            TDHomeDiaryInfo *diaryInfo = [[TDHomeDiaryInfo alloc]init];
            [diaryInfo setValuesForKeysWithDictionary:dataDict];
            [self.sourceArray addObject:diaryInfo];
        }
        //[self.oldSourcecArray addObject:self.sourceArray];
        handler();  //请求执行完毕，通知主页面刷新
    } fail:^{
        fail();
    }];
}
//上拉加载数据
-(void)requestTDOldDataHandler:(void(^)())handler Fail:(void(^)())fail{
    
    if (self.urlIndex > 21) {
        if (self.oldCountIndex > 20) {
            [TDNetWorkingTools checkNetWorkTools];
            NSString *url = [NSString stringWithFormat:diaryHemo,--self.oldCountIndex];
            [TDNetWorkingTools jsonDataWithUrl:url succes:^(id json) {
                //  [self.sourceArray removeAllObjects];
                for (NSDictionary *dataDict in json) {
                    TDHomeDiaryInfo *diaryInfo = [[TDHomeDiaryInfo alloc]init];
                    [diaryInfo setValuesForKeysWithDictionary:dataDict];
                    [self.sourceArray addObject:diaryInfo];
                }
                handler();  //请求执行完毕，通知主页面刷新
            } fail:^{
                fail();
            }];
        }
    }
}


//初始化数组
-(NSMutableArray *)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}

-(NSMutableArray *)indexssArray{
    if (!_indexssArray) {
        _indexssArray = [[NSMutableArray alloc]init];
    }
    return _indexssArray;
}

-(NSMutableArray *)searDidianArray{
    
    if (!_searDidianArray) {
        _searDidianArray = [NSMutableArray array];
    }
    return _searDidianArray;
    
}
-(NSMutableArray *)circelArray{
    
    if (!_circelArray) {
        _circelArray = [NSMutableArray array];
    }
    return _circelArray;
}

-(NSMutableArray *)userDiaryArray{
    if (!_userDiaryArray) {
        
        _userDiaryArray = [NSMutableArray array];
    }
    return _userDiaryArray;
}
-(NSMutableArray *)tdListDiaryArray{
    if (!_tdListDiaryArray ) {
        
        _tdListDiaryArray = [NSMutableArray array];
    }
    return  _tdListDiaryArray;
}





//获取解析到数据的总和
-(NSUInteger)tdhemoDiaryCount{
    return self.sourceArray.count;
}
//根据参数返回第几条数据
-(TDHomeDiaryInfo *)getElementDataWithIndex:(NSInteger )index{
    return self.sourceArray[index];
}
/**
 *  请求用户详情的页面
 *
 *  @param handler 刷新数据
 */
-(void)requestTdUserListDataWitghURL:(TDHomeDiaryInfo *)homeInfo Handler:(void(^)(TDUserDiaryListInfo *diaryInfo))handler Fail:(void(^)())fail{
    NSString *urlPath = [NSString stringWithFormat:diaryHemoList,homeInfo.diaryID];
    urlPath= [urlPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // NSLog(@"%@",urlPath);
    [TDNetWorkingTools checkNetWorkTools];
    [TDNetWorkingTools jsonDataWithUrl:urlPath succes:^(id json) {
        //  NSLog(@"===%@",json);
        self.userDiaryInfo = [[TDUserDiaryListInfo alloc]init];
        [self.userDiaryInfo setValuesForKeysWithDictionary:json];
        handler(self.userDiaryInfo);  //请求执行完毕，通知主页面刷新
    } fail:^{
        fail();
    }];
}
//根据url 获取搜索目录里的国家和省份的信息
-(void)requestSearchDataWithURlHandler:(void(^)(TDHemoSearchInfo *searchInfo))handler Fail:(void(^)())fail{
    
    
    [TDNetWorkingTools checkNetWorkTools];
    [TDNetWorkingTools jsonDataWithUrl:diaryHemoSearch succes:^(id json) {
        TDHemoSearchInfo *searchInfo = [[TDHemoSearchInfo alloc]init];
        [searchInfo setValuesForKeysWithDictionary:json];
        handler(searchInfo);
    } fail:^{
        fail();
    }];
}


/**
 *  根据url 搜索 信息 传过来地点的ID
 *
 *  @param serId
 *  @param handler
 */
-(void)requestSearchDiaryDataWithID:(NSString *)serId Handler:(void(^)())handler Fail:(void(^)())fail{
    
    
    self.searOldIndexURl = self.searIndexURL;
    NSString *url = [NSString stringWithFormat:diaryHemoSearList,serId,self.searIndexURL++];
    [TDNetWorkingTools checkNetWorkTools];
    [TDNetWorkingTools jsonDataWithUrl:url succes:^(id json) {
        
        
        [self.searDidianArray removeAllObjects];
        for (NSDictionary *dataDict in json) {
            
            
            TDHomeDiaryInfo *diaryInfo = [[TDHomeDiaryInfo alloc]init];
            [diaryInfo setValuesForKeysWithDictionary:dataDict];
            [self.searDidianArray addObject:diaryInfo];
        }
        handler();  //请求执行完毕，通知主页面刷新
    } fail:^{
        fail();
    }];
}
/**
 *  加载已经刷新过的数据
 *
 *  @param handler 返回
 */
-(void)requestSearchOldDataWithID:(NSString *)serId Handler:(void(^)())handler Fail:(void(^)())fail{
    
    if (self.searIndexURL > 2) {
        if (self.searOldIndexURl > 1) {
            [TDNetWorkingTools checkNetWorkTools];
            
            NSString *url = [NSString stringWithFormat:diaryHemoSearList,serId,--self.searOldIndexURl];
            
            [TDNetWorkingTools jsonDataWithUrl:url succes:^(id json) {
                //  [self.sourceArray removeAllObjects];
                for (NSDictionary *dataDict in json) {
                    TDHomeDiaryInfo *diaryInfo = [[TDHomeDiaryInfo alloc]init];
                    [diaryInfo setValuesForKeysWithDictionary:dataDict];
                    [self.searDidianArray addObject:diaryInfo];
                }
                handler();  //请求执行完毕，通知主页面刷新
            } fail:^{
                fail();
            }];
        }
    }
}


/**
 *  根据url 搜索 信息 传过来地点的ID
 *
 *  @param serId
 *  @param handler
 */
-(void)requestSearchDiaryDataWithAddress:(NSString *)address Handler:(void(^)())handler Fail:(void(^)())fail{
    
    
    self.searOldIndexURl = self.searIndexURL;
    NSString *url = [NSString stringWithFormat:diaryHemoSeartextList,address,self.searIndexURL++];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    [TDNetWorkingTools checkNetWorkTools];
    [TDNetWorkingTools jsonDataWithUrl:url succes:^(id json) {
        
        if ([json count]) {
            
            [self.searDidianArray removeAllObjects];
            
        }else{
            self.searIndexURL--;
        }
        for (NSDictionary *dataDict in json) {
            TDHomeDiaryInfo *diaryInfo = [[TDHomeDiaryInfo alloc]init];
            [diaryInfo setValuesForKeysWithDictionary:dataDict];
            [self.searDidianArray addObject:diaryInfo];
        }
        handler();  //请求执行完毕，通知主页面刷新
    } fail:^{
        fail();
    }];
    
}


/**
 *  加载已经刷新过的数据
 *
 *  @param handler 返回
 */
-(void)requestSearchOldDataWithAddress:(NSString *)address Handler:(void(^)())handler Fail:(void(^)())fail{
    
    
    if (self.searIndexURL > 2) {
        if (self.searOldIndexURl > 1) {
            [TDNetWorkingTools checkNetWorkTools];
            
            NSString *url = [NSString stringWithFormat:diaryHemoSeartextList,address,--self.searOldIndexURl];
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [TDNetWorkingTools jsonDataWithUrl:url succes:^(id json) {
                //  [self.sourceArray removeAllObjects];
                for (NSDictionary *dataDict in json) {
                    TDHomeDiaryInfo *diaryInfo = [[TDHomeDiaryInfo alloc]init];
                    [diaryInfo setValuesForKeysWithDictionary:dataDict];
                    [self.searDidianArray addObject:diaryInfo];
                }
                handler();  //请求执行完毕，通知主页面刷新
            } fail:^{
                fail();
            }];
        }
    }
}

/**
 *  返回根据地点搜索获取的数组个数
 *
 *  @return
 */
-(NSUInteger)tdhdSearchDidianCount{
    return self.searDidianArray.count;
}
/**
 *  根据参数 返回数组中的某条数据
 *
 *  @param index 第几条数据
 *
 *  @return 返回值
 */
-(TDHomeDiaryInfo *)getElementDataSearchDidianWithIndex:(NSInteger )index{
    return self.searDidianArray[index];
}


//将数组内的弄荣清空
-(void)removesearDidianArray{
    [self.searDidianArray removeAllObjects];
}

/**
 *  查询圈子信息
 *
 *  @param handler 成功调用
 *  @param fail    失败调用
 */
-(void)requestCircleDataWithuserName:(NSString *)userKey  Handler:(void(^)())handler Fail:(void(^)())fail{
    
    
    
    
    self.circleOldIndex = 1;
    
    AVQuery *tdFriendQuery = [AVQuery queryWithClassName:@"TdFriendObject"];
    
    // NSLog(@"----------====%@",userKey);
    [tdFriendQuery whereKey:@"userKey" equalTo:userKey];
    
    [tdFriendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *tdMuArray = [NSMutableArray array];
            for (AVObject *obj in objects) {
                [tdMuArray addObject:obj[@"tdFUserKey"]];
            }
            if (tdMuArray.count) {
                AVQuery *tdListQuary = [AVQuery queryWithClassName:@"TdListDiary"];
                [tdListQuary whereKey:@"userKey" containedIn:tdMuArray];
                [tdListQuary whereKey:@"isPublicShare" equalTo:@"YES"];
                [tdListQuary orderByDescending:@"createdAt"];
                [tdListQuary findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        
                        [self.circelArray removeAllObjects];
                        for (AVObject *tdListDiary in objects) {
                            [self.circelArray addObject:tdListDiary];
                        }
                        handler();
                    } else {
                        // 输出错误信息
                        fail();
                    }
                }];
            }else{
                
                AVQuery *tdDiaryBeifenQuery = [AVQuery queryWithClassName:@"TdDiaryBeifen"];
                tdDiaryBeifenQuery.limit = 10;
                [tdDiaryBeifenQuery orderByDescending:@"createdAt"];
                [tdDiaryBeifenQuery whereKey:@"isPublicShare" equalTo:@"YES"];
                
                [tdDiaryBeifenQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        if (objects!=nil) {
                            
                            [self.circelArray removeAllObjects];
                            for (AVObject *tdListDiary in objects) {
                                [self.circelArray addObject:tdListDiary];
                                //   NSLog(@"--------------%@",self.circelArray);
                            }
                        }
                        handler();
                    } else {
                        // 输出错误信息
                        fail();
                    }
                }];
            }
        }else{
            AVQuery *tdDiaryBeifenQuery = [AVQuery queryWithClassName:@"TdDiaryBeifen"];
            tdDiaryBeifenQuery.limit = 10;
            [tdDiaryBeifenQuery orderByDescending:@"createdAt"];
            [tdDiaryBeifenQuery whereKey:@"isPublicShare" equalTo:@"YES"];
            
            [tdDiaryBeifenQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    if (objects!=nil) {
                        
                        [self.circelArray removeAllObjects];
                        for (AVObject *tdListDiary in objects) {
                            [self.circelArray addObject:tdListDiary];
                            //   NSLog(@"--------------%@",self.circelArray);
                        }
                    }
                    handler();
                } else {
                    // 输出错误信息
                    fail();
                }
            }];
            
        }
    }];
}



-(void)requestCircleOldDataWithuserName:(NSString *)userKey  Handler:(void(^)())handler Fail:(void(^)())fail{
    
    AVQuery *tdFriendQuery = [AVQuery queryWithClassName:@"TdFriendObject"];
    
    // NSLog(@"----------====%@",userKey);
    [tdFriendQuery whereKey:@"userKey" equalTo:userKey];
    
    [tdFriendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *tdMuArray = [NSMutableArray array];
            for (AVObject *obj in objects) {
                [tdMuArray addObject:obj[@"tdFUserKey"]];
            }
            if (tdMuArray.count) {
                AVQuery *tdListQuary = [AVQuery queryWithClassName:@"TdListDiary"];
                [tdListQuary whereKey:@"userKey" containedIn:tdMuArray];
                [tdListQuary whereKey:@"isPublicShare" equalTo:@"YES"];
                [tdListQuary orderByDescending:@"createdAt"];
                tdListQuary.limit = 10;
                tdListQuary.skip = 10 * (self.circleOldIndex ++);
                [tdListQuary findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (AVObject *tdListDiary in objects) {
                            [self.circelArray addObject:tdListDiary];
                        }
                        handler();
                    } else {
                        // 输出错误信息
                        fail();
                    }
                }];
            }else{
                
                AVQuery *tdDiaryBeifenQuery = [AVQuery queryWithClassName:@"TdDiaryBeifen"];
                tdDiaryBeifenQuery.limit = 10;
                [tdDiaryBeifenQuery orderByDescending:@"createdAt"];
                [tdDiaryBeifenQuery whereKey:@"isPublicShare" equalTo:@"YES"];
                
                [tdDiaryBeifenQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        if (objects!=nil) {
                            
                            //    [self.circelArray removeAllObjects];
                            for (AVObject *tdListDiary in objects) {
                                [self.circelArray addObject:tdListDiary];
                                //   NSLog(@"--------------%@",self.circelArray);
                            }
                        }
                        handler();
                    } else {
                        // 输出错误信息
                        fail();
                    }
                }];
            }
        }else{
            AVQuery *tdDiaryBeifenQuery = [AVQuery queryWithClassName:@"TdDiaryBeifen"];
            tdDiaryBeifenQuery.limit = 10;
            [tdDiaryBeifenQuery orderByDescending:@"createdAt"];
            [tdDiaryBeifenQuery whereKey:@"isPublicShare" equalTo:@"YES"];
            
            [tdDiaryBeifenQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    if (objects!=nil) {
                        
                        //     [self.circelArray removeAllObjects];
                        for (AVObject *tdListDiary in objects) {
                            [self.circelArray addObject:tdListDiary];
                            //   NSLog(@"--------------%@",self.circelArray);
                        }
                    }
                    handler();
                } else {
                    // 输出错误信息
                    fail();
                }
            }];
            
        }
    }];
}


/**
 *  在没有好友的情况下获取数据
 *
 *  @param userKey
 *  @param handler
 *  @param fail
 */
-(void)notFriendrequestCircleDataWithuserName:(NSString *)userKey  Handler:(void(^)())handler Fail:(void(^)())fail{

    self.circleOldIndex = 1;
    
    
    
    AVQuery *tdFriendQuery = [AVQuery queryWithClassName:@"TdFriendObject"];
    
    // NSLog(@"----------====%@",userKey);
    [tdFriendQuery whereKey:@"userKey" equalTo:userKey];
    
    [tdFriendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            NSMutableArray *ttArray = [NSMutableArray array];
            for (AVObject *obj in objects) {
                [ttArray addObject:obj[@"tdFUserKey"]];
            }
 
            AVQuery *tdDiaryBeifenQuery = [AVQuery queryWithClassName:@"TdDiaryBeifen"];
            tdDiaryBeifenQuery.limit = 10;
            [tdDiaryBeifenQuery orderByDescending:@"createdAt"];
           
            [tdDiaryBeifenQuery whereKey:@"isPublicShare" equalTo:@"YES"];
            [tdDiaryBeifenQuery whereKey:@"userKey" notContainedIn:ttArray];
            [tdDiaryBeifenQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    if (objects!=nil) {
                        [self.circelArray removeAllObjects];
                        for (AVObject *tdListDiary in objects) {
                            [self.circelArray addObject:tdListDiary];
                        }
                    }
                    handler();
                    
                } else {
                    // 输出错误信息
                    fail();
                }
            }];
        }else{

            AVQuery *tdDiaryBeifenQuery = [AVQuery queryWithClassName:@"TdDiaryBeifen"];
            tdDiaryBeifenQuery.limit = 10;
            [tdDiaryBeifenQuery orderByDescending:@"createdAt"];
            
            [tdDiaryBeifenQuery whereKey:@"isPublicShare" equalTo:@"YES"];
            [tdDiaryBeifenQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    if (objects!=nil) {
                        [self.circelArray removeAllObjects];
                        for (AVObject *tdListDiary in objects) {
                            [self.circelArray addObject:tdListDiary];
                        }
                    }
                    handler();
                    
                } else {
                    // 输出错误信息
                    fail();
                }
            }];
        }
    }];

}

/**
 *  上拉加载 在没有好友的情况下
 *  @param userKey
 *  @param handler
 *  @param fail
 */
-(void)notFriendrequestCircleOldDataWithuserName:(NSString *)userKey  Handler:(void(^)())handler Fail:(void(^)())fail{


  
    
    AVQuery *tdFriendQuery = [AVQuery queryWithClassName:@"TdFriendObject"];
    
    // NSLog(@"----------====%@",userKey);
    [tdFriendQuery whereKey:@"userKey" equalTo:userKey];
    
    [tdFriendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
    
            
            
            NSMutableArray *ttArray = [NSMutableArray array];
            for (AVObject *obj in objects) {
                [ttArray addObject:obj[@"tdFUserKey"]];
            }
            
            
    AVQuery *tdDiaryBeifenQuery = [AVQuery queryWithClassName:@"TdDiaryBeifen"];
    tdDiaryBeifenQuery.limit = 10;
    
    tdDiaryBeifenQuery.skip= 10 * (self.circleOldIndex ++);
    [tdDiaryBeifenQuery orderByDescending:@"createdAt"];
    [tdDiaryBeifenQuery whereKey:@"userKey" notContainedIn:ttArray];
    [tdDiaryBeifenQuery whereKey:@"isPublicShare" equalTo:@"YES"];
    
    [tdDiaryBeifenQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects!=nil) {

                for (AVObject *tdListDiary in objects) {
                    [self.circelArray addObject:tdListDiary];
 
                }
            }
            handler();
            
        } else {
            // 输出错误信息
            fail();
        }
    }];
            
        }else{
        
            
            AVQuery *tdDiaryBeifenQuery = [AVQuery queryWithClassName:@"TdDiaryBeifen"];
            tdDiaryBeifenQuery.limit = 10;
            
            tdDiaryBeifenQuery.skip= 10 * (self.circleOldIndex ++);
            [tdDiaryBeifenQuery orderByDescending:@"createdAt"];
            [tdDiaryBeifenQuery whereKey:@"isPublicShare" equalTo:@"YES"];
            
            [tdDiaryBeifenQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    if (objects!=nil) {
                        
                        for (AVObject *tdListDiary in objects) {
                            [self.circelArray addObject:tdListDiary];
                            
                        }
                    }
                    handler();
                    
                } else {
                    // 输出错误信息
                    fail();
                }
            }];
        }
    }];
}




-(void)searchRequestCircleDataWithuserKey:(NSString *)userKey  useName:(NSString *)nikeName Handler:(void(^)())handler Fail:(void(^)())fail{
    
    
    AVQuery *tdFriendQuery = [AVQuery queryWithClassName:@"TdFriendObject"];
    
    // NSLog(@"----------====%@",userKey);
    [tdFriendQuery whereKey:@"userKey" equalTo:userKey];
    
    [tdFriendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
                if (!error) {
        
        
        
                    NSMutableArray *ttArray = [NSMutableArray array];
                    for (AVObject *obj in objects) {
                        [ttArray addObject:obj[@"tdFUserKey"]];
                    }
                    
                    
                    AVQuery *tdUserObjectQuery = [AVQuery queryWithClassName:@"LvjiUserObject"];
                    [tdUserObjectQuery whereKey:@"nickname" equalTo:nikeName];
                    [tdUserObjectQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        
                        if (!error) {
                            NSMutableArray *tttArray = [NSMutableArray array];
                            
                            for (AVObject *obj in objects) {
                                [tttArray addObject:obj[@"userKey"]];
                            }
                            
                            for (NSString *text in ttArray) {
                                
                                if ([tttArray containsObject:text]) {
                                    [tttArray removeObject:text];
                                }
                                
                            }
    
                            AVQuery *tdDiaryBeifenQuery = [AVQuery queryWithClassName:@"TdDiaryBeifen"];
                            [tdDiaryBeifenQuery orderByDescending:@"createdAt"];
                            [tdDiaryBeifenQuery whereKey:@"userKey" containedIn:tttArray];
                            tdDiaryBeifenQuery.limit = 50;
                            [tdDiaryBeifenQuery whereKey:@"isPublicShare" equalTo:@"YES"];
                            [tdDiaryBeifenQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                if (!error) {
                                    if (objects!=nil) {
                                        
                                        [self.circelArray removeAllObjects];
                                        for (AVObject *tdListDiary in objects) {
                                            [self.circelArray addObject:tdListDiary];
                                        }
                                        if (self.circelArray.count != 0) {
                                            handler();
                                        }else{
                                            
                                            fail();
                                        }
                                    }else{
                                        
                                        fail();
                                    }
                                } else {
                                    // 输出错误信息
                                    fail();
                                }
                            }];
                            
                        }else{
                            fail();
                        }
                    }];
                }else{
                }
    }];
}
/**
 *  获取圈子内容数量
 *
 *  @return
 */
-(NSInteger)getCircleCount{
    return  self.circelArray.count;
}
/**
 *  根据参数获取响应的内容
 *  @param index
 *  @return
 */
-(AVObject *)getTdCircelDataWithIndex:(NSInteger)indexs{
    return [self.circelArray objectAtIndex:indexs];
}
/**
 *  根据用户名去获取用户的具体信息
 *
 *  @param userKey 这里的userName 并不是用户名，而是用户表中存在的唯一标识
 *  @param handler  成功
 *  @param fail     失败
 */
-(void)getUserWithusername:(NSString *)userKey Handler:(void(^)(AVObject *object))handler Fail:(void(^)())fail{
    AVQuery *userQuery =[AVQuery queryWithClassName:@"LvjiUserObject"];
    
    [userQuery whereKey:@"userKey" equalTo:userKey];//userKey];
    [userQuery getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!object) {
            //  NSLog(@"getFirstObject 请求失败。");
            fail();
        } else {
            // 查询成功
            //   NSLog(@"对象成功返回。")
            handler(object);
        }
    }];
}


/**
 *  请求自己所有的游记目录
 *
 *  @param userKey 自己的userKey
 *  @param handler 成功
 *  @param fail    失败
 */
-(void)requestUserTravelDiaryWithUserKey:(NSString *)userKey Handler:(void (^)())handler Fail:(void(^)())fail{

    self.tduOldDiaryIndex = 1;
    AVQuery *tdDiaryQuery = [AVQuery queryWithClassName:@"TdDiary"];
    [tdDiaryQuery whereKey:@"userKey" equalTo:userKey];
     [tdDiaryQuery orderByDescending:@"createdAt"];
    tdDiaryQuery.limit = 10;
    [tdDiaryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count != 0) {
                [self.userDiaryArray removeAllObjects];
                [self.userDiaryArray addObjectsFromArray:objects];
                handler();
            }else{
                fail();
            }
        } else {
            // 输出错误信息
           // NSLog(@"Error: %@ %@", error, [error userInfo]);
            
            fail();
        }
    }];
}

-(void)requestOldUserTravelDiaryWithUserKey:(NSString *)userKey Handler:(void (^)())handler Fail:(void(^)())fail{

    AVQuery *tdDiaryQuery = [AVQuery queryWithClassName:@"TdDiary"];
    [tdDiaryQuery whereKey:@"userKey" equalTo:userKey];
    [tdDiaryQuery orderByDescending:@"createdAt"];
    tdDiaryQuery.limit = 10;
    tdDiaryQuery.skip = 10 * (self.tduOldDiaryIndex ++ );
    [tdDiaryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count != 0) {
                
                [self.userDiaryArray addObjectsFromArray:objects];
                handler();
            }else{
                fail();
            }
        } else {
            // 输出错误信息
            // NSLog(@"Error: %@ %@", error, [error userInfo]);
            
            fail();
        }
    }];
}

-(NSInteger)getuserDiaryArrayCount{
    return self.userDiaryArray.count;
}
-(AVObject *)getTDDiaryWithIndex:(NSInteger)index{
    AVObject *tdDiary = self.userDiaryArray[index];
    return  tdDiary;
}




/**
 *  根据 游记总目去查找具体的游记
 *
 *  @param tdDiary 总游记目录
 *  @param handler 成功
 *  @param fail    失败
 */
-(void)requestTDListDiaryWithTdDiary:(AVObject *)tdDiary Handler:(void (^)())handler Fail:(void(^)())fail{

    self. tdListOldDiaryIndex = 1;
    AVQuery *tdListDiaryQuery = [AVQuery queryWithClassName:@"TdListDiary"];
    [tdListDiaryQuery whereKey:@"tdDiary" equalTo:tdDiary];
    tdListDiaryQuery.limit = 10;
    
    [tdListDiaryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            // 检索成功
            if (objects) {
                [self.tdListDiaryArray removeAllObjects];
                [self.tdListDiaryArray addObjectsFromArray:objects];
                handler();
            }else{
                fail();
            }
        } else {
            // 输出错误信息
            fail();
        }
    }];
    
    


}

/**
 *  加载后面
 *
 *  @param tdDiary 总游记目录
 *  @param handler 成功
 *  @param fail    失败
 */
-(void)requestOldTDListDiaryWithTdDiary:(AVObject *)tdDiary Handler:(void (^)())handler Fail:(void(^)())fail{


    AVQuery *tdListDiaryQuery = [AVQuery queryWithClassName:@"TdListDiary"];
    [tdListDiaryQuery whereKey:@"tdDiary" equalTo:tdDiary];
    tdListDiaryQuery.limit = 10;
    tdListDiaryQuery.skip = 10 * (self.tdListOldDiaryIndex ++);
    [tdListDiaryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            if (objects) {
                [self.tdListDiaryArray addObjectsFromArray:objects];
                handler();
            }else{
                fail();
            }
        } else {
            // 输出错误信息
            fail();
        }
    }];

}

-(NSInteger)getTdListDiaryArrayCount{
    return self.tdListDiaryArray.count;
}

-(AVObject *)getTdListDiaryWithIndex:(NSInteger )index{
    return  self.tdListDiaryArray[index];

}




-(void)deleteListDiaryWithObject:(AVObject *)tdDiary Index:(NSInteger)index Handler:(void(^)())handler Fail:(void(^)())fail{


    AVQuery *tdListDiaryQuery = [AVQuery queryWithClassName:@"TdListDiary"];
    [tdListDiaryQuery whereKey:@"tdDiary" equalTo:tdDiary];
    [tdListDiaryQuery orderByDescending:@"createdAt"];
    [tdListDiaryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            if (objects.count != 0) {
                
                [objects[index] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if(!error){
                        [self.tdListDiaryArray removeObjectAtIndex:index];
                        handler();
                    }
                }];
            }else{
            
                fail();
            }
        } else {
            // 输出错误信息
         //   NSLog(@"Error: %@ %@", error, [error userInfo]);
            fail();
        }
    }];
}



-(void)deletetdDiaryWithObject:(AVObject *)tdDiary Index:(NSInteger)index Handler:(void (^)())handler Fail:(void (^)())fail{

    
    
    AVQuery *tdDiaryQuery = [AVQuery queryWithClassName:@"TdDiary"];
    
    [tdDiaryQuery whereKey:@"userKey" equalTo:tdDiary[@"userKey"]];
    [tdDiaryQuery orderByDescending:@"createdAt"];
    [tdDiaryQuery  findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            NSMutableArray *tdArray = [NSMutableArray arrayWithArray:objects];
            AVQuery *tdListDiaryQuery = [AVQuery queryWithClassName:@"TdListDiary"];
            [tdListDiaryQuery whereKey:@"tdDiary" equalTo:tdDiary];
            [tdListDiaryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (!error) {
                    
                    if (objects.count!= 0) {
                        
                        for (AVObject *objc in objects) {
                            [objc deleteInBackground];
                        }
                        
                        
                        [tdArray[index] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                [self.userDiaryArray removeObjectAtIndex:index];
                                handler();
                            }else{
                                fail();
                            }
                        }];
                    }else{
                    
                        [tdArray[index] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                [self.userDiaryArray removeObjectAtIndex:index];
                                handler();
                            }else{
                                fail();
                            }
                        }];
                    }
                }else{
                
                    [tdArray[index] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            [self.userDiaryArray removeObjectAtIndex:index];
                            handler();
                            
                        }else{
                            fail();
                        }
                    }];
                }
            }];
        }else{
            fail();
        
        }
    }];
    }


@end
