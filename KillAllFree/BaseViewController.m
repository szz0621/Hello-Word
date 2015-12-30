//
//  BaseViewController.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/23.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+Common.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleWithName:self.title];
//    [self createBarButtonItem];
    // Do any additional setup after loading the view.
}
- (void)addTitleWithName:(NSString *)name {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = name;
    titleLabel.textColor = [UIColor colorWithRed:30/255.f green:160/255.f blue:230/255.f alpha:1];
    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}
//- (void)createBarButtonItem {
//    
//    UIButton *targetButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    targetButton.frame = CGRectMake(0, 0, 44, 30);
//    [targetButton setTitle:@"分类" forState:UIControlStateNormal];
//    [targetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [targetButton setBackgroundImage:[UIImage imageNamed:@"buttonbar_action"] forState:UIControlStateNormal];
//    [targetButton addTarget:self action:@selector(targetAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:targetButton];
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
//    
//}
//- (void)targetAction:(UIButton *)button {
//    
//}
- (void)addBarButtonItemWithTitle:(NSString *)title imageName:(NSString *)imageName frame:(CGRect)frame aSelector:(SEL)aSelector isLeft:(BOOL)isLeft{
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, width(frame), height(frame));
    [barButton setTitle:title forState:UIControlStateNormal];
    [barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [barButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if ([self respondsToSelector:aSelector]) {
        
        [barButton addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barButton];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }else {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
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
