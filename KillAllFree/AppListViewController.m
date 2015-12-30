//
//  AppListViewController.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/23.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "AppListViewController.h"
#import "UIView+Common.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONModel/JSONModel.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "KillAllDefault.h"
#import "AppModel.h"
#import "AppViewCell.h"
#import "StarsView.h"
#import "SearchViewController.h"
#import "NSString+Tools.h"
#import "CategoryViewController.h"
#import "DetailsViewController.h"
#import "DBManager.h"
#import "JWCache.h"

@interface AppListViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    
    NSString *_categoryID;
}

@end

@implementation AppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    _categoryID = @"0";
    // Do any additional setup after loading the view.
    [self initializeApp];
}
- (void)initializeApp {
    _dataArray = [NSMutableArray array];
    [self createTableView];
    [self initBarButtonItems];
    [self initRequestManager];
}
- (void)initBarButtonItems {
    
    CGRect barRect = {{0,0},{44,30}};
    [self addBarButtonItemWithTitle:@"设置" imageName:@"buttonbar_action" frame:barRect aSelector:@selector(rightItemAction:) isLeft:NO];
    
    [self addBarButtonItemWithTitle:@"分类" imageName:@"buttonbar_action" frame:barRect aSelector:@selector(leftItemAction:) isLeft:YES];
}
- (void)leftItemAction:(UIButton *)button {
    CategoryViewController *categoryViewController = [CategoryViewController new];
    [categoryViewController setCategoryIdBlock:^(NSString *categoryId){
        _categoryID = categoryId;
        [_tableView.header beginRefreshing];
    }];
    categoryViewController.title = @"分类";
    categoryViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:categoryViewController animated:YES];
}
- (void)rightItemAction:(UIButton *)button {
    
}
-(void)createTableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [self.view width], [self.view height]) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[AppViewCell class] forCellReuseIdentifier:@"appCell"];
    }
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [_tableView width], 44.0)];
    searchBar.delegate = self;
    searchBar.placeholder = @"60万款应用，搜搜看";
    _tableView.tableHeaderView = searchBar;
    _tableView.tableFooterView = [UIView new];
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self prepareLoadData:NO];
    }];
    _tableView.header = refreshHeader;
    
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self prepareLoadData:YES];
    }];
    _tableView.footer = refreshFooter;
    
    [refreshHeader beginRefreshing];
}
- (void)initRequestManager {
    if (_manager == nil) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
}
- (void)prepareLoadData:(BOOL)isMore {
    NSString *url = @"";
    NSInteger page = 1;
    if (isMore) {
        page = _dataArray.count/10 + 1;
    }
    if([_categoryViewType isEqual: kHotType]) {
        url = [NSString stringWithFormat:_requestURL,page];
        }else if([_categoryViewType isEqual: kSubjectType]){
            url = [NSString stringWithFormat:_requestURL,page];
        }else {
            url = [NSString stringWithFormat:_requestURL,page,_categoryID];
        }
    [self loadingData:url isMore:isMore];
}
-(void)loadingData:(NSString *)url isMore:(BOOL)isMore {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
    
    if (cacheData) {
        AppModel *appModel = [[AppModel alloc]initWithData:cacheData error:nil];
        if (!isMore) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:appModel.applications];
        [_tableView reloadData];
        !isMore?[_tableView.header endRefreshing]:[_tableView.footer endRefreshing];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }else {
        [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            AppModel *appModel = [[AppModel alloc]initWithData:responseObject error:nil];
            if (!isMore) {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:appModel.applications];
            [_tableView reloadData];
            !isMore?[_tableView.header endRefreshing]:[_tableView.footer endRefreshing];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [JWCache setObject:responseObject forKey:MD5Hash(url)];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            !isMore?[_tableView.header endRefreshing]:[_tableView.footer endRefreshing];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    SearchViewController *searchView = [SearchViewController new];
    if ([_categoryViewType isEqualToString:kHotType]) {
        searchView.requestURL = SEARCH_HOT_URL;
    }else if ([_categoryViewType isEqualToString:kLimitType]) {
        searchView.requestURL = SEARCH_LIMIT_URL;
    }else if ([_categoryViewType isEqualToString:kReduceType]) {
        searchView.requestURL = SEARCH_REDUCE_URL;
    }else {
        searchView.requestURL = SEARCH_FREE_URL;
    }
    searchView.searchText = URLEncodedString(searchBar.text);
    searchView.title = @"搜索结果";
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"appCell" forIndexPath:indexPath];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@--%ld",self.title,indexPath.row];
//    NSLog(@"%@",_dataArray[indexPath.row]);
    cell.applicationModel = _dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplicationModel *model = _dataArray[indexPath.row];
    DetailsViewController *detailView = [DetailsViewController new];
    detailView.idtifiner =model.applicationId;
    detailView.title =@"应用详情";
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: detailView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
