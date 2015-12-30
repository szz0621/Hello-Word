//
//  CategoryViewController.h
//  KillAllFree
//
//  Created by qianfeng on 15/9/24.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CategoryIdBlock)(NSString *categoryId);

@interface CategoryViewController : BaseViewController

@property (nonatomic,copy) CategoryIdBlock categoryIdBlock;

@end
