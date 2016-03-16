//
//  TDCreaterTDViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/24.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDCreaterTDViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
@interface TDCreaterTDViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextFile;
@property (weak, nonatomic) IBOutlet UIView *backImageUIView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *msgOkButton;
@property (nonatomic,strong) AVQuery *tdQuary;
@property (nonatomic,assign,getter=isHasImage) BOOL isHasImage; //用于判断图片是否已经存在
@property (nonatomic,assign,getter = isHadTextName) BOOL  isHadTextName; //用于判断用户名是否已经存在了
@property (nonatomic,strong) AVUser *currentUser;
@end

@implementation TDCreaterTDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [AVUser currentUser];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};//[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];

    
    self.navigationItem.title = @"创建游记";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:(UIBarButtonItemStylePlain) target:self action:@selector(didClicBackButtonItem:)];//initWithTitle:@"发送" style:(UIBarButtonItemStylePlain) target:self action:@selector(didClicBackButtonItem:)];
    self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:1];
    
    self.cancelButton.hidden = YES;
    self.backImageView.hidden = YES;

    self.msgOkButton.layer.borderColor = [UIColor whiteColor].CGColor;//colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1].CGColor;
    self.msgOkButton.layer.borderWidth = 2;
    self.msgOkButton.layer.cornerRadius = 15;
    self.msgOkButton.layer.masksToBounds = YES;
    
    self.nameTextFile.delegate = self;
    
    
    UITapGestureRecognizer *tapGester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickTapGester:)];
    tapGester.cancelsTouchesInView = NO;
    [self.view  addGestureRecognizer:tapGester];
    
    

 //    AVObject *tdDiary = [AVObject objectWithClassName:@"tdDiary"];
    
    self.tdQuary = [AVQuery queryWithClassName:@"TdDiary"];
    [self.tdQuary whereKey:@"userKey" equalTo:self.currentUser[@"username"]];
    [self.tdQuary findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
           // NSLog(@"Successfully retrieved %lu posts.", (unsigned long)objects.count);
            for (AVObject *tdDiary in objects) {
                
                if ([tdDiary[@"isEndTDDiary"] isEqualToString:@"NO"]) {
                    
                    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还有游记没有结束,只有结束上一次游记才可以创建新的游记是否结束上一次的游记？" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        tdDiary[@"isEndTDDiary"] = @"YES";
                        
                        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
                        [tdDiary saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                // post 保存成功
                                [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
                                // post 保存成功
                                UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"修改成功,您可以创建游记了..." preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                [alertController addAction:okAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                            } else {
                                // 保存 post 时出错
                                
                                [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
                                // 保存 post 时出错
                                UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存失败,只有网络畅通的条件下才可以结束游记奥..." preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                [alertController addAction:okAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }
                        }];
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        } else {
            // 输出错误信息
           // NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

//触摸屏幕回收键盘
-(void)didClickTapGester:(UITapGestureRecognizer *)tapGester{

    [self.nameTextFile resignFirstResponder];
    [self.view endEditing:YES];

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
#pragma mark - Image picker Delegate
//选择图片完成执行的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取选中的图片使用系统给的UIImagePickerControllerOriginalImage key
    //  UIImage *image = info[UIImagePickerControllerOriginalImage];
    //UIImagePickerControllerEditedImage 使用Info 字典可改变的图片
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    [self.backImageView setImage:image];
    
    
    if (self.backImageView.image) {
        self.isHasImage = YES;
        self.cancelButton.hidden = NO;
        self.backImageView.hidden = NO;
        self.addImageButton.hidden = YES;
    }else{
        self.isHasImage = NO;
        self.cancelButton.hidden = YES;
        self.backImageView.hidden = YES;
        self.addImageButton.hidden = NO;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
//取消图片选择视图控制器的代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}




-(void)didClicBackButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.nameTextFile resignFirstResponder];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
//点击确定按钮
- (IBAction)didClickOkButton:(id)sender {
    
    NSString *tdNameText = self.nameTextFile.text;
    if (![tdNameText stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
        
        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"游记名称不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }else if(!self.isHasImage){
    
        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"背景图片不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    
        return;
    }else{
    
        
        self.isHadTextName = NO;

        
        [self.tdQuary findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // 检索成功
                for (AVObject *tdDiary in objects) {
                    
                    if ([tdDiary[@"nameDiary"] isEqualToString:self.nameTextFile.text]) {
                        
                        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该游记名称已经存在了，请重新创建游记名称" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                             self.isHadTextName = YES;
                        }];
                        [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                       
                       return ;
                    }
                    
                    
                }
                // NSLog(@"Successfully retrieved %d posts.", objects.count);
            } else {
                // 输出错误信息
                //  NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
            
            
            
            if (!_isHadTextName) {
                
                
                AVObject *tdDiary = [AVObject objectWithClassName:@"TdDiary"];
                tdDiary[@"userKey"] = self.currentUser[@"username"];
                tdDiary[@"nameDiary"] =  self.nameTextFile.text;
                tdDiary [@"isEndTDDiary"] = @"NO"; // 用于判断游记是否已经结束
                // NSLog(@"======---===%@",self.backImageView.image);
                NSData *imageData = UIImagePNGRepresentation(self.backImageView.image);
                AVFile *imageFile = [AVFile fileWithName:@"backImageName.png" data:imageData];
                [imageFile saveInBackground];
                [tdDiary setObject:imageFile forKey:@"backImageName"];
                [tdDiary saveInBackground]; //保存对象
                
                
                
                MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                progressHUD.color = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.8];
                
                
                
                
                [tdDiary saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
                        // post 保存成功
                        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存成功,您可以添加游记了..." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
   
                    } else {
                        [progressHUD performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
                        // 保存 post 时出错
                        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存失败,只有网络畅通的条件下才可以创建游记奥..." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }];
    
            }
        }];
    //    NSLog(@"---------%d",self.isHadTextName);
    }
}

//点击添加图片的按钮
- (IBAction)didClickAddImageButton:(id)sender {
    
    //self.cancelButton.hidden = NO;
    self.backImageView.hidden = NO;
    [self getImageWithPhoto];
}

//点击清除图片的按钮
- (IBAction)didClickCancelButton:(id)sender {
    
    if (_isHasImage) {
        self.cancelButton.hidden = YES;
        self.backImageView.hidden = YES;
        self.backImageView.image = nil;
        self.addImageButton.hidden = NO;
        _isHasImage= NO;
    }
}

#pragma mark - UITextFile Delegate 
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
  //  if (textField == self.nameTextFile) {
        [self.nameTextFile resignFirstResponder];
//    }
    return YES;
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
