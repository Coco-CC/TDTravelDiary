//
//  TDNearViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/21.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDNearViewController.h"
#import "URL.h"
#import "TDFindManager.h"
#import "UIImageView+WebCache.h"
#import "TDNetWorkingTools.h"
#import "TDFindModel.h"
#import "MBProgressHUD.h"

#define TopHeight 370
#define LJ null
@interface TDNearViewController ()<NSXMLParserDelegate>
@property(nonatomic,strong)UIScrollView *nearScrollView;
@property(nonatomic,strong)UIImageView *nearImageView;
@property(nonatomic,strong)UILabel *describeLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)NSMutableArray *strongArr;
@end

@implementation TDNearViewController
- (void)viewDidLoad {
    
    self.strongArr = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
    self.nearScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
   
    [self.view addSubview:self.nearScrollView];
    //
    self.nearImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260)];
       [self.nearScrollView addSubview:self.nearImageView];
    //
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, SCREEN_WIDTH, 40)];
    
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:20];
    [self.nearImageView addSubview:self.nameLabel];
    //
    self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 260, SCREEN_WIDTH-20, 60)];
    self.describeLabel.numberOfLines = 0;
    //
    self.titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 320, SCREEN_WIDTH, 30)];
    self.titleLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
    self.titleLabel.text = @"实用小贴士";
    self.titleLabel.layer.cornerRadius = 10;
    [self.nearScrollView addSubview:self.describeLabel];
    [self.nearScrollView addSubview:self.titleLabel];
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.numberOfLines = 0;
    [self.nearScrollView addSubview:self.contentLabel];
    NSString *urlString =[NSString stringWithFormat:@"http://chanyouji.com/api/attractions/%@.json",self.planModel.entry_id];
    //
//    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    
    [TDNetWorkingTools jsonDataWithUrl:urlString succes:^(id json) {
        if (!json) {
            return ;
        }
        [self.nearImageView sd_setImageWithURL:[NSURL URLWithString:json[@"image_url"]]];
        self.nameLabel.text = json[@"name_zh_cn"];
    self.describeLabel.text = json[@"description"];
        Class null = [NSNull class];
        if ([json[@"tips_html"] isKindOfClass:null]) {
             self.contentLabel.frame =CGRectMake(10, 370, SCREEN_WIDTH,30);
            self.contentLabel.text =@"这个地方还没有更新旅游信息";
            return;
        }else{
            NSArray *array = [json[@"tips_html"] componentsSeparatedByString:@"</strong>"];
            for (NSString *string in array) {
                NSString *returnStr = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
                NSString *twoStr = [returnStr stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
                NSString *threeStr = [twoStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                NSString *strongStr = [threeStr stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
                
                [self.strongArr addObject:strongStr];
                NSString *ns = [self.strongArr componentsJoinedByString:@","];
                //定义lable的高度
                CGRect frame1 = [ns boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
                self.contentLabel.frame =CGRectMake(10, 370, frame1.size.width, frame1.size.height);
                CGFloat height = TopHeight +frame1.size.height +10;
                if (height < SCREEN_HEIGHT) {
                    height = SCREEN_HEIGHT;
                }
                //设置可滑动的范围
                self.nearScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
                self.contentLabel.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1] CGColor];
                self.contentLabel.layer.borderWidth = 1;
                self.contentLabel.textColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
                self.contentLabel.text =ns;

            }
                   }
//        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
                   } fail:^{
//               [[TDFindManager defaultManager] showOkayCancelAlert:self titleString:@"警告" messageString:@"查看你的网络"];
    }];
    // Do any additional setup after loading the view from its nib.
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
