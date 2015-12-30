//
//  NSString+Tools.h
//  KillAllFree
//
//  Created by qianfeng on 15/9/24.
//  Copyright © 2015年 袁肖松. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

NSString *URLEncodedString(NSString *str);

NSString * MD5Hash(NSString *aString);

@end
