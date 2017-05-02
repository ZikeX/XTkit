//
//  XTJson.m
//  subao
//
//  Created by TuTu on 16/1/7.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "XTJson.h"

@implementation XTJson

+ (id)getJsonObj:(NSString *)jsonStr
{
    NSError *error ;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                 options:0
                                                   error:&error] ;
    if (!jsonObj)
    {
        NSLog(@"error : %@",error) ;
        return nil ;
    }
    else
    {
        //xtjson success
    //    NSLog(@"jsonObj : %@",jsonObj) ;
        return jsonObj ;
    }
}

+ (NSString *)getJsonStr:(id)jsonObj
{
    NSString *jsonStr ;
    if ([NSJSONSerialization isValidJSONObject:jsonObj])
    {
        NSError *error ;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj
                                                           options:0
                                                             error:&error] ;
        jsonStr = [[NSString alloc] initWithData:jsonData
                                        encoding:NSUTF8StringEncoding] ;
        if (!jsonStr)
        {
            NSLog(@"error : %@",error) ;
            return nil ;
        }
        else
        {
            //xtjson success
        //  NSLog(@"jsonStr : %@",jsonStr) ;
            return jsonStr ;
        }
    }
    else
    {
        NSLog(@"IS NOT KIND OF JSON OBJECT") ;
        return nil ;
    }
}

@end
