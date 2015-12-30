//
//  AppViewCell.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/23.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "AppViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Common.h"
#import "StarsView.h"
@implementation AppViewCell {
    
    UIImageView *_appIconImageView;
    UILabel *_titleLabel;
    UILabel *_restTimeLabel;
    UILabel *_priceLabel;
    UILabel *_lineLabel;
    UILabel *_categoryLabel;
    UILabel *_shareLabel;
    StarsView *_starsView;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customViews];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}
- (void)customViews {
    
    _appIconImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_appIconImageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_titleLabel];
    
    _restTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_restTimeLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_priceLabel];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _lineLabel.backgroundColor = [UIColor blackColor];
    [_priceLabel addSubview:_lineLabel];
    
    _categoryLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_categoryLabel];
    
    _shareLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_shareLabel];
    
    _starsView = [[StarsView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_starsView];
    
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)setApplicationModel:(ApplicationModel *)applicationModel {
    _applicationModel = applicationModel;
    [self reloadCell];
}
-(void)reloadCell {
    [_appIconImageView sd_setImageWithURL:[NSURL URLWithString:_applicationModel.iconUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    _titleLabel.text = _applicationModel.name;
    
    _priceLabel.text = _applicationModel.lastPrice;
    
    _shareLabel.text = [NSString stringWithFormat:@"分享:%@ 收藏:%@ 下载:%@",_applicationModel.shares,_applicationModel.favorites,_applicationModel.downloads];
    
    double doub = [[_applicationModel starCurrent] doubleValue];
    [_starsView setLevel:doub];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat lefMargin = 15;
    CGFloat topMargin = 10;
    _appIconImageView.frame = CGRectMake(lefMargin, topMargin, 70, 70);
    _titleLabel.frame = CGRectMake(maxX(_appIconImageView) + 10, topMargin - 5, width(self.frame) - 130, 25);
    _shareLabel.frame = CGRectMake(lefMargin, maxY(_appIconImageView) + 5, width(self.frame) - 2*lefMargin, 20);
    _priceLabel.frame = CGRectMake(width(self.frame) - 50, 20, 40, 40);
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _lineLabel.frame = CGRectMake(0, 19, 40, 2);
    _starsView.frame = CGRectMake(maxX(_appIconImageView) + 10, 50, 65, 23);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
