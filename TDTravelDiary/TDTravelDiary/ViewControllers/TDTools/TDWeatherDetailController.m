//
//  TDWeatherDetailController.m
//  TDTravelDiary
//
//  Created by co on 15/11/20.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDWeatherDetailController.h"
#import "TDWeatherModel.h"
@interface TDWeatherDetailController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *searchView;
@property (nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic,strong) NSString *httpUrl;
@property (weak, nonatomic) IBOutlet UILabel *mintmpLable;
@property (weak, nonatomic) IBOutlet UILabel *maxtmpLable;
@property (weak, nonatomic) IBOutlet UILabel *txtLable;
@property (weak, nonatomic) IBOutlet UILabel *localtimeLable;
@property (weak, nonatomic) IBOutlet UILabel *cityLable;

@property (nonatomic,strong) UIActivityIndicatorView *indicatorview;

@end

@implementation TDWeatherDetailController
- (IBAction)didClickBackbutton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入城市名称进行查询";
    [self.searchBar setKeyboardType:UIKeyboardTypeDefault];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"weatherback3"]];
    
    self.sourceArray = [NSMutableArray array];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBarbutton:)];
    
    
     self.httpUrl = @"http://apis.baidu.com/heweather/weather/free";
    NSString *httpArg = @"city=beijing";
    [self request: self.httpUrl withHttpArg: httpArg];
    
    self.indicatorview = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.indicatorview.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.indicatorview setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    self.indicatorview.backgroundColor = [UIColor grayColor];
    self.indicatorview.alpha = 0.5;
    self.indicatorview.layer.cornerRadius = 6;
    self.indicatorview.layer.masksToBounds = YES;
    [self.view addSubview:self.indicatorview];
    //开始动画
    
    self.searchView = [[UIButton alloc]initWithFrame:CGRectMake(0,64, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.searchView setBackgroundColor:[UIColor blackColor]];
    
    self.searchView.alpha = 0.0f;
    [self.searchView addTarget:self action:@selector(ClickControlAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.searchView];
    
}
- (void)didClickLeftBarbutton:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    

}
- (void)ClickControlAction:(UIButton *)button
{
    [self controlAccessoryView:0];
}
- (void)controlAccessoryView:(float)alphaValue
{
[UIView animateWithDuration:0.2 animations:^{
    
    [self.searchView setAlpha:alphaValue];
    
    
} completion:^(BOOL finished) {
    if(alphaValue <= 0)
    {
        [self.searchBar resignFirstResponder];
        [self.searchBar setShowsCancelButton:NO animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
}];
    

}
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @" ed333cd8c92ae71a06c673e60c8ca205" forHTTPHeaderField: @"apikey"];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   [self.indicatorview startAnimating];

                                   NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                   NSArray *array1 = jsonDic[@"HeWeather data service 3.0"];
                                   
                                   NSDictionary *Dic = [array1 firstObject];
                                   NSDictionary *Dic2 = Dic[@"basic"];
                                   NSDictionary *dic2 = Dic2[@"update"];
                                   
                                   TDWeatherModel *weatherModel = [[TDWeatherModel alloc]init];
                                   [weatherModel setValuesForKeysWithDictionary:Dic2];
                                   [weatherModel setValuesForKeysWithDictionary:dic2];
                                   NSDictionary *Dic3 = Dic[@"now"];
                                   [weatherModel setValuesForKeysWithDictionary:Dic3];
                                   NSDictionary *Dic4 = Dic3[@"cond"];
                                   [weatherModel setValuesForKeysWithDictionary:Dic4];
                                   NSArray *array5 = Dic[@"daily_forecast"];
                                   NSDictionary *Dic5 = [NSDictionary dictionary];
                                   for (NSDictionary *dic in array5) {
                                       Dic5 = dic[@"tmp"];
                                       
                                   }
                                   [weatherModel setValuesForKeysWithDictionary:Dic5];
                                   
                                   [self.sourceArray addObject:weatherModel];
                                  
                                   
                                   self.mintmpLable.text = weatherModel.min;
                                   self.maxtmpLable.text = weatherModel.max;
                                   self.localtimeLable.text = weatherModel.loc;
                                   self.txtLable.text = weatherModel.txt;
                                   self.cityLable.text = weatherModel.city;
                                   self.txtLable.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
                                   self.cityLable.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
                                   //结束动画
                                   [self.indicatorview stopAnimating];
                               }
                           }];
}

#pragma mark----delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self controlAccessoryView:0.3];// 显示遮盖层。
    return YES;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    //数据是nil
    self.searchBar.text = nil;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self controlAccessoryView:0];// 隐藏遮盖层。
    

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
 
    [self.searchBar resignFirstResponder];// 放弃第一响应者
    [self request:self.httpUrl withHttpArg:[@"city=" stringByAppendingString:searchBar.text]];
    self.searchBar.text = nil;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self controlAccessoryView:0];// 隐藏遮盖层。

}
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
//    NSLog(@"textDidChange---%@",searchBar.text);
//    [self request:self.httpUrl withHttpArg:[@"city=" stringByAppendingString:searchBar.text]];
//    
//    [self controlAccessoryView:0];// 隐藏遮盖层。
//    
//}

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
