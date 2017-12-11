//
//  PassWordView.h
//  32.九宫格手势解锁
//
//  Created by zyj on 2017/12/7.
//  Copyright © 2017年 ittest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordView : UIView
@property(nonatomic,strong) BOOL (^passwordBlock)(NSString *);
@end
