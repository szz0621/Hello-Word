//
//  SubjectViewCell.h
//  KillAllFree
//
//  Created by qianfeng on 15/9/23.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectModel.h"

@class SubjectViewCell;
@protocol TouchAppDelegate <NSObject>

- (void)touchAppForCell:(SubjectViewCell *)cell applicationId:(NSString *)applicationId;

@end

@interface SubjectViewCell : UITableViewCell

@property (nonatomic,strong) SubjectModel *subjectModel;

@property (nonatomic,weak) id<TouchAppDelegate> delegate;

@end
