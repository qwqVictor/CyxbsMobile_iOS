//
//  FansModel.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FansModel.h"
// network
#import "HttpClient.h"

@implementation FansModel

+ (void)getDataArySuccess:(void (^)(NSArray * _Nonnull))success
                  failure:(void (^)(void))failure {
    [[HttpClient defaultClient] requestWithPath:@""
                                         method:HttpRequestGet
                                     parameters:nil
                                 prepareExecute:nil
                                       progress:nil
    success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * mAry = [NSMutableArray array];
        for (NSDictionary * dict in responseObject[@"data"][@"fans"]) {
            FansModel * model = [FansModel mj_objectWithKeyValues:dict];
            [mAry addObject:model];
        }
        NSArray * ary = [mAry copy];
        success(ary);
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failure");
        failure();
    }];
}

@end
