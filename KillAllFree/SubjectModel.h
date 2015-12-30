//
//  SubjectModel.h
//  
//
//  Created by qianfeng on 15/9/23.
//
//

#import "JSONModel.h"

@protocol ApplicationsModel <NSObject>

@end

@interface ApplicationsModel : JSONModel

@property (nonatomic,copy) NSString *applicationId;
@property (nonatomic,copy) NSString *downloads;
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *ratingOverall;
@property (nonatomic,copy) NSString *starOverall;

@end

@interface SubjectModel : JSONModel

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *desc_img;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,strong) NSMutableArray <ApplicationsModel> *applications;

@end
