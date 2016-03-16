//
//  TDNearOtherController.m
//  TDTravelDiary
//
//  Created by co on 15/11/23.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDNearOtherController.h"
#import "TDNearViewCell.h"
#import "TDNearDetailController.h"
@interface TDNearOtherController ()

@end

@implementation TDNearOtherController



- (void)viewDidLoad {
    [super viewDidLoad];
  
    //self.view.backgroundColor = [UIColor blackColor];
    //self.sourceArray = [NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //    self.dataManager = [TDGetNearDataManager getDataManager];
    //    [self.dataManager getDataWithURL:[self.dataManager getAllDataURL]  handle:^(NSMutableArray *result) {
    //        self.sourceArray = result;
    //
    //    }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TDNearViewCell" bundle:nil] forCellReuseIdentifier:@"NearCell"];
    [self.tableView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    
    return self.sourceArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDNearViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearCell" forIndexPath:indexPath];
    TDGetNearModel *geNearModel = self.sourceArray[indexPath.row];
    
    

    cell.getModel = geNearModel;
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDNearDetailController *TDDC = [[TDNearDetailController alloc]init];
    NSInteger row = indexPath.row;
    TDDC.row = row;
    TDDC.sourceArray = self.sourceArray;
    //[self.navigationController pushViewController:TDDC animated:YES];
    [self presentViewController:TDDC animated:YES completion:nil];
    
    
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
