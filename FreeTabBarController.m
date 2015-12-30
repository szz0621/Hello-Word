//
//  FreeTabBarController.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/23.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "FreeTabBarController.h"
#import "UIView+Common.h"
#import "AppListViewController.h"
#import "KillAllDefault.h"
@interface FreeTabBarController ()

@end

@implementation FreeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
    [self createLanchAnimation];
    // Do any additional setup after loading the view.
}

-(void)createViewControllers {
    NSArray *urlArray = @[kLimitUrl,kReduceUrl,kFreeUrl,kSubjectUrl,kHotUrl];
    NSArray *categoryViewArray = @[kLimitType,kReduceType,kFreeType,kSubjectType,kHotType];
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"Controllers" ofType:@"plist"];
    NSArray *vcArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    NSMutableArray *tabArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSDictionary *vcDict in vcArray) {
        Class class = NSClassFromString(vcDict[@"className"]);
        AppListViewController *listVC = [[class alloc]init];
        UINavigationController *listNav = [[UINavigationController alloc]initWithRootViewController:listVC];
        listVC.categoryViewType = categoryViewArray[i];
        listVC.requestURL = urlArray[i++];
        listVC.title = vcDict[@"title"];
        listVC.tabBarItem.image = [UIImage imageNamed:vcDict[@"iconName"]];
        [tabArray addObject:listNav];
    }
    self.viewControllers = tabArray;
}

-(void)createLanchAnimation {
    UIImageView *splshImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight())];
    NSString *splshImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Defaultretein%d@2x",arc4random_uniform(7)+1] ofType:@"png"];
    splshImageView.image = [[UIImage alloc]initWithContentsOfFile:splshImagePath];
    [self.view addSubview:splshImageView];
    [UIView animateWithDuration:3.0 animations:^{
        splshImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [splshImageView removeFromSuperview];
    }];
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
