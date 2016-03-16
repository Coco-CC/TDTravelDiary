//
//  TDFeedbackinformationViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/30.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDFeedbackinformationViewController.h"

@interface TDFeedbackinformationViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)UILabel *placeHolderLabel;

@end

@implementation TDFeedbackinformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"信息反馈";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.textView.frame.size.width, 30)];
    self.placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15];
    self.placeHolderLabel.backgroundColor = [UIColor clearColor];
    self.placeHolderLabel.alpha = 0;
    self.placeHolderLabel.tag = 999;
    self.placeHolderLabel.text = @"请输入你的宝贵的意见...";
    [self.textView addSubview:self.placeHolderLabel];
    if ([[self.textView text] length]==0) {
        [[self.textView viewWithTag:999] setAlpha:1];
    }
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
}

-(void)didClickBackButtonItem:(UIBarButtonItem *)button{

    [self.navigationController popViewControllerAnimated:YES];
}


-(void)textChanged:(NSNotification *)notification{

    if ([[self.textView text]length] == 0) {
        [[self.textView viewWithTag:999] setAlpha:1];
    }
    else{
    
        [[self.textView viewWithTag:999] setAlpha:0];
    }

}

- (IBAction)clickButtonPop:(id)sender {
    
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
