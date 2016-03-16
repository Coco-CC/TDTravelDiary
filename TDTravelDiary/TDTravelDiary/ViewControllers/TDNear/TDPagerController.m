//
//  TDPagerController.m
//  TDTravelDiary
//
//  Created by co on 15/11/24.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDPagerController.h"
#import "TDNearAllController.h"
#import "TDNearOtherController.h"
#import "TDGetNearDataManager.h"
@interface TDPagerController ()<ViewPagerDataSource,ViewPagerDelegate>
@property (nonatomic,assign) NSUInteger numberOfTabs;

@property (nonatomic,strong) TDGetNearDataManager *dataManager;

@property (nonatomic,strong) TDNearAllController *nearallVC;
@property (nonatomic,strong) TDNearAllController *nearallVC2;
@property (nonatomic,strong) TDNearAllController *nearallVC3;

@property (nonatomic,strong) TDNearOtherController *otherVC;
@property (nonatomic,strong) TDNearOtherController *otherVC2;
@property (nonatomic,strong) TDNearOtherController *otherVC3;




@end

@implementation TDPagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
    self.dataSource = self;
    self.delegate = self;
    self.title = @"附近";
    self.dataManager = [TDGetNearDataManager getDataManager];
    
    self.nearallVC = [TDNearAllController new];
    
    self.nearallVC2 = [TDNearAllController new];

    self.nearallVC3 = [TDNearAllController new];

    self.otherVC = [TDNearOtherController new];
    self.otherVC2 = [TDNearOtherController new];

    self.otherVC3 = [TDNearOtherController new];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBarbutton:)];
    


   
    
    // Do any additional setup after loading the view.
}
- (void)didClickLeftBarbutton:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}

#pragma mark - Helpers
- (void)selectTabWithNumberFive {
    [self selectTabAtIndex:5];
}
- (void)loadContent {
    self.numberOfTabs = 6;
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0];
    //label.text = [NSString stringWithFormat:@"Tab #%lu", (unsigned long)index];

    switch (index) {
        case 0:
            label.text = @"全部";
            break;
        case 1:
            label.text = @"景点";
            break;
        case 2:
            label.text = @"住宿";
            break;
        case 3:
            label.text = @"餐厅";
            break;
        case 4:
            label.text = @"娱乐";
            break;
        case 5:
            label.text = @"购物";
            break;
            
        default:
            break;
    }

    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    //在这里给每一个VC添加数据
    
//    TDNearAllController *nearallVC =[[TDNearAllController alloc]init];
//    TDNearOtherController *otherVC = [[TDNearOtherController alloc]init];
//    
    
    switch (index) {
        case 0:
        {
           [self.dataManager getDataWithURL:[self.dataManager getAllDataURL] handle:^(NSMutableArray *result) {
               self.nearallVC.sourceArray = [NSMutableArray new];

               if (self.nearallVC.sourceArray == result) {

               }else{
                   
                    self.nearallVC.sourceArray = result;
               
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self.nearallVC.tableView reloadData];
                    
                       
                   });
                   


               }
            
               
           }];
            
            return self.nearallVC;
        }
            break;
            
            case 1:
        {
            [self.dataManager getDataWithURL:[self.dataManager getSpotDataURL] handle:^(NSMutableArray *result) {

                self.otherVC.sourceArray = [NSMutableArray new];

                
                if (self.otherVC.sourceArray == result) {
                    
                }else{
                    

                    self.otherVC.sourceArray = result;
            

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.otherVC.tableView reloadData];

                    });
                    
                }

                
                
            }];
            
            return self.otherVC;
        }
            break;

            case 2:
        {
            [self.dataManager getDataWithURL:[self.dataManager getAccomdationDataURL] handle:^(NSMutableArray *result) {
                self.nearallVC2.sourceArray = [NSMutableArray new];
                
                if (self.nearallVC2.sourceArray == result) {
                    
       
                    
                }else{

                    self.nearallVC2.sourceArray = result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.nearallVC2.tableView reloadData];

                    });
                    
                }
                
                
            }];
            
            return self.nearallVC2;
        }
            break;

            case 3:
        {
            [self.dataManager getDataWithURL:[self.dataManager getHallDataURL] handle:^(NSMutableArray *result) {

                self.otherVC2.sourceArray = [NSMutableArray new];

                
                if (self.otherVC2.sourceArray == result) {
                    
                }else{

                    self.otherVC2.sourceArray = result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.otherVC2.tableView reloadData];

                    });
                    
                }
                
                
            }];
            
            return self.otherVC2;
        }
            break;
        case 4:
        {
            [self.dataManager getDataWithURL:[self.dataManager getAmusementDataURL] handle:^(NSMutableArray *result) {
                self.nearallVC3.sourceArray = [NSMutableArray new];

                
                if (self.nearallVC3.sourceArray == result) {
                    
                }else{

                    self.nearallVC3.sourceArray = result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.nearallVC3.tableView reloadData];

                    });
                    
                }
                
                
            }];
            
            return self.nearallVC3;
        }
            break;
            case 5:
        {

            [self.dataManager getDataWithURL:[self.dataManager getShopDataURL] handle:^(NSMutableArray *result) {

                self.otherVC3.sourceArray = [NSMutableArray new];


                
                if (self.otherVC3.sourceArray == result) {
                    
                }else{

                   self.otherVC3.sourceArray = result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.otherVC3.tableView reloadData];

                    });
                    
                }
                
                
            }];
            
            return self.otherVC3;
        }
            break;
            
            
        default:
            return nil;
    }
    
    
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 49.0;
        case ViewPagerOptionTabOffset:
            return 36.0;
       // case ViewPagerOptionTabWidth:
           // return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0 : 125;
            //        case ViewPagerOptionFixFormerTabsPositions:
            //            return 0.0;
            //        case ViewPagerOptionFixLatterTabsPositions:
            //            return 0.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
        case ViewPagerTabsView:
            return [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
        case ViewPagerContent:
            return [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
        default:
            return color;
    }
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
