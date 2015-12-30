//
//  ApplicationView.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/24.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "ApplicationView.h"
#import "StarsView.h"
#import "UIView+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ApplicationView {
    UIImageView *_appIconImageView;
    UILabel *_titleLabel;
    StarsView *_starView;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customViews];
    }
    return self;
}
-(void)customViews {
    _appIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
    [self addSubview:_appIconImageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(maxX(_appIconImageView) + 5, minY(_appIconImageView), width(self.frame) - maxX(_appIconImageView) - 5*2, 20)];
    [self addSubview:_titleLabel];
    
    _starView = [[StarsView alloc]initWithFrame:CGRectMake(minX(_titleLabel), maxY(_titleLabel) + 25, 65, 23)];
    [self addSubview:_starView];
}
-(void)setAppModel:(ApplicationsModel *)appModel {
    _appModel = appModel;
    [self reloadView];
}
-(void)reloadView {
    [_appIconImageView sd_setImageWithURL:[NSURL URLWithString:_appModel.iconUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    _titleLabel.text = _appModel.name;
    
    [_starView setLevel:[_appModel.starOverall doubleValue]];
}
-(void)resetPostion {
    
    _appIconImageView.frame = CGRectMake(5, 5, 50, 50);
    _titleLabel.frame = CGRectMake(maxX(_appIconImageView) + 5, minY(_appIconImageView), width(self.frame) - maxX(_appIconImageView) - 5*2, 20);
    _starView.frame = CGRectMake(minX(_titleLabel), maxY(_titleLabel) + 15, 65, 23);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
