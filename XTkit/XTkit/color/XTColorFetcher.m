//
//  XTColorFetcher.m
//  pro
//
//  Created by TuTu on 16/8/16.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "XTColorFetcher.h"
#import "XTJson.h"
#import "UIColor+HexString.h"

@interface XTColorFetcher ()
@property (nonatomic,strong) NSDictionary *dicData   ;
@property (nonatomic,copy)   NSString     *plistName ;
@end

@implementation XTColorFetcher

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static XTColorFetcher *instance ;
    dispatch_once(&onceToken, ^{
        instance = [[XTColorFetcher alloc] init] ;
        [instance configurePlist:nil] ;
    });
    return instance ;
}

- (void)configurePlist:(NSString *)plist
{
    self.plistName = plist ?: @"xtAllColorsList" ;
}

- (NSDictionary *)dicData
{
    if (!_dicData) {
        _dicData = [self fromPlist] ;
    }
    return _dicData ;
}

- (NSDictionary *)fromPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.plistName
                                                          ofType:@"plist"] ;
    return [[NSDictionary alloc] initWithContentsOfFile:plistPath] ;
}

- (UIColor *)getColorWithRed:(float)fRed
                       green:(float)fGreen
                        Blue:(float)fBlue
{
    return [self getColorWithRed:fRed
                           green:fGreen
                            Blue:fBlue
                           alpha:1.0] ;
}

- (UIColor *)getColorWithRed:(float)fRed
                       green:(float)fGreen
                        Blue:(float)fBlue
                       alpha:(float)alpha
{
    return [UIColor colorWithRed:((float) fRed   / 255.0f)
                           green:((float) fGreen / 255.0f)
                            blue:((float) fBlue  / 255.0f)
                           alpha:alpha] ;
}

- (UIColor *)xt_colorWithKey:(NSString *)key
{
    NSString *jsonStr = [[XTColorFetcher sharedInstance].dicData objectForKey:key] ;
    if ([jsonStr containsString:@"["]) {
        NSArray *colorValList = [XTJson getJsonWithStr:jsonStr] ;
        return [self colorRGB:colorValList] ;
    }
    else {
        return [UIColor colorWithHexString:jsonStr] ;
    }
    return nil ;
}

- (UIColor *)colorRGB:(NSArray *)colorValList
{
    if (colorValList.count == 3) {
        return [[XTColorFetcher sharedInstance] getColorWithRed:[colorValList[0] floatValue]
                                                 green:[colorValList[1] floatValue]
                                                  Blue:[colorValList[2] floatValue]] ;
    } else if (colorValList.count == 4) {
        return [[XTColorFetcher sharedInstance] getColorWithRed:[colorValList[0] floatValue]
                                                 green:[colorValList[1] floatValue]
                                                  Blue:[colorValList[2] floatValue]
                                                 alpha:[colorValList[3] floatValue]] ;
    }
    return nil ;
}




@end
