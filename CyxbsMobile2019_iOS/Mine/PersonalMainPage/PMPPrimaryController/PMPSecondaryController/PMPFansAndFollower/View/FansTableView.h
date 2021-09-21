//
//  FansTableView.h
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*我的粉丝
 展示粉丝列表
*/
@interface FansTableView : UITableView

/// 数据
@property (nonatomic, copy) NSArray * dataAry;

@end

NS_ASSUME_NONNULL_END
