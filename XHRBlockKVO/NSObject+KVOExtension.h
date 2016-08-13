//
//  NSObject+KVOExtension.h
//  自定义KVO
//
//  Created by 胥鸿儒 on 16/8/3.
//  Copyright © 2016年 xuhongru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (KVOExtension)
/**
 * 添加监听
 */
- (void)xhr_addObserverForKey:(NSString *)key block:(void (^)(NSDictionary *valueInfo))valueChangedBlock;
/**
 * 移除监听
 */
- (void)xhr_removeObserverForKey:(NSString *)key;
/**
 *  移除所有监听
 */
- (void)xhr_removeAllObserver;
@end
