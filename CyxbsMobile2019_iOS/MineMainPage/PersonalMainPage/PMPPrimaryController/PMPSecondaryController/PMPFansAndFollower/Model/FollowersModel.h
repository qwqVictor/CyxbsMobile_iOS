//
//  FollowersModel.h
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FollowersModel : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *isfocus;

/// 网络请求
/// @param success 成功之后执行的block
/// @param failure 失败之后,返回字符串
+ (void)getDataArySuccess:(void (^)(NSArray *array))success
                  Failure:(void (^)(void))failure;

@end

NS_ASSUME_NONNULL_END
