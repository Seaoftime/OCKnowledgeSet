//
//  ViewController.m
//  OC KnowledgeSet - Runtime
//
//  Created by ZhongMeng on 17/2/21.
//  Copyright © 2017年 RuiZhang. All rights reserved.
//

#import "ViewController.h"


#import <objc/message.h>
#import "ZRPerson.h"
#import "NSObject+Property.h"


/*
 一、runtime简介
 
 runtime简称运行时。OC就是运行时机制，也就是在运行时候的一些机制，其中最主要的是消息机制。
 
 对于C语言，函数的调用在编译的时候会决定调用哪个函数。
 对于OC的函数，属于动态调用过程，在编译的时候并不能决定真正调用哪个函数，只有在真正运行的时候才会根据函数的名称找到对应的函数来调用。
 
 事实证明：
 在编译阶段，C语言调用未实现的函数就会报错。

 在编译阶段，OC可以调用任何函数，即使这个函数并未实现，只要声明过就不会报错。
 
 */


/*
 二、runtime作用
 
 1.发送消息
 方法调用的本质，就是让对象发送消息。
 objc_msgSend,只有对象才能发送消息，因此以objc开头.
 //
 Person *p = [[Person alloc] init];
 [p eat];
 // 本质：让对象发送消息
 objc_msgSend(p, @selector(eat));
 
 消息机制原理：对象根据方法编号SEL去映射表(有一个 method list)查找对应的方法实现(IMP)
 
 
 */
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    //2.交换方法
    //开发使用场景:系统自带的方法功能不够，给系统自带的方法扩展一些功能，并且保持原有的功能。
    //方式一:继承系统的类，重写方法.
    //方式二:使用runtime, 交换方法.
    // 交换方法
    
    // 获取method1方法地址
    //Method method1 = class_getClassMethod(self, @selector(getmethod1));
    
    // 获取method2方法地址
    //Method method2 = class_getClassMethod(self, @selector(getmethod2));
    // 交换方法地址，相当于交换实现方式
    //method_exchangeImplementations(method1, method2);
    
    
    
    
    
    //3.动态添加方法
    //开发使用场景：如果一个类方法非常多，加载类到内存的时候也比较耗费资源，需要给每个方法生成映射表，可以使用动态给某个类，添加方法解决。
    //经典面试题：有没有使用performSelector，其实主要想问你有没有动态添加过方法。
    //ZRPerson *p = [[ZRPerson alloc] init];
    
    // 默认person，没有实现eat方法，可以通过performSelector调用，但是会报错。
    // 动态添加方法就不会报错
    //[p performSelector:@selector(eat)];
    
    
    
    
    
    
    
    //4.给分类添加属性
    //原理：给一个类声明属性，其实本质就是给这个类添加关联
    
    // 给系统NSObject类动态添加属性zrname
    //NSObject *objc = [[NSObject alloc] init];
    //objc.zrname = @"seaoftime";
    //NSLog(@"%@",objc.zrname);
    
    
    
    
    
    
    
    
    
    
    //5.字典转模型
    //字典转模型的方式一：KVC
    
    //必须保证，模型中的属性和字典中的key一一对应。
    //模型中的属性和字典的key不一一对应，系统就会调用setValue:forUndefinedKey:报错。
    //重写对象的setValue:forUndefinedKey:,把系统的方法覆盖，就能继续使用KVC，字典转模型了。
    
    
    //字典转模型的方式二：Runtime
    //思路：利用运行时，遍历模型中所有属性，根据模型的属性名，去字典中查找key，取出对应的值，给模型的属性赋值。
    
    
    //MJExtention的底层实现是遍历模型中的属性名,然后根据模型的属性名,再去取字典中的对应的value
    
    
    
    
    // 获取类中的所有成员属性
    //Ivar *ivarList = class_copyIvarList(self, &count);
    //ivarList指针应该需要free
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
