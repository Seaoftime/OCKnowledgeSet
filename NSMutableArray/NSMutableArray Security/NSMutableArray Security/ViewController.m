//
//  ViewController.m
//  NSMutableArray Security
//
//  Created by ZhongMeng on 17/2/27.
//  Copyright © 2017年 RuiZhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    
    /*
     首先要弄明白为什么要实现一个线程安全的NSMutabeArray？线程安全的NSMutabeArray只是个手段，真正的目的是什么？为了实现消息队列？网络操作？还是其它？分析之后，绝大多数情况下，可以将问题简化。
     */
    
    /*
     简单的方式，是用一个类比如叫ThreadSafetyArray，将NSMutabeArray包装起来。之后ThreadSafetyArray提供插入和删除的函数。而要遍历，就提供一个walk函数，walk函数传入一个block。
     */
    
    /*
     ThreadSafetyArray的所有函数，使用锁或者diapatch_queue保证线程安全。这样你并不需要让NSMutabeArray线程安全，只需要让ThreadSafetyArray线程安全。
     */
    
    
    
    
    
   
    /*
    @interface ThreadSafetyArray : NSObject {
        
    @private
        NSMutableArray* _array;
    }
    
    - (void)addObject:(NSObject*)obj;
    - (void)walk:(void (^)(NSObject*))walkfun;
    
    @end
    
    
    @implementation ThreadSafetyArray
    
    - (id)init {
        self = [super init];
        if (self) {
            _array = [[NSMutableArray alloc] init];
        }
        return self;
    }
    
    - (void)addObject:(NSObject*)obj {
        @synchronized(self) {
            [_array addObject:obj];
        }
    }
    
    - (void)walk:(void (^)(NSObject*))walkfun {
        @synchronized(self) {
            for (NSObject* obj in _array) {
                walkfun(obj);
            }
        }
    }
    
    @end
    
     */
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
