//
//  DetailsModel.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/24.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "DetailsModel.h"

@implementation PhotosModel

@end

@implementation DetailsModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description":@"detailDescription"}];
}

@end
