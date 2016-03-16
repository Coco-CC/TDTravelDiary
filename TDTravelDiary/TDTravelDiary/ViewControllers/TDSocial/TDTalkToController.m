//
//  TDTalkToController.m
//  TDTravelDiary
//
//  Created by co on 15/11/27.
//  Copyright © 2015年 Coco. All rights reserved.
//

#import "TDTalkToController.h"
#import "AppDelegate.h"
#import "Name.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "TDFollowCell.h"
#import "TDTalkingViewController .h"
@interface TDTalkToController ()
@property (nonatomic,strong) NSArray *fetchedArray;
@property (nonatomic,strong) NSMutableArray *sourceArray;

@property (nonatomic,strong) NSData *imageData;

@property (nonatomic,strong) NSString *otherName;
@end

@implementation TDTalkToController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetchedArray = [NSArray new];
    self.sourceArray =[NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"TDFollowCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBarbutton:)];
    [self getPersonTalkedWithCurrentUser];
    
    
}
- (void)didClickLeftBarbutton:(UIBarButtonItem *)barbutton
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)getPersonTalkedWithCurrentUser
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.fetchedArray = [delegate fetchAllPersonTalkedWithMeWithEntityName:@"Name"];
    for (Name *name in self.fetchedArray) {
        NSString *userID = name.otheruserID;
        
        if(userID == nil)
        {
            [self.tableView reloadData];
            
            
        }
        else
        {
            AVQuery *query = [AVQuery queryWithClassName:@"LvjiUserObject"];
            
            [query whereKey:@"userKey" equalTo:userID];
            
            [self.sourceArray addObject:[query getFirstObject]];
            [self.tableView reloadData];
        }
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.sourceArray.count;
    return self.sourceArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    self.otherName = [self.sourceArray[indexPath.row] objectForKey:@"nickname"];
    UIImageView *photo = [[UIImageView alloc]init];
    AVFile *imagefile = [self.sourceArray[indexPath.row] objectForKey:@"userImage"];
    
    NSData *imagedata = [imagefile getData];
    
    //用来页面传值的imagedata
    self.imageData = [NSData dataWithData:imagedata];
    
    
    photo.image = [UIImage imageWithData:imagedata] ;
    cell.imageview.frame = CGRectMake(10, 10, 30, 30);
    cell.imageview.layer.cornerRadius = cell.imageview.frame.size.height/2;
    cell.imageview.layer.masksToBounds = YES;
    
    
    
    cell.imageview.image = photo.image;
    
    
    
    
    cell.nameLable.text = self.otherName;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    TDTalkingViewController *TDTC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TDTalkingViewController"];
    TDTC.otherID = [self.sourceArray[indexPath.row]objectForKey:@"username"];
    //TDTC.imagedata = self.imageData;
    TDTC.imagedata = [NSData dataWithData:self.imageData];
    [self.navigationController pushViewController:TDTC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
