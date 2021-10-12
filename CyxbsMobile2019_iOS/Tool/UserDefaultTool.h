//
//  UserDefaultTool.h
//  MoblieCQUPT_iOS
//
//  Created by 李展 on 2017/8/11.
//  Copyright © 2017年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultTool : NSObject
+(void)saveValue:(id) value forKey:(NSString *)key;

+(id)valueWithKey:(NSString *)key;

+(BOOL)boolValueWithKey:(NSString *)key;

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key;

+(void)saveParameter:(NSDictionary *)paramterDic;

+(void)print;

// 学号
+(void)saveStuNum:(NSString *)stuNum;
+(NSString *)getStuNum;

// 用户id
+(void)saveIdNum:(NSString *)idNum;
+(NSString *)getIdNum;


/// 该方法用于刷新Token，45天内有效，只能使用一次
+ (void)saveRefreshToken:(NSString *)refresh;
/// 用于刷新Token，45天内有效，只能使用一次
+ (NSString *)getRefreshToken;

/// 保存Token
+ (void)saveToken:(NSString *)token;
+ (NSString *)getToken;


+(void)removeALLData;

+ (void)saveGender:(NSString *)gender;
+ (NSString *)getGender;

+ (void)saveBirthday:(NSString *)birthday;
+ (NSString *)getBirthday;

@end
