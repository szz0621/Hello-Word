//
//  AppListViewController.h
//  KillAllFree
//
//  Created by qianfeng on 15/9/23.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "BaseViewController.h"

@class AFHTTPRequestOperationManager;
@interface AppListViewController : BaseViewController {
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    AFHTTPRequestOperationManager *_manager;
}

@property (nonatomic,copy)NSString *requestURL;
@property (nonatomic,copy)NSString *categoryViewType;

- (void)prepareLoadData:(BOOL)isMore;
-(void)loadingData:(NSString *)url isMore:(BOOL)isMore;


@end
