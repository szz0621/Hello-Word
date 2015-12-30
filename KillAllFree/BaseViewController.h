//
//  BaseViewController.h
//  KillAllFree
//
//  Created by qianfeng on 15/9/23.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)addBarButtonItemWithTitle:(NSString *)title imageName:(NSString *)imageName frame:(CGRect)frame aSelector:(SEL)aSelector isLeft:(BOOL)isLeft;

@end
