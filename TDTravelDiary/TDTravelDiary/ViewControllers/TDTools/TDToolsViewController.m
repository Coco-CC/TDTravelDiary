//
//  TDToolsViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDToolsViewController.h"
#import "TDAccountBookViewController.h"
#import "TDWeatherDetailController.h"
@interface TDToolsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *weatherButton;
@property (weak, nonatomic) IBOutlet UIButton *accountbookButton;

@end

@implementation TDToolsViewController
- (IBAction)didClickWeatherButton:(id)sender {
    TDWeatherDetailController *TDDC = [[TDWeatherDetailController alloc]initWithNibName:@"TDWeatherDetailController" bundle:nil];
    
    [self presentViewController:TDDC animated:YES completion:nil];
    
}
- (IBAction)didClickAccountBookButton:(id)sender {
  
    

    TDAccountBookViewController *accountbookVC = [[TDAccountBookViewController alloc]init];
    
    
    [self.navigationController pushViewController:accountbookVC animated:YES];
    

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftButton:)];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)didClickLeftButton:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    

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
