//
//  SubjectViewCell.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/23.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "SubjectViewCell.h"
#import "ApplicationView.h"
#import "UIView+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SubjectViewCell {
    UILabel *_titleLabel;
    UIImageView *_iconImageView;
    UIImageView *_editorImageView;
    UITextView *_bottomTextView;
    NSMutableArray *_applicationViews;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor lightGrayColor];
        [self customViews];
    }
    return self;
}
- (void)customViews {
    
    _applicationViews = [NSMutableArray array];
    
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    
    _iconImageView = [UIImageView new];
    _iconImageView.layer.cornerRadius = 5.0;
    _iconImageView.clipsToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    
    _editorImageView = [UIImageView new];
    _editorImageView.layer.cornerRadius = 30;
    _editorImageView.clipsToBounds = YES;

    [self.contentView addSubview:_editorImageView];
    
    _bottomTextView = [UITextView new];
    _bottomTextView.editable = NO;
    _bottomTextView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_bottomTextView];
    
    for (int i = 0; i < 4; i++) {
        ApplicationView *appView = [ApplicationView new];
        appView.tag = 1000 + i;
        [self.contentView addSubview:appView];
        [_applicationViews addObject:appView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tapAppView:)];
        [appView addGestureRecognizer:tapGesture];
    }
}
- (void)tapAppView:(UIGestureRecognizer *)recognizer {
    ApplicationView *applicationView = (ApplicationView *)[recognizer view];
    NSInteger viewTag = applicationView.tag - 1000;
    if (_delegate && [_delegate respondsToSelector:@selector(touchAppForCell:applicationId:)]) {
        ApplicationsModel *appModel = _subjectModel.applications[viewTag];
        [_delegate touchAppForCell:self applicationId:appModel.applicationId];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat  topMargin = 5;
    CGFloat leftMargin = 10;
    CGFloat margin = 5;
    _titleLabel.frame = CGRectMake(leftMargin, topMargin, width(self.bounds) - 2*leftMargin, 40);
    _iconImageView.frame = CGRectMake(leftMargin, maxY(_titleLabel) + margin, 140, 240);
    _editorImageView.frame = CGRectMake(minX(_titleLabel), maxY(_iconImageView) + 2*margin, 60, 60);
    _bottomTextView.frame = CGRectMake(maxX(_editorImageView) + margin, minY(_editorImageView), width(self.bounds) - maxX(_editorImageView) - 2*margin, 60);
    
    
    CGFloat appViewY = minY(_iconImageView) + 1;
    int appCount = (int)_subjectModel.applications.count;
    for (int i = 0; i < 4; i++) {
        ApplicationView *view = _applicationViews[i];
        if (i<appCount) {
            view.frame = CGRectMake(maxX(_iconImageView) + margin,appViewY, width(self.bounds)-maxX(_iconImageView) - 2*margin, 58);
            view.backgroundColor = [UIColor lightGrayColor];
            appViewY+=58 + 1;
            view.hidden = NO;
            [view resetPostion];
        }else {
            view.hidden = YES;
        }
    }
}
- (void)setSubjectModel:(SubjectModel *)subjectModel {
    _subjectModel = subjectModel;
    [self reloadData];
}
- (void)reloadData {
    
    _titleLabel.text = _subjectModel.title;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_subjectModel.img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [_editorImageView sd_setImageWithURL:[NSURL URLWithString:_subjectModel.desc_img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _bottomTextView.text = _subjectModel.desc;
    _bottomTextView.font = [UIFont boldSystemFontOfSize:13];
    
    NSInteger i = 0;
    for (ApplicationsModel *appModel in _subjectModel.applications) {
        ApplicationView *appView = _applicationViews[i];
        appView.appModel = appModel;
        i++;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
