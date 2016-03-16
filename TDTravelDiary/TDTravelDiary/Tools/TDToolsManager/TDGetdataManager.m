//
//  TDGetdataManager.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDGetdataManager.h"
#import "TDCostDetailViewController.h"
#import "CostDetailModel.h"
#import "AppDelegate.h"
#import "Amusement.h"
#import "Shop.h"
#import "Accommodation.h"
#import "Dinning.h"
#import "Others.h"
#import "Ticket.h"
#import "Traffic.h"
#import "TDAddCostController.h"

@interface TDGetdataManager ()
@property (nonatomic,assign)CGFloat costCount;
@property (nonatomic,strong)NSMutableArray *sourceArray;

@end
@implementation TDGetdataManager
static TDGetdataManager *defalutManager = nil;
+ (TDGetdataManager *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defalutManager = [[self alloc]init];
    });
    return defalutManager;

}
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.sourceArray = [[NSMutableArray alloc]init];
        
    
    }
    return self;
}
- (NSMutableArray *)getDataWithcostType:(NSString *)costType target:(TDCostDetailViewController *)TDC
{
    if([costType isEqualToString:@"购物"])
    {
        
    
        TDC.navigationItem.title = @"购物消费";
        NSMutableArray *array = [[NSMutableArray alloc]init];
         array = [self getDataFromShopCoreData];
    
        return array;
        
    }
    else if([costType isEqualToString:@"交通"])
        
    {
      
        TDC.navigationItem.title = @"交通消费";
        NSMutableArray *array = [[NSMutableArray alloc]init];

        array =[self getDataFromTrafficCoreData];
        return array;
    }
    else if([costType isEqualToString:@"餐饮"])
        
    {
        
        TDC.navigationItem.title = @"餐饮消费";
        NSMutableArray *array = [[NSMutableArray alloc]init];

        array = [self getDataFromDiningCoreData];
        
        return array;
    }
    else if([costType isEqualToString:@"住宿"])
        
    {
//        NSLog(@"住宿");
        TDC.navigationItem.title = @"住宿消费";
        NSMutableArray *array = [[NSMutableArray alloc]init];

       array = [self getDataFromAccommodationCoreData];
        return array;
    }
    else if([costType isEqualToString:@"门票"])
        
    {
        
        TDC.navigationItem.title = @"门票消费";
        NSMutableArray *array = [[NSMutableArray alloc]init];

        array = [self getDataFromTicketCoreData];
        return array;
    }
    else if([costType isEqualToString:@"娱乐"])
        
    {
        
        TDC.navigationItem.title = @"娱乐消费";
        NSMutableArray *array = [[NSMutableArray alloc]init];

        array = [self getDataFromAmusementCoreData];
        return array;
    }
    else if([costType isEqualToString:@"其他"])
        
    {
        ;
        TDC.navigationItem.title = @"其他消费";
        NSMutableArray *array = [[NSMutableArray alloc]init];

       array = [self getDataFromOthersCoreData];
        return array;
    }
    return nil;


}

- (NSMutableArray *)getDataFromShopCoreData
{
    
    self.costCount = 0;
 
    
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    
    [self.sourceArray removeAllObjects];
    NSArray *shopArray = [[NSArray alloc]init];
    shopArray = [delegate fetchallDataFromentityName:@"Shop"];
    // NSLog(@"查询出的数据库中的购物数据：%@",shopArray);
    for (Shop *shop in shopArray) {
        
        
        CostDetailModel *costModel = [[CostDetailModel alloc]init];
        costModel.costDate = shop.costdate;
        costModel.costDetail = shop.costdetail;
        costModel.costMoney = shop.costmoney;
       
        //一个的总钱数
        costModel.allMoney = shop.shopallmoney;
        [self.sourceArray addObject:costModel];
       
}
    return self.sourceArray;

}


- (NSString *)getAllMoneyCost
{
        CGFloat shopcount = [self getCostCountWithEntityName:@"Shop"];
    
        CGFloat ticketcount = [self getCostCountWithEntityName:@"Ticket"];
        CGFloat trafficcount = [self getCostCountWithEntityName:@"Traffic"];
        CGFloat otherscount = [self getCostCountWithEntityName:@"Others"];
    CGFloat dinningcount = [self getCostCountWithEntityName:@"Dinning"];
        CGFloat amusementcount = [self getCostCountWithEntityName:@"Amusement"];
        CGFloat accommodationcount = [self getCostCountWithEntityName:@"Accommodation"];
    
    
        CGFloat allofmoney = shopcount + ticketcount + trafficcount + otherscount + dinningcount + amusementcount + accommodationcount;
     NSString *allOfMoney = [NSString stringWithFormat:@"%.2f",allofmoney];
    
    return allOfMoney;
    

}


- (CGFloat)getCostCountWithEntityName:(NSString *)entityName
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.costCount = 0;
    NSArray *fetchArray = [[NSArray alloc]init];
    
    fetchArray = [delegate fetchallDataFromentityName:entityName];
    if([entityName isEqualToString:@"Shop"])
    {
        for (Shop *shop in fetchArray) {
            self.costCount = self.costCount +[shop.costmoney floatValue];
        }
    }
    
    else if ([entityName isEqualToString:@"Dining"])
    {
        for (Dinning *dinning in fetchArray) {
            self.costCount = self.costCount +[dinning.costmoney floatValue];
        }

    }
    else if ([entityName isEqualToString:@"Traffic"])
    {
        for (Traffic *traffic in fetchArray) {
            self.costCount = self.costCount +[traffic.costmoney floatValue];
        }
        
    }
    else if ([entityName isEqualToString:@"Ticket"])
    {
        for (Ticket *ticket in fetchArray) {
            self.costCount = self.costCount +[ticket.costmoney floatValue];
        }
        
    }
    else if ([entityName isEqualToString:@"Amusement"])
    {
        for (Amusement *amusement in fetchArray) {
            self.costCount = self.costCount +[amusement.costmoney floatValue];
        }
        
    }
    else if ([entityName isEqualToString:@"Others"])
    {
        for (Others *others in fetchArray) {
            self.costCount = self.costCount +[others.costmoney floatValue];
        }
        
    }
    else if ([entityName isEqualToString:@"Accommodation"])
    {
        for (Accommodation *accommodation in fetchArray) {
            self.costCount = self.costCount +[accommodation.costmoney floatValue];
        }
        
    }
    return self.costCount;
}



- (NSMutableArray *)getDataFromTrafficCoreData
{
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.costCount = 0;
   
    [self.sourceArray removeAllObjects];
    NSArray *TrafficArray = [[NSArray alloc]init];
    TrafficArray = [delegate fetchallDataFromentityName:@"Traffic"];
    //NSLog(@"查询出的数据库中的交通数据：%@",TrafficArray);
    for (Traffic *traffic in TrafficArray) {
        CostDetailModel *costModel = [[CostDetailModel alloc]init];
        costModel.costDate = traffic.costdate;
        costModel.costDetail = traffic.costdetail;
        costModel.costMoney = traffic.costmoney;
        //一个的总钱数
        costModel.allMoney = traffic.trafficallmoney;
        //NSInteger money = [costModel.allMoney integerValue];
        [self.sourceArray addObject:costModel];
        
    
    
}
    return self.sourceArray;

}

- (NSMutableArray*)getDataFromDiningCoreData
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    self.costCount = 0;

    [self.sourceArray removeAllObjects];
    NSArray *diningArray = [[NSArray alloc]init];
    diningArray = [delegate fetchallDataFromentityName:@"Dinning"];

    for (Dinning *dinning in diningArray) {
        CostDetailModel *costModel = [[CostDetailModel alloc]init];
        costModel.costDate = dinning.costdate;
        costModel.costDetail = dinning.costdetail;
        costModel.costMoney = dinning.costmoney;

        //一个的总钱数
        costModel.allMoney = dinning.dinningallmoney;
 
        //NSInteger money = [costModel.allMoney integerValue];
        [self.sourceArray addObject:costModel];
  
        
        
}
    return self.sourceArray;
    
}
- (NSMutableArray *)getDataFromAccommodationCoreData
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.costCount = 0;
 
    [self.sourceArray removeAllObjects];
    NSArray *accommodationArray = [[NSArray alloc]init];
    accommodationArray = [delegate fetchallDataFromentityName:@"Accommodation"];
    //NSLog(@"查询出的数据库中的住宿数据：%@",accommodationArray);
    for (Accommodation *accommodation in accommodationArray) {
        CostDetailModel *costModel = [[CostDetailModel alloc]init];
        costModel.costDate = accommodation.costdate;
        costModel.costDetail = accommodation.costdetail;
        costModel.costMoney = accommodation.costmoney;
        //一个的总钱数
        costModel.allMoney = accommodation.accommodationallmoney;
        //NSInteger money = [costModel.allMoney integerValue];
        [self.sourceArray addObject:costModel];
    
}
    return self.sourceArray;

}
- (NSMutableArray*)getDataFromTicketCoreData
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.costCount = 0;
    
    [self.sourceArray removeAllObjects];
    NSArray *ticketArray = [[NSArray alloc]init];
    ticketArray = [delegate fetchallDataFromentityName:@"Ticket"];

    for (Ticket *ticket in ticketArray) {
        CostDetailModel *costModel = [[CostDetailModel alloc]init];
        costModel.costDate = ticket.costdate;
        costModel.costDetail = ticket.costdetail;
        costModel.costMoney = ticket.costmoney;
        //一个的总钱数
        costModel.allMoney = ticket.ticketallmoney;
        //NSInteger money = [costModel.allMoney integerValue];
        [self.sourceArray addObject:costModel];
        
    }
    return self.sourceArray;

}
- (NSMutableArray*)getDataFromAmusementCoreData
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.costCount = 0;

    [self.sourceArray removeAllObjects];
    NSArray *amusementArray = [[NSArray alloc]init];
    amusementArray = [delegate fetchallDataFromentityName:@"Amusement"];
  
    for (Amusement *amusement in amusementArray) {
        CostDetailModel *costModel = [[CostDetailModel alloc]init];
        costModel.costDate = amusement.costdate;
        costModel.costDetail = amusement.costdetail;
        costModel.costMoney = amusement.costmoney;
        //一个的总钱数
        costModel.allMoney = amusement.amusementallmoney;
        [self.sourceArray addObject:costModel];
        
    }
    return self.sourceArray;
}
- (NSMutableArray *)getDataFromOthersCoreData
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.costCount = 0;
    
    [self.sourceArray removeAllObjects];
    NSArray *othersArray = [[NSArray alloc]init];
    othersArray = [delegate fetchallDataFromentityName:@"Others"];

    for (Others *other in othersArray) {
        CostDetailModel *costModel = [[CostDetailModel alloc]init];
        costModel.costDate = other.costdate;
        costModel.costDetail = other.costdetail;
        costModel.costMoney = other.costmoney;
        //一个的总钱数
        costModel.allMoney = other.othersallmoney;
        [self.sourceArray addObject:costModel];
        
    }
    return self.sourceArray;
}


#pragma mark----插入数据
- (void)insertDataWithAddType:(NSString *)addType target:(TDAddCostController *)TDA
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    

    if([addType isEqualToString:@"购物"])
    {

        CGFloat lastCount = [self getCostCountWithEntityName:@"Shop"];
        
        Shop *shop = [NSEntityDescription insertNewObjectForEntityForName:@"Shop" inManagedObjectContext:delegate.managedObjectContext];
        
        shop.costmoney = TDA.costmoney.text;
   
        
        shop.costdate = TDA.dateLable.text;
        shop.costdetail = TDA.detailtextview.text;

        
        CGFloat newCount = lastCount + [shop.costmoney floatValue];
        

        
        NSString *shopallMoney = [NSString stringWithFormat:@"%f",newCount];
        shop.shopallmoney = shopallMoney;
  
        

        
    }
    else if ([addType isEqualToString:@"交通"])
    {
    
        CGFloat lastCount = [self getCostCountWithEntityName:@"Traffic"];
        
        Traffic *traffic = [NSEntityDescription insertNewObjectForEntityForName:@"Traffic" inManagedObjectContext:delegate.managedObjectContext];
        traffic.costmoney = TDA.costmoney.text;
        traffic.costdate = TDA.dateLable.text;
        traffic.costdetail = TDA.detailtextview.text;
        CGFloat newCount = lastCount + [traffic.costmoney floatValue];
        
  
        
        NSString *trafficmoney = [NSString stringWithFormat:@"%f",newCount];
        traffic.trafficallmoney = trafficmoney;

        [delegate saveContext];
        
        
    }
    else if ([addType isEqualToString:@"餐饮"])
    {

        CGFloat lastCount = [self getCostCountWithEntityName:@"Dinning"];
        Dinning *dinning = [NSEntityDescription insertNewObjectForEntityForName:@"Dinning" inManagedObjectContext:delegate.managedObjectContext];
        dinning.costmoney = TDA.costmoney.text;
        dinning.costdate = TDA.dateLable.text;
        dinning.costdetail = TDA.detailtextview.text;
        CGFloat newCount = lastCount + [dinning.costmoney floatValue];
        
   
        
        NSString *dinningallmoney = [NSString stringWithFormat:@"%f",newCount];
        dinning.dinningallmoney = dinningallmoney;

        
        [delegate saveContext];
        
        
    }
    else if ([addType isEqualToString:@"住宿"])
    {

        CGFloat lastCount = [self getCostCountWithEntityName:@"Accommodation"];
        
        Accommodation *accommodation = [NSEntityDescription insertNewObjectForEntityForName:@"Accommodation" inManagedObjectContext:delegate.managedObjectContext];
        accommodation.costmoney = TDA.costmoney.text;
        accommodation.costdate = TDA.dateLable.text;
        accommodation.costdetail = TDA.detailtextview.text;
        CGFloat newCount = lastCount + [accommodation.costmoney integerValue];
        

        
        NSString *allmoney = [NSString stringWithFormat:@"%f",newCount];
        accommodation.accommodationallmoney = allmoney;
  
        
        [delegate saveContext];
        
        
    }
    else if ([addType isEqualToString:@"门票"])
    {
      
        CGFloat lastCount = [self getCostCountWithEntityName:@"Ticket"];
        
        Ticket *ticket = [NSEntityDescription insertNewObjectForEntityForName:@"Ticket" inManagedObjectContext:delegate.managedObjectContext];
        ticket.costmoney = TDA.costmoney.text;
        ticket.costdate = TDA.dateLable.text;
        ticket.costdetail = TDA.detailtextview.text;
        [delegate saveContext];
        CGFloat newCount = lastCount + [ticket.costmoney floatValue];
        
      
        
        NSString *allmoney = [NSString stringWithFormat:@"%f",newCount];
        ticket.ticketallmoney = allmoney;

        
        
    }
    else if ([addType isEqualToString:@"娱乐"])
    {
   
        CGFloat lastCount = [self getCostCountWithEntityName:@"Amusement"];
        
        Amusement *amusement = [NSEntityDescription insertNewObjectForEntityForName:@"Amusement" inManagedObjectContext:delegate.managedObjectContext];
        amusement.costmoney = TDA.costmoney.text;
        amusement.costdate = TDA.dateLable.text;
        amusement.costdetail = TDA.detailtextview.text;
        [delegate saveContext];
        CGFloat newCount = lastCount + [amusement.costmoney floatValue];
        

        
        NSString *allmoney = [NSString stringWithFormat:@"%f",newCount];
        amusement.amusementallmoney = allmoney;
  
        
    }
    else if ([addType isEqualToString:@"其他"])
    {
    
        CGFloat lastCount = [self getCostCountWithEntityName:@"Others"];
        
        
        Others *others = [NSEntityDescription insertNewObjectForEntityForName:@"Others" inManagedObjectContext:delegate.managedObjectContext];
        others.costmoney = TDA.costmoney.text;
        others.costdate = TDA.dateLable.text;
        others.costdetail = TDA.detailtextview.text;
        [delegate saveContext];
        
        CGFloat newCount = lastCount + [others.costmoney integerValue];
        

        NSString *allmoney = [NSString stringWithFormat:@"%f",newCount];
        others.othersallmoney = allmoney;

    }


}
#pragma mark----获取当前时间
- (NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
//    NSLog(@"ttttttttttttttttttt%@",dateTime);
    NSString *time = [dateTime substringToIndex:10];

    return time;
}


@end
