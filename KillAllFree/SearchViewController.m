//
//  SearchViewController.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/24.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.leftBarButtonItem= nil;
//    self.navigationItem.rightBarButtonItem = nil;
    _tableView.tableHeaderView = nil;
}
- (void)initBarButtonItems {
    
}
- (void)prepareLoadData:(BOOL)isMore {
    NSString *url = @"";
    NSInteger page = 1;
    if (isMore) {
        page = _dataArray.count/10 + 1;
    }
    url = [NSString stringWithFormat:self.requestURL,page,_searchText];
    [self loadingData:url isMore:isMore];
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
