//
//  Person.h
//  自定义KVO
//
//  Created by 胥鸿儒 on 16/8/3.
//  Copyright © 2016年 xuhongru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Person : NSObject
/**年龄*/
@property(nonatomic,assign) int age;
/**学号*/
@property(nonatomic,assign) int number;
/**名字*/
@property(nonatomic,copy)NSString *name;
@end
