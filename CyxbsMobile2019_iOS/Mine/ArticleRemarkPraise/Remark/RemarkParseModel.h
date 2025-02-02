//
//  RemarkParseModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 解析评论页的数据的模型
@interface RemarkParseModel : NSObject

/// 头像URL
@property(nonatomic,copy)NSString *avatar;

/// 别人对自己的评论的id
@property(nonatomic,copy)NSString *comment_id;

/// 别人对自己的评论
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *from_nickname;
@property(nonatomic,copy)NSString *has_more_reply;
@property(nonatomic,copy)NSString *is_praised;
@property(nonatomic,copy)NSString *is_self;
@property(nonatomic,copy)NSString *nick_name;
@property(nonatomic,copy)NSString *pics;

/// 自己发出的评论/帖子的id
@property(nonatomic,copy)NSString *post_id;
@property(nonatomic,copy)NSString *praise_count;
@property(nonatomic,copy)NSString *publish_time;
@property(nonatomic,copy)NSString *reply_id;

@property(nonatomic,copy)NSString *reply_list;
@property(nonatomic,copy)NSString *uid;

//自己发出的评论/帖子的内容
@property(nonatomic,copy)NSString *from;

/// type为@"1"时代表时动态收到了回复，@"2"代表时评论收到评论
@property(nonatomic,copy)NSString *type;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
/*
 {                                                                                  ˙
comment =             {                                                                ˙
  = "";                                                                       ˙
 "" = 5103;                                                               ˙
  = test;                                                                    ˙
 "" = "";                                                              ˙
 "" = 0;                                                              ˙
 "" = 0;                                                                  ˙
 "" = 0;                                                                     ˙
 "" = "";                                                                  ˙
  = "<null>";                                                                   ˙
 "" = 2811;                                                                  ˙
 "" = 0;                                                                ˙
 "" = 1614734936;                                                       ˙
 "" = 2801;                                                                 ˙
 "" = "<null>";                                                           ˙
  = 8bfcc512ee0befb0f19575cc4ef8937d8349a1bd;                                    ˙
};                                                                                     ˙
 = NSObject;                                                                       ˙
},
 */
