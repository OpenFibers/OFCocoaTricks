//
//  OFGetSubclassesHelper.h
//  OFCocoaTricks
//
//  Created by openthread on 02/01/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFGetSubclassesHelper : NSObject

/**
 * 判断一个 subClass 是否为 aClass 的子类。不仅限于 NSObject。
 * @discussion 性能：非常快，因为实现是直接取Class结构体成员superclass。
 * @discussion 线程安全：1) 此方法执行期间，其他线程仍可以修改类的继承关系; 2) 不会造成直接崩溃。
 */
+ (BOOL)isClass:(const Class)subclass subclassOfClass:(const Class)aClass;

/**
 * 获取 aClass 的全部子类。
 * @discussion 性能：视缓存而定。在A10处理器上，获取 NSArray 的子类（27个）时耗费3ms-9ms；获取 NSObject 的子类（4718个）时耗费15ms-400ms，多次调用后稳定在15ms-50ms，仅在最早几次调用耗时150ms-400ms。
 * @discussion 线程安全性：class_getSuperclass使用了写锁，所以：1) 在class_getSuperclass执行中会阻塞运行时生成新的类；2) 不在class_getSuperclass执行期间时，其他线程仍然可以注册新的类; 3) 不会造成直接崩溃。
 */
+ (NSArray *)getAllSubclassesOfClass:(Class)aClass;

@end
