//
//  TDCostDetailViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDCostDetailViewController.h"
#import "CostDetailModel.h"
#import "TDAddCostController.h"
#import "TDCostDetailCell.h"

#import "TDGetdataManager.h"

@interface TDCostDetailViewController ()
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong)TDGetdataManager *dataManager;

@end

@implementation TDCostDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //!!!!!
    self.sourceArray = [self.dataManager getDataWithcostType:self.costType target:self];

    //self.sourceArray = [[NSMutableArray alloc]init];
    

    
    [self.tableView reloadData];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceArray = [NSMutableArray array];
    self.dataManager = [TDGetdataManager defaultManager];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightBarbutton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBarbutton:)];


    [self.tableView registerClass:[TDCostDetailCell class] forCellReuseIdentifier:@"cell"];
    
}
- (void)didClickLeftBarbutton:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
//    if([self.sentdelegate respondsToSelector:@selector(sendAllofMoneyToAccountBook:)])
//    {
//        [self.sentdelegate sendAllofMoneyToAccountBook:self.allOfMoney];
//        
//    }
    
}
- (void)didClickRightBarbutton:(UIBarButtonItem *)barbutton
{
    TDAddCostController *TDaddCC = [[TDAddCostController alloc]initWithNibName:@"TDAddCostController" bundle:nil];
    // TDaddCC.addType = [self getAddType];
    
    TDaddCC.addType = self.costType;
    
    [self presentViewController:TDaddCC animated:YES completion:nil];
    
    // [self.navigationController pushViewController:TDaddCC animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDCostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CostDetailModel *detailModel = self.sourceArray[indexPath.row];

    cell.costModel = detailModel;
    
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
