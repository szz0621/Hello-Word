//
//  ApplicationView.h
//  KillAllFree
//
//  Created by qianfeng on 15/9/24.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectModel.h"

@interface ApplicationView : UIView

@property (nonatomic,strong)ApplicationsModel *appModel;
-(void)resetPostion;
@end
