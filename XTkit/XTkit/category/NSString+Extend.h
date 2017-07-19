//
//  NSString+Extend.h
//  SuBaoJiang
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)
// 去除空格.
- (NSString *)minusSpaceStr ;
// \n
- (NSString *)minusReturnStr ;
// 转义单引号  '  -> \'
- (NSString *)encodeTransferredMeaningForSingleQuotes ;
// 转义单引号  \' -> '
- (NSString *)decodeTransferredMeaningForSingleQuotes ;
// 去掉小数点后面的0
+ (NSString *)changeFloat:(NSString *)stringFloat ;
// 数组切换','字符串(逗号分隔)
+ (NSString *)getCommaStringWithArray:(NSArray *)array ;
+ (NSArray *)getArrayFromCommaString:(NSString *)commaStr ;

@end
