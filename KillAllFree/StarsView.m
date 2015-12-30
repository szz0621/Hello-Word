//
//  StarsView.m
//  
//
//  Created by qianfeng on 15/9/23.
//
//

#import "StarsView.h"

@implementation StarsView {
    UIImageView *_foreGroundView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        [self customViews];
    }
    return self;
}

-(void)customViews{
    
    UIImageView *backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 23)];
    backGroundView.image = [UIImage imageNamed:@"StarsBackground"];
    
    [self addSubview:backGroundView];
    
    
    _foreGroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _foreGroundView.contentMode = UIViewContentModeLeft;
    _foreGroundView.image = [UIImage imageNamed:@"StarsForeground"];
    
    _foreGroundView .clipsToBounds = YES;
    
    [self addSubview:_foreGroundView];
}

-(void)setLevel:(double)level {
    _foreGroundView.frame = CGRectMake(0, 0, 65*(level/5.0), 23);
}
@end
