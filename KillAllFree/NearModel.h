//
//  NearModel.h
//  KillAllFree
//
//  Created by qianfeng on 15/9/25.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "JSONModel.h"

@interface NearModel : JSONModel

@property (nonatomic, copy) NSString *applicationId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *releaseDate;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *itunesUrl;
@property (nonatomic, copy) NSString *starCurrent;
@property (nonatomic, copy) NSString *starOverall;
@property (nonatomic, copy) NSString *ratingOverall;
@property (nonatomic, copy) NSString *downloads;
@property (nonatomic, copy) NSString *currentPrice;
@property (nonatomic, copy) NSString *lastPrice;
@property (nonatomic, copy) NSString *priceTrend;
@property (nonatomic, copy) NSString *expireDatetime;
@property (nonatomic, copy) NSString *ipa;
@property (nonatomic, copy) NSString *slug;

@end
