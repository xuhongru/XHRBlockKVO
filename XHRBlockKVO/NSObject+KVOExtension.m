//
//  NSObject+KVOExtension.m
//  自定义KVO
//
//  Created by 胥鸿儒 on 16/8/3.
//  Copyright © 2016年 xuhongru. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NSObject+KVOExtension.h"
#import <objc/runtime.h>
@interface XHRKVOAssistClass:NSObject

/**存放监听key值的数组*/
@property(nonatomic,strong)NSMutableArray *observerKeyArray;

@end
@implementation XHRKVOAssistClass
- (instancetype)init
{
    if (self = [super init]) {
        self.observerKeyArray = [NSMutableArray array];
    }
    return self;
}

@end
//定义一个带一个参数类型的IMP指针,用来记录setter方法
typedef void (*_VIMP)(id,SEL,...);
//子类的前缀
static NSString *const childClassPrefix = @"XHRKVO_observerChild_";
//存辅助类的key值
static char *XHRKVOAssistInstance = "XHRKVOAssistInstance";
@implementation NSObject (KVOExtension)
- (void)xhr_addObserverForKey:(NSString *)key block:(void (^)(NSDictionary *valueInfo))valueChangedBlock
{
    //获取setter方法名
    NSString *selectorName = [NSString stringWithFormat:@"set%@:",key.capitalizedString];
    SEL setterSEL = NSSelectorFromString(selectorName);
    //记录被监听者的setter方法的IMP指针
    Method superSetter = class_getInstanceMethod([self class], setterSEL);
    //动态创建一个类,继承自调用者的类
    //子类的类名
    NSString *childClassName = NSStringFromClass([self class]);
    if (![childClassName hasPrefix:childClassPrefix])
    {
         childClassName = [NSString stringWithFormat:@"%@%@",childClassPrefix,NSStringFromClass([self class])];
    }
    else
    {
        superSetter = class_getInstanceMethod(class_getSuperclass([self class]),setterSEL);
    }
    _VIMP superSetterIMP = (_VIMP)method_getImplementation(superSetter);
    //获取被监听属性的数据类型
    NSString *methodType = [NSString stringWithUTF8String:method_getTypeEncoding(superSetter)];
    //NSLog(@"%@",methodType);//v20@0:8i16 //
    methodType = [methodType componentsSeparatedByString:@"@0:8"].lastObject;
    
    NSString *valueType = [methodType substringToIndex:methodType.length - 2];
    //判断需要创建的类是否存在 objc_getClass
    Class ChildClass = objc_getClass(childClassName.UTF8String);
    if (!ChildClass) {
        //创建类
        ChildClass = objc_allocateClassPair([self class], childClassName.UTF8String, 0);
        //注册类
        objc_registerClassPair(ChildClass);
    }
    //使当前类的isa指针指向新创建的类
    object_setClass(self, ChildClass);
    //利用私有辅助类来存储key值
    XHRKVOAssistClass *KVOAssistInstance = objc_getAssociatedObject(self, XHRKVOAssistInstance);
    if (!KVOAssistInstance) {
        KVOAssistInstance = [[XHRKVOAssistClass alloc]init];
        objc_setAssociatedObject(self, XHRKVOAssistInstance, KVOAssistInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [KVOAssistInstance.observerKeyArray addObject:@{valueType:key}];
    //子类的setter方法
    __weak typeof(self)weakself = self;
    //根据valueType的映射类型来判断监听参数的类型,并重写子类的setter方法
    IMP childSetValue = nil;
    if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(int)]]) {
        
        childSetValue = imp_implementationWithBlock(^(id _self, int newValue) {
           
            //调用被监听对象(父类)的setter方法给被监听者属性赋值//@"こうさか ほのか"
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(unsigned int)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,unsigned int newValue) {
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(short)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,short newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(unsigned short)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,unsigned short newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(float)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,float newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(float)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,float newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(double)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,double newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(long)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,long newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(unsigned long)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,unsigned long newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(char)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,char newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(BOOL)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,BOOL newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(Boolean)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,Boolean newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, @(newValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":@(newValue)};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(CGRect)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,CGRect newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithCGRect:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithCGRect:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(CGPoint)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,CGPoint newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithCGPoint:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithCGPoint:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(CGSize)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,CGSize newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithCGSize:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithCGSize:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(NSRange)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,NSRange newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithRange:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithRange:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(UIEdgeInsets)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,UIEdgeInsets newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithUIEdgeInsets:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithUIEdgeInsets:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(CGVector)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,CGVector newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithCGVector:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithCGVector:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(UIOffset)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,UIOffset newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, [NSValue valueWithUIOffset:newValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":[NSValue valueWithUIOffset:newValue]};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    else if ([valueType isEqualToString:[NSString stringWithUTF8String:@encode(id)]])
    {
        childSetValue = imp_implementationWithBlock(^(id _self,id newValue) {
            
            //调用被监听对象(父类)的setter方法给被监听者属性赋值
            (*superSetterIMP)(_self,setterSEL,newValue);
            
            id oldValue = objc_getAssociatedObject(weakself, key.UTF8String);
            
            objc_setAssociatedObject(weakself, key.UTF8String, newValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (!oldValue) {
                oldValue = [NSNull null];
            }
            if (!newValue) {
                newValue = [NSNull null];
            }
            NSDictionary *valueInfoDictionary = @{@"oldValue":oldValue,@"newValue":newValue};
            
            !valueChangedBlock?:valueChangedBlock(valueInfoDictionary);
        });
    }
    //给子类添加setter方法
    class_replaceMethod(ChildClass, setterSEL, childSetValue, [NSString stringWithFormat:@"v@:%@",valueType].UTF8String);
}
- (void)xhr_removeAllObserver
{
    if (![NSStringFromClass([self class]) hasPrefix:childClassPrefix])return;
    objc_removeAssociatedObjects(self);
    object_setClass(self, class_getSuperclass([self class]));
}
- (void)xhr_removeObserverForKey:(NSString *)key
{
    if (![NSStringFromClass([self class]) hasPrefix:childClassPrefix]) return;
    XHRKVOAssistClass *KVOAssistInstance = objc_getAssociatedObject(self, XHRKVOAssistInstance);
    /**
     *  防止重复移除监听
     */
    if (!KVOAssistInstance.observerKeyArray.count) {
        [self xhr_removeAllObserver];
        return;
    }
    //获取被监听者的类
    Class superClass = class_getSuperclass([self class]);
    //获取setter方法名
    NSString *selectorName = [NSString stringWithFormat:@"set%@:",key.capitalizedString];
    IMP superSetterIMP = class_getMethodImplementation(superClass, NSSelectorFromString(selectorName));
    //获取被监听key属性的数据类型
    NSString *methodType = [NSString stringWithUTF8String:method_getTypeEncoding(class_getInstanceMethod(superClass, NSSelectorFromString(selectorName)))];
    methodType = [methodType componentsSeparatedByString:@"@0:8"].lastObject;
    NSString *valueType = [methodType substringToIndex:methodType.length - 2];
    
    class_replaceMethod([self class], NSSelectorFromString(selectorName), superSetterIMP, [NSString stringWithFormat:@"v@:%@",valueType].UTF8String);
    [KVOAssistInstance.observerKeyArray removeObject:@{valueType:key}];
    //判断移除后数组是否为空,为空即移除所监听
    if (!KVOAssistInstance.observerKeyArray.count) {
        [self xhr_removeAllObserver];
        return;
    }
}
@end

