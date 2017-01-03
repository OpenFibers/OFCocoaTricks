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
 * @discussion 线程安全性：不是绝对线程安全，但一般不用加锁。此方法执行期间，其他线程仍可以修改类的继承关系，判定是否为子类的结果以此方法内的while循环为准。此方法一般不会直接造成崩溃，除非是在此方法的调用过程中，其他线程调用`objc_disposeClassPair`，造成子类的某个祖先类指针成为野指针，才有可能造成崩溃。  
 */
+ (BOOL)isClass:(const Class)subclass subclassOfClass:(const Class)aClass;

/**
 * 获取 aClass 的全部子类。
 * @discussion 性能：视获取子类的数量和缓存而定。在A10处理器上，获取 NSArray 的子类（27个）时耗费3ms-9ms；获取 UIView 的子类（582个）时耗费5ms-50ms，多次调用后稳定在 5ms-10ms，仅在最早两次调用耗费15ms-40ms；获取 NSObject 的子类（4718个）时耗费15ms-400ms，多次调用后稳定在15ms-50ms，仅在最早几次调用耗时150ms-400ms。
 * @discussion 线程安全性：不是绝对的线程安全，但一般不用加锁。由于`objc_getClassList`使用了写锁，所以：1) 在`objc_getClassList`执行过程中会阻塞其他线程增删类或对类修改；2) 在`getAllSubclassesOfClass:`的执行过程中，又不被`objc_getClassList`的写锁保护时，其他线程仍然对类做出修改，由于`objc_getClassList`拷贝`Class`的数量以buffer长度或实际类数量的较小值为准，所以此时不会造成缓存溢出或野指针问题，也不会造成直接崩溃，但有可能导致`getAllSubclassesOfClass:`返回的结果与返回时运行时里实际子类集合不一致。
 */
+ (NSArray *)getAllSubclassesOfClass:(Class)aClass;

@end
