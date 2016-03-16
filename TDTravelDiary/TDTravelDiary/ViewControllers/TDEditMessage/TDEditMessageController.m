//
//  TDEditMessageController.m
//  TDTravelDiary
//
//  Created by co on 15/11/17.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDEditMessageController.h"
#import "TDSendMessageController.h"
#import "URL.h"

#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
#import "TDCreaterTDViewController.h"
#import "TDPrivateMsgController.h"
@import CoreLocation;// 关于定位的系统框架


@interface TDEditMessageController ()<CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

//实现定位的管理类
@property (nonatomic,strong)  CLLocationManager *locationManage;

@property (weak, nonatomic) IBOutlet UITextView *editMsgTextView;
@property (weak, nonatomic) IBOutlet UIView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *backImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *BackImage;
@property (weak, nonatomic) IBOutlet UIButton *cancelImageButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *yinsiView;
@property (nonatomic,assign) CGSize imageSize;
@property (weak, nonatomic) IBOutlet UILabel *pleaseLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendMsgButton;

@property (nonatomic,assign,getter=isHasImage) BOOL isHasImage;
@property (nonatomic,assign,getter=isMsgPrivate) BOOL  isMsgPrivate;

@property (nonatomic,strong) AVObject *tdDiary;
@property (nonatomic,strong) TDCreaterTDViewController *createTDVC; //创建游记页面

@property (nonatomic,assign,getter=isPublicShare) BOOL isPublicShare; //是否分享
@property (nonatomic,assign,getter=isAddress) BOOL isAddress;// 是否公开位置信息
@property (nonatomic,strong) AVObject *tdPublicShares;
@property (nonatomic,strong) AVUser *currentUser;
@property (nonatomic,strong) AVObject *tdDiaryBeifen;

@end
@implementation TDEditMessageController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"游迹编辑";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};//[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    
    self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
    //将textView 中的文本从头开始显示，而不是从中间开始显示
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //实例化LocationManager 对象
    self.locationManage = [[CLLocationManager alloc]init];
    //实现代理
    self.locationManage.delegate = self;
    //开始更新位置信息
    [self.locationManage startUpdatingLocation];
    //向用户发起用户请求
    [self.locationManage requestAlwaysAuthorization];
    self.editMsgTextView.layer.borderColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1].CGColor;
    self.editMsgTextView.layer.borderWidth =1.0;
    self.editMsgTextView.layer.cornerRadius =5.0;
    
    
//    if (_isTextMsg) {
//        self.backImageView.hidden = YES;
//    }else{
//        self.backImageView.hidden = NO;
//    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"隐私设置" style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickSettingsButtonItem:)];
    self.yinsiView.layer.borderColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1].CGColor;
    self.yinsiView.layer.borderWidth = 1;
    self.yinsiView.layer.cornerRadius = 15;
    self.yinsiView.layer.masksToBounds = YES;
    
    
    
    UITapGestureRecognizer *tapGester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickTapGester:)];
    tapGester.cancelsTouchesInView = NO;
    [self.view  addGestureRecognizer:tapGester];
    
    
    self.editMsgTextView.delegate = self;

    
    [self.view bringSubviewToFront:self.pleaseLabel];
    
    
    
    self.currentUser = [AVUser currentUser];
    
    
    
}


#pragma mark - UITextView Delegate

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length ) {
        self.pleaseLabel.hidden = YES;
    }else{
        self.pleaseLabel.hidden = NO;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{

    if (textView.text.length ) {
        self.pleaseLabel.hidden = YES;
    }else{
        self.pleaseLabel.hidden = NO;
    }

}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length) {
        self.pleaseLabel.hidden = YES;
    }else{
        self.pleaseLabel.hidden = NO;
    }
}



//触摸屏幕回收键盘
-(void)didClickTapGester:(UITapGestureRecognizer *)tapGester{
    
    [self.editMsgTextView resignFirstResponder];
    [self.view endEditing:YES];
    
}





-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //    NSLog(@"%@",locations);
    //停止更新位置信息
    [self.locationManage stopUpdatingLocation];
    //地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //逆向地理编码
    [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //地标
        CLPlacemark *placemark = [placemarks lastObject];
        //地址信息字典
        NSDictionary *addressDic = [placemark addressDictionary] ;
        //        NSLog(@"--%@",[addressDic[@"FormattedAddressLines"] lastObject]);
        //
        //
        //        for (NSString *text in addressDic[@"FormattedAddressLines"]) {
        //            NSLog(@"---%@",text);
        //        }
        //
        
        NSString *addressString = [addressDic[@"FormattedAddressLines"] lastObject];
        if (addressString.length) {
            
            self.addressLabel.text = addressString;
        }else{
            self.addressLabel.text = @"地址信息获取失败";
        }
        
    }];
}

-(void)getImageWithPhoto{

    //实例化图片选择器视图控制器
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    //设置资源来源对象
    [imagePickerController setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
    //设置为可编辑状态
    imagePickerController.allowsEditing = YES;
    //设置代理对象
    imagePickerController.delegate = self;
    //模态出图片选择视图控制器
    [self showViewController:imagePickerController sender:nil];


}



-(void)viewWillAppear:(BOOL)animated{
    if (!_isTextMsg) {
        [self getImageWithPhoto];
    }
    if (self.BackImage.image) {
        self.isHasImage = YES;
    }else{
        self.isHasImage = NO;
    }
    if (self.isHasImage) {
        self.BackImage.hidden = NO;
        self.backImageButton.hidden = YES;
        self.cancelImageButton.hidden = NO;
    }else{
        self.BackImage.hidden = YES;
        self.backImageButton.hidden = NO;
        self.cancelImageButton.hidden = YES;
    }

    AVQuery *tdQuery = [AVQuery queryWithClassName:@"TdDiary"];
    [tdQuery whereKey:@"userKey" equalTo:self.currentUser[@"username"]];
    [tdQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            
            for (AVObject *tdDiary in objects) {
                if ([tdDiary[@"isEndTDDiary"] isEqualToString:@"NO"]) {
                    self.tdDiary = tdDiary;
                }
            }
        } else {
            // 输出错误信息
           // NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        if (!_tdDiary) {
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有创建游记，请先去创建游记..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                TDCreaterTDViewController *createTDVC = [[TDCreaterTDViewController alloc]init];
                [self.navigationController pushViewController:createTDVC animated:YES];
  
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    

    AVQuery *tdSharedQuary = [AVQuery queryWithClassName:@"TdPublicShares"];
    [tdSharedQuary whereKey:@"userKey" equalTo:self.currentUser[@"username"]];
    [tdSharedQuary findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            //  NSLog(@"Successfully retrieved %d posts.", objects.count);
            self.tdPublicShares = [objects firstObject];
            NSString *isShared = self.tdPublicShares[@"isPublicShare"];
            NSString *isAddress = self.tdPublicShares[@"isAddress"];
            if ([isShared isEqualToString:@"YES"]) {
                _isPublicShare = YES;
            }else{
                
                _isPublicShare = NO;
            }
            
            if ([isAddress isEqualToString:@"YES"]) {
                _isAddress = YES;
            }else{
                _isAddress = NO;
            }
        } else {
            // 输出错误信息
            //NSLog(@"Error: %@ %@", error, [error userInfo]);
            
            
            self.tdPublicShares = [AVObject objectWithClassName:@"TdPublicShares"];
            _tdPublicShares[@"userKey"] = self.currentUser[@"username"];
            _tdPublicShares[@"isPublicShare"] = @"YES";
            _tdPublicShares[@"isAddress"] = @"YES";
            self.isAddress = YES;
            self.isPublicShare = YES;
            [self.tdPublicShares saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // post 保存成功
                } else {
                    // 保存 post 时出错
                }
            }];
        }
    }];
    
    AVQuery *tdDiaryBeifenQuery = [AVQuery queryWithClassName:@"TdDiaryBeifen"];
    [tdDiaryBeifenQuery whereKey:@"userKey" equalTo:self.currentUser[@"username"]];
    [tdDiaryBeifenQuery getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            if (object != nil) {
                self.tdDiaryBeifen = object;
            }else{
                 self.tdDiaryBeifen = [AVObject objectWithClassName:@"TdDiaryBeifen"];
            }
        }else{
            self.tdDiaryBeifen = [AVObject objectWithClassName:@"TdDiaryBeifen"];
        
        }
    }];
}

#pragma mark - Image picker Delegate
//选择图片完成执行的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取选中的图片使用系统给的UIImagePickerControllerOriginalImage key
    //  UIImage *image = info[UIImagePickerControllerOriginalImage];
    //UIImagePickerControllerEditedImage 使用Info 字典可改变的图片
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    [self.BackImage setImage:image];
    
    
    if (self.BackImage.image) {
        self.isHasImage = YES;
        self.BackImage.hidden = NO;
        self.backImageButton.hidden = YES;
        self.cancelImageButton.hidden = NO;
        
    }else{
        self.isHasImage = NO;
        self.BackImage.hidden = YES;
        self.backImageButton.hidden = NO;
        self.cancelImageButton.hidden = YES;
    }
    
    self.imageSize = self.BackImage.image.size;

    [self dismissViewControllerAnimated:YES completion:nil];
}
//取消图片选择视图控制器的代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}




//点击添加图片的按钮
- (IBAction)didClickAddImageButton:(id)sender {
    
    [self getImageWithPhoto];
   
    if (self.BackImage.image) {
        self.isHasImage = YES;
    }else{
        self.isHasImage = NO;
    }
    
    if (self.isHasImage) {
        
        self.BackImage.hidden = NO;
        self.backImageButton.hidden = YES;
        self.cancelImageButton.hidden = NO;
        
    }else{
        self.BackImage.hidden = YES;
        self.backImageButton.hidden = NO;
        self.cancelImageButton.hidden = YES;
    }
    
    
}
//点击消息发送按钮
- (IBAction)didClickSendMessageButton:(id)sender {
    
    [self.editMsgTextView resignFirstResponder];
    [self.view endEditing:YES];
    
    
    NSString *tdNameText = self.editMsgTextView.text;
    if (![tdNameText stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
        
        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"文本内容不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
//    if (!self.isTextMsg) {
//         if(!self.isHasImage){
//            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"图片不能为空" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
//            
//            return;
//        }
//    }
    AVObject *tdListDiary = [AVObject objectWithClassName:@"TdListDiary"];
    
    tdListDiary[@"userKey"] = self.currentUser[@"username"];
    tdListDiary[@"diaryText"] = self.editMsgTextView.text;
    

    
    self.tdDiaryBeifen[@"userKey"] = self.currentUser[@"username"];
    self.tdDiaryBeifen[@"diaryText"] = self.editMsgTextView.text;
    NSNumber *isAddFriend = @(YES);
    self.tdDiaryBeifen[@"isAddFriend"] = isAddFriend;
    
    if (_isPublicShare) {
        tdListDiary[@"isPublicShare"] = @"YES";
        self.tdDiaryBeifen[@"isPublicShare"] = @"YES";

    }else{
        
        tdListDiary[@"isPublicShare"] = @"NO";
        self.tdDiaryBeifen[@"isPublicShare"] = @"NO";
    }
    
    
    if (_isAddress) {
        if ((![self.addressLabel.text isEqualToString:@"正在加载您当前的位置信息..."])&& (![self.addressLabel.text isEqualToString:@"地址信息获取失败"])) {
            
            tdListDiary[@"addressText"] = self.addressLabel.text;
            self.tdDiaryBeifen[@"addressText"] = self.addressLabel.text;
        }
    }

    if (!_isTextMsg) {
        
        NSData *imageData = UIImagePNGRepresentation(self.BackImage.image);
        AVFile *imageFile = [AVFile fileWithName:@"diaryImage.png" data:imageData];
        [imageFile saveInBackground];
        [tdListDiary setObject:imageFile forKey:@"diaryImage"];
        [self.tdDiaryBeifen setObject:imageFile forKey:@"diaryImage"];
        
        
        CGFloat imageWith = self.BackImage.image.size.width;
        CGFloat imageHeight = self.BackImage.image.size.height;
        tdListDiary[@"imageWith"] = [NSString stringWithFormat:@"%f",imageWith];
        self.tdDiaryBeifen[@"imageWith"] = [NSString stringWithFormat:@"%f",imageWith];
        
        tdListDiary[@"imageHeight"] = [NSString stringWithFormat:@"%f",imageHeight];
        self.tdDiaryBeifen[@"imageHeight"] = [NSString stringWithFormat:@"%f",imageHeight];
    }
    
    [tdListDiary setObject:self.tdDiary forKey:@"tdDiary"];
    
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
    
    [self.tdDiaryBeifen saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];

    [tdListDiary saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // post 保存成功
            
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            // post 保存成功
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            
        } else {
            // 保存 post 时出错
            
            
            [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
            // 保存 post 时出错
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存失败,只有网络畅通的条件下才可以保存奥..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }];
    
    
    
    
    
    
    
    
    
}


//点击消除图片的按钮
- (IBAction)didClickCancelButton:(id)sender {

    self.backImageButton.hidden  = NO;
    self.cancelImageButton.hidden = YES;
     self.BackImage.image = nil;
    self.BackImage.hidden = NO;
}
#pragma mark - UITextView Delegate 
//点击返回按钮的方法
-(void)didClickBackButtonItem:(UIBarButtonItem *)buttonItem{
    [self.editMsgTextView resignFirstResponder];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
//点击隐私设置按钮
-(void)didClickSettingsButtonItem:(UIBarButtonItem *)buttonItem{
    
    [self.editMsgTextView resignFirstResponder];
    [self.view endEditing:YES];
    TDPrivateMsgController *privateMC = [[TDPrivateMsgController alloc]init];
    [self.navigationController pushViewController:privateMC animated:YES];
    
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
