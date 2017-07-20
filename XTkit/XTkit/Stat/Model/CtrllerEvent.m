//
//  CtrllerEvent.m
//  PatchBoard
//
//  Created by teason23 on 2017/7/6.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "CtrllerEvent.h"
#import "NSDate+XTTick.h"
#import "UIView+CurrentController.h"

@implementation CtrllerEvent

- (instancetype)initWithName:(NSString *)name
                       title:(NSString *)title
                      action:(NSString *)action
                     ctrller:(UIViewController *)ctrller
{
    self = [super init];
    if (self) {
        self.name = name ;
        self.title = title ;
        self.action = action ;
        NSDate *now = [NSDate date] ;
        self.time = [now xt_getTick] ;
        self.dateStr = [now xt_getStr] ;
        self.tree = [ctrller.view chainInfo] ;
        self.uploaded = 0 ;
    }
    return self;
}

@end





