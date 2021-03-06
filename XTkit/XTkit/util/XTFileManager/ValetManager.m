//
//  ValetManager.m
//  XTkit
//
//  Created by teason23 on 2017/7/26.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "ValetManager.h"
#import <Valet/Valet.h>
#import <UIKit/UIDevice.h>

@interface ValetManager ()
@property (strong,nonatomic) VALValet *myValet ;
@end

@implementation ValetManager

DEF_SINGLETON(ValetManager)

- (instancetype)init
{
    self = [super init] ;
    if (self) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary] ;
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"] ;
        self.myValet = [[VALValet alloc] initWithIdentifier:appName
                                              accessibility:VALAccessibilityWhenUnlocked] ;
    }
    return self;
}

/**
 uname and pwd
 */
- (BOOL)saveUserName:(NSString *)name pwd:(NSString *)pwd {
    return [self.myValet setString:pwd forKey:name] ;
}

- (NSString *)getPwdWithUname:(NSString *)name {
    return [self.myValet stringForKey:name] ;
}

- (BOOL)removePwdWithUname:(NSString *)name {
    return [self.myValet removeObjectForKey:name] ;
}


/**
 prepareUUID
 prepare get unique UUID in Keychain when app did launching .
 @return bool success
 */
- (BOOL)prepareUUID {
    if ([self UUID] && [[self UUID] length]) return YES ;
    
    NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString ;
    NSLog(@"%@",uuid) ;
    return [self.myValet setString:uuid forKey:@"UUID"] ;
}


/**
 get unique UUID
 */
- (NSString *)UUID {
    return [self.myValet stringForKey:@"UUID"] ;
}

@end
