//
//  XTCacheRequest.m
//  XTkit
//
//  Created by teason23 on 2017/5/8.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "XTCacheRequest.h"
#import "ResponseDBModel.h"
#import "XTFMDB.h"
#import "YYModel.h"
#import "NSDate+XTTick.h"


@implementation XTCacheRequest

#pragma mark --

+ (void)cacheGET:(NSString *)url
      parameters:(NSDictionary *)param
             hud:(BOOL)hud
          policy:(XTResponseCachePolicy)cachePolicy
   timeoutIfNeed:(int)timeoutIfNeed
      completion:(void (^)(id json))completion
{
    NSString *strUniqueKey = [self fullUrl:url param:param] ;
    ResponseDBModel *resModel = [ResponseDBModel xt_findFirstWhere:[NSString stringWithFormat:@"requestUrl == '%@'",strUniqueKey]] ;
    if (!resModel)
    {// not cache
        resModel = [ResponseDBModel newDefaultModelWithKey:strUniqueKey
                                                       val:nil                         // response is nil
                                                    policy:cachePolicy
                                                   timeout:timeoutIfNeed] ;
        
        [self updateRequestWithType:XTRequestMode_GET_MODE
                                url:url
                                hud:hud
                              param:param
                      responseModel:resModel
                         completion:^(id json) {
                             if (completion) completion(json) ; // return
                         }] ;
    }
    else
    {// has cache
        switch (resModel.cachePolicy)
        {
            case XTResponseCachePolicyNeverUseCache:
            {//从不缓存 适合每次都实时的数据流.
                [self updateRequestWithType:XTRequestMode_GET_MODE
                                        url:url
                                        hud:hud
                                      param:param
                              responseModel:resModel
                                 completion:^(id json) {
                                     if (completion) completion(json) ; // return
                                 }] ;
            }
                break;
            case XTResponseCachePolicyAlwaysCache:
            {//总是获取缓存的数据.不再更新.
                if (completion) completion([resModel.response yy_modelToJSONObject]) ; // return
            }
                break;
            case XTResponseCachePolicyTimeout:
            {//规定时间内.返回缓存.超时则更新数据. 需设置timeout时间. timeout默认1小时
                if ([resModel isAlreadyTimeout])
                { // timeout . update request
                    [self updateRequestWithType:XTRequestMode_GET_MODE
                                            url:url
                                            hud:hud
                                          param:param
                                  responseModel:resModel
                                     completion:^(id json) {
                                         if (completion) completion(json) ; // return
                                     }] ;
                }
                else
                { // return cache
                    if (completion) completion([resModel.response yy_modelToJSONObject]) ; // return
                }
            }
                break;
            default:
                break;
        }
    }
}


+ (void)cachePOST:(NSString *)url
       parameters:(NSDictionary *)param
              hud:(BOOL)hud
           policy:(XTResponseCachePolicy)cachePolicy
    timeoutIfNeed:(int)timeoutIfNeed
       completion:(void (^)(id json))completion
{
    NSString *strUniqueKey = [self fullUrl:url param:param] ;
    ResponseDBModel *resModel = [ResponseDBModel xt_findFirstWhere:[NSString stringWithFormat:@"requestUrl == '%@'",strUniqueKey]] ;
    if (!resModel)
    {// not cache
        resModel = [ResponseDBModel newDefaultModelWithKey:strUniqueKey
                                                       val:nil                         // response is nil
                                                    policy:cachePolicy
                                                   timeout:timeoutIfNeed] ;
        
        [self updateRequestWithType:XTRequestMode_POST_MODE
                                url:url
                                hud:hud
                              param:param
                      responseModel:resModel
                         completion:^(id json) {
                             if (completion) completion(json) ; // return
                         }] ;
    }
    else
    {// has cache
        switch (resModel.cachePolicy)
        {
            case XTResponseCachePolicyNeverUseCache:
            {//从不缓存 适合每次都实时的数据流.
                [self updateRequestWithType:XTRequestMode_POST_MODE
                                        url:url
                                        hud:hud
                                      param:param
                              responseModel:resModel
                                 completion:^(id json) {
                                     if (completion) completion(json) ; // return
                                 }] ;
            }
                break;
            case XTResponseCachePolicyAlwaysCache:
            {//总是获取缓存的数据.不再更新.
                if (completion) completion([resModel.response yy_modelToJSONObject]) ; // return
            }
                break;
            case XTResponseCachePolicyTimeout:
            {//规定时间内.返回缓存.超时则更新数据. 需设置timeout时间. timeout默认1小时
                if ([resModel isAlreadyTimeout])
                { // timeout . update request
                    [self updateRequestWithType:XTRequestMode_POST_MODE
                                            url:url
                                            hud:hud
                                          param:param
                                  responseModel:resModel
                                     completion:^(id json) {
                                         if (completion) completion(json) ; // return
                                     }] ;
                }
                else
                { // return cache
                    if (completion) completion([resModel.response yy_modelToJSONObject]) ; // return
                }
            }
                break;
            default:
                break;
        }
    }
}





#pragma mark --
#pragma mark - private

+ (void)updateRequestWithType:(XTRequestMode)requestType
                          url:(NSString *)url
                          hud:(BOOL)hud
                        param:(NSDictionary *)param
                responseModel:(ResponseDBModel *)resModel
                   completion:(void (^)(id json))completion
{
    if (requestType == XTRequestMode_GET_MODE)
    {
        [self GETWithUrl:url
                     hud:hud
              parameters:param
                 success:^(id json) {
                     if (completion) completion(json) ; // return .
                     if (!resModel.response)
                     {
                         resModel.response = [json yy_modelToJSONString] ;
                         [resModel xt_insert] ; // db insert
                     }
                     else
                     {
                         resModel.response = [json yy_modelToJSONString] ;
                         resModel.updateTime = [NSDate xt_getTickFromNow] ;
                         [resModel xt_update] ; // db update
                     }
                 }
                    fail:^{
                        if (completion) completion([resModel.response yy_modelToJSONObject]) ;
                    }] ;
    }
    else if (requestType == XTRequestMode_POST_MODE)
    {
        [self POSTWithUrl:url
                      hud:hud
               parameters:param
                  success:^(id json) {
                      if (completion) completion(json) ; // return .
                      if (!resModel.response)
                      {
                          resModel.response = [json yy_modelToJSONString] ;
                          [resModel xt_insert] ; // db insert
                      }
                      else
                      {
                          resModel.response = [json yy_modelToJSONString] ;
                          resModel.updateTime = [NSDate xt_getTickFromNow] ;
                          [resModel xt_update] ; // db update
                      }
                  }
                     fail:^{
                         if (completion) completion([resModel.response yy_modelToJSONObject]) ;
                     }] ;
    }
}

@end






