//
//  NSObject+Property.m
//  OC KnowledgeSet - Runtime
//
//  Created by ZhongMeng on 17/2/21.
//  Copyright © 2017年 RuiZhang. All rights reserved.
//

#import "NSObject+Property.h"

#import <objc/message.h>




// 定义关联的key
static const char *key = "zrname";


@implementation NSObject (Property)




- (NSString *)zrname {
    
    // 根据关联的key，获取关联的值。
    return objc_getAssociatedObject(self, key);
}


- (void)setZrname:(NSString *)zrname {
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    objc_setAssociatedObject(self, key, zrname, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
