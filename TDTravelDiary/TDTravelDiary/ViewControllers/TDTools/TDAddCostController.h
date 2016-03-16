//
//  TDAddCostController.h
//  TDTravelDiary
//
//  Created by co on 15/11/18.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "ViewController.h"

@interface TDAddCostController : ViewController
@property(nonatomic,strong)NSString *addType;
@property (weak, nonatomic) IBOutlet UITextField *costmoney;
@property (weak, nonatomic) IBOutlet UITextView *detailtextview;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (nonatomic,assign) NSInteger costCount;
@end
