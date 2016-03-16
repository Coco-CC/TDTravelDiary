//
//  TDAccountBookViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDAccountBookViewController.h"
#import "TDAccountBookCell.h"
#import "CostDetailModel.h"
#import "TDCostDetailViewController.h"
#import "AppDelegate.h"
#import "Shop.h"
#import "TDGetdataManager.h"
@interface TDAccountBookViewController ()<UITableViewDataSource,UITableViewDelegate>
//用来存储总账的内容（第一个分区）
@property (nonatomic,strong) NSMutableArray *ledgerArray;
//用来存储消费明细的内容（第二个分区）
@property (nonatomic,strong) NSMutableArray *consumerdetailArray;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UILabel *typeLable;
@property (nonatomic,strong) UILabel *costcountLable;
@property (nonatomic,strong) UILabel *rmbLable;
@property (nonatomic,strong) NSString *costcount;
@property (nonatomic,strong) NSMutableDictionary *costDic;
@property (nonatomic,strong) NSMutableArray *costArray;

@property (nonatomic,strong) NSArray *imageArray;


@property (nonatomic,strong) CostDetailModel *costModel;
@property (nonatomic,assign) NSInteger costCount;

@property (nonatomic,strong) TDGetdataManager *dataManager;
@end

@implementation TDAccountBookViewController



- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
   self.costcount = [self.dataManager getAllMoneyCost];

    
    
    self.costArray = [NSMutableArray arrayWithObjects:self.costcount, nil];
    NSMutableArray *costDetail = [NSMutableArray arrayWithObjects:@"购物",@"交通",@"餐饮",@"住宿",@"门票",@"娱乐",@"其他", nil];
    NSMutableArray *clearArray = [NSMutableArray arrayWithObjects:@"清空", nil];
    self.costDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:costDetail,@"消费详情",self.costArray,@"消费金额",clearArray,@"清空记录" ,nil];
    self.imageArray = @[@"gouwu",@"jiaotong",@"canyin",@"zhusu",@"menpiao",@"yule",@"qita"];
    
    [self.tableview reloadData];
    
 

}
- (void)sendAllofMoneyToAccountBook:(NSString *)allofMoney
{
    self.costcount = allofMoney;



}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataManager = [TDGetdataManager defaultManager];
    self.costcount = [self.dataManager getAllMoneyCost];

    
    self.costArray = [NSMutableArray arrayWithObjects:self.costcount, nil];
    self.navigationItem.title = @"我的账簿";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBarbutton:)];
    
    
    
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.tableview registerClass:[TDAccountBookCell class] forCellReuseIdentifier:@"cell"];
    
    
    
}



- (void)didClickLeftBarbutton:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    

}

#pragma mark --- delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        TDCostDetailViewController *TDcostDC = [[TDCostDetailViewController alloc]init];
        //TDcostDC.sentdelegate = self;
        if(indexPath.row == 0)
        {
       
        TDcostDC.costType = @"购物";

        }
        else if(indexPath.row == 1)
        {
           TDcostDC.costType = @"交通";
        }
        else if (indexPath.row == 2)
        {
        TDcostDC.costType = @"餐饮";
        }
        else if (indexPath.row == 3)
        {
            TDcostDC.costType = @"住宿";
        }
        else if (indexPath.row == 4)
        {
            TDcostDC.costType = @"门票";
        }
        else if (indexPath.row == 5)
        {
            TDcostDC.costType = @"娱乐";
        }
        else if (indexPath.row == 6)
        {
            TDcostDC.costType = @"其他";
        }
        [self.navigationController pushViewController:TDcostDC animated:YES];

    }
    else if(indexPath.section == 2)
    {
        //TDCostDetailController *TDcostDC = [[TDCostDetailController alloc]init];
       // TDcostDC.costType = @"清空";
        //调取数据库清空数据
        UIAlertController *alertc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要清除全部消费记录吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            
            [delegate removeDataWithEntityName:@"Shop"];
            [delegate removeDataWithEntityName:@"Amusement"];
            [delegate removeDataWithEntityName:@"Accommodation"];
            [delegate removeDataWithEntityName:@"Dinning"];
            [delegate removeDataWithEntityName:@"Others"];
            [delegate removeDataWithEntityName:@"Ticket"];
            [delegate removeDataWithEntityName:@"Traffic"];
            
         
            self.costcount = @"0";
            [self.tableview reloadData];
            

        }];
        
        [alertc addAction:action1];
        [alertc addAction:action2];
        
        [self presentViewController:alertc animated:YES completion:nil];

    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.costDic[@"消费金额"] count];
            break;
        case 1:
            return [self.costDic[@"消费详情"]count];
            break;
            
        case 2:
            return [self.costDic[@"清空记录"]count];
            break;
            
        default:
            break;
    }
    return 0;
    
//    NSString *key = self.costDic.allKeys[section];
//    return [self.costDic[key] count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"cell";
    
    TDAccountBookCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[TDAccountBookCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
   // NSArray *costArray = self.costDic.allValues[indexPath.section];
    //NSArray *array1 = self.costDic[@"消费金额"];
    NSArray *array2 = self.costDic[@"消费详情"];
    NSArray *array3 = self.costDic[@"清空记录"];

    switch (indexPath.section) {
        case 0:
            
                
            cell.textLabel.text = [self.costcount stringByAppendingString:@" RMB"];
            cell.imageView.image = [UIImage imageNamed:@"zongjine"];
            
            break;
            case 1:
            cell.textLabel.text = array2[indexPath.row];
            
            cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //cell.detailTextLabel.text = @"100";
            //cell.detailTextLabel.text = @"111";
            
            
            break;
            case 2:
            cell.textLabel.text = array3[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"qingkong"];
            //cell.textLabel.text = @"清空消费记录";
            break;
        default:
            break;
    }
   // cell.textLabel.text = costArray[indexPath.row];
    
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"消费金额";
            break;
            case 1:
            return @"消费详情";
            break;
            case 2:
            return @"清空记录";
            break;
        default:
            break;
    }
    //return self.costDic.allKeys[section];
    return nil;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
