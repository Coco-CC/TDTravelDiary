//
//  TDUserHeaderViewController.m
//  TDTravelDiary
//
//  Created by co on 15/11/26.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDUserHeaderViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface TDUserHeaderViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation TDUserHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerImage.image =[UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"userHeader"]];
    
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-back_home"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButtonItem:)];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

//-(void)didClickBackButtonItem:(UIBarButtonItem *)button{
//    //退出键盘
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (IBAction)clickButtonseletimage:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)]
    ;
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    [self showViewController:imagePickerController sender:nil];
    
  
}
- (IBAction)clickButtonsave:(id)sender {
  
    NSData *imageData = UIImagePNGRepresentation(self.headerImage.image);
    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
    [imageFile save];
    AVUser *currentUser = [AVUser currentUser];
    NSString *nameString = [currentUser objectForKey:@"mobilePhoneNumber"];
    if (nameString == nil) {
        
       NSString *thirdName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
        AVQuery *query =[AVQuery queryWithClassName:@"LvjiUserObject"];
        [query whereKey:@"userKey" equalTo:thirdName];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (object) {
                [object setObject:imageFile forKey:@"userImage"];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }];
    }else{
        //查询用户表中的当前用户
        AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
        [query whereKey:@"userKey" equalTo:nameString];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (object) {
                [object setObject:imageFile forKey:@"userImage"];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                      //  NSLog(@"保存成功");
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.headerImage setImage:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [picker dismissViewControllerAnimated:YES completion:NULL];

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
