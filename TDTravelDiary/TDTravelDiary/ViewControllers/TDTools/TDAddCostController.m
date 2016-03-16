//
//  TDAddCostController.m
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDAddCostController.h"
//#import "TDCostDetailController.h"

#import "CostDetailModel.h"
#import "TDGetdataManager.h"
@interface TDAddCostController ()


@property (nonatomic,strong) TDGetdataManager *dataManager;
@end

@implementation TDAddCostController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [TDGetdataManager defaultManager];
    
   
    self.dateLable.text = [self.dataManager getCurrentTime];

    
    
    
}
- (IBAction)didClickEuroButton:(id)sender {
    CGFloat money = [self.costmoney.text floatValue];
 
    CGFloat changeMoney = money * 6.8195;
    
    self.costmoney.text = [NSString stringWithFormat:@"%.2f",changeMoney];
}
- (IBAction)didclickHanButton:(id)sender {
    CGFloat money = [self.costmoney.text floatValue];
   
    CGFloat changeMoney = money * 0.0055;
    
    self.costmoney.text = [NSString stringWithFormat:@"%.2f",changeMoney];
}
- (IBAction)didClickJapanButton:(id)sender {
    CGFloat money = [self.costmoney.text floatValue];
   
    CGFloat changeMoney = money * 0.052;
    
    self.costmoney.text = [NSString stringWithFormat:@"%.2f",changeMoney];
    
    
}
- (IBAction)didClickHKButton:(id)sender {
    CGFloat money = [self.costmoney.text floatValue];
 
    CGFloat changeMoney = money * 0.8237;
    
    self.costmoney.text = [NSString stringWithFormat:@"%.2f",changeMoney];
}
- (IBAction)didClickTBButton:(id)sender {
    CGFloat money = [self.costmoney.text floatValue];
   
    CGFloat changeMoney = money * 0.1959;
    
    self.costmoney.text = [NSString stringWithFormat:@"%.2f",changeMoney];
    
}
- (IBAction)didClickAmericaButton:(id)sender {
    CGFloat money = [self.costmoney.text floatValue];
  
    CGFloat changeMoney = money * 6.365;
    
    self.costmoney.text = [NSString stringWithFormat:@"%.2f",changeMoney];
}
- (IBAction)didClickRMBButton:(id)sender {
}
- (IBAction)didClickSaveButton:(id)sender {
    [self.dataManager insertDataWithAddType:self.addType target:self];
     
    [self dismissViewControllerAnimated:YES completion:nil];
    

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
