//
//  SubjectViewController.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/23.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "SubjectViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "SubjectModel.h"
#import "KillAllDefault.h"
#import "SubjectViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "DetailsViewController.h"

@interface SubjectViewController () <TouchAppDelegate>

@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [_tableView registerClass:[SubjectViewCell class] forCellReuseIdentifier:@"subjectCell"];
    _tableView.tableHeaderView = nil;
    _tableView.rowHeight = 363;
}
-(void)loadingData:(NSString *)url isMore:(BOOL)isMore {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *modelArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (!isMore) {
            [_dataArray removeAllObjects];
        }
        for (NSDictionary *dict in modelArray) {
            SubjectModel *itemModel = [[SubjectModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:itemModel];
        }
        [_tableView reloadData];
        !isMore?[_tableView.header endRefreshing]:[_tableView.footer endRefreshing];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        !isMore?[_tableView.header endRefreshing]:[_tableView.footer endRefreshing];
//        
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subjectCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.subjectModel = _dataArray[indexPath.row];
    return cell;
}
- (void)touchAppForCell:(SubjectViewCell *)cell applicationId:(NSString *)applicationId {
    DetailsViewController *detailsView = [DetailsViewController new];
    detailsView.idtifiner = applicationId;
    [self.navigationController pushViewController:detailsView animated:YES];
    NSLog(@"applicationId ---- %@",applicationId);
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
