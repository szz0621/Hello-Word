//
//  UIView+Common.m
//  KillAllFree
//
//  Created by qianfeng on 15/9/23.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Postion)

CGFloat screenWidth() {
    return [[UIScreen mainScreen] bounds].size.width;
}

CGFloat screenHeight() {
    return [[UIScreen mainScreen] bounds].size.height;
}

CGFloat width(CGRect rect) {
    return CGRectGetWidth(rect);
}
CGFloat height(CGRect rect) {
    return CGRectGetHeight(rect);
}

- (CGFloat)width {
    return self.frame.size.width;
}
- (CGFloat)height {
    return self.frame.size.height;
}

CGFloat maxX(UIView *view) {
    return CGRectGetMaxX(view.frame);
}
CGFloat maxY(UIView *view) {
    return CGRectGetMaxY(view.frame);
}
CGFloat midX(UIView *view) {
    return CGRectGetMidX(view.frame);
}
CGFloat midY(UIView *view) {
    return CGRectGetMidY(view.frame);
}
CGFloat minX(UIView *view) {
    return CGRectGetMinX(view.frame);
}
CGFloat minY(UIView *view) {
    return CGRectGetMinY(view.frame);
}
@end

@implementation UIView (Common)

@end
