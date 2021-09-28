//
//  FollowersModel.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FollowersModel.h"
//network
#import "HttpClient.h"

@implementation FollowersModel

+ (void)getDataArySuccess:(void (^)(NSArray * _Nonnull))success
                  Failure:(void (^)(void))failure {
    [[HttpClient defaultClient] requestWithPath:@""
                                         method:HttpRequestGet
                                     parameters:nil
                                 prepareExecute:nil
                                       progress:nil
    success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray * mAry = [NSMutableArray array];
        for(NSDictionary *dict in responseObject[@"data"][@"follows"]){
            FollowersModel *model = [FollowersModel mj_objectWithKeyValues:dict];
            [mAry addObject:model];
        }
        NSMutableArray *ary = [mAry copy];
        success(ary);
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();
    }];
}
@end
