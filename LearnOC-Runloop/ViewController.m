//
//  ViewController.m
//  LearnOC-Runloop
//
//  Created by ZhongMeng on 17/2/15.
//  Copyright © 2017年 RuiZhang. All rights reserved.
//







/*
 
 runloop 学习
 */

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSPort *emptyPort;
@property (nonatomic, strong) NSThread *athread;
@property (nonatomic, assign) BOOL keepRuning;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
 
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self memoryTest];
    
    [self runloopTest];
    
}


#pragma mark ---------------------内存占用测试
- (void)memoryTest {

    for (int i = 0; i < 100000; ++i) {
        //
        NSThread *athread = [[NSThread alloc] initWithTarget:self selector:@selector(beginRun) object:nil];
        
        [athread start];
        
        [self performSelector:@selector(stopTheThread) onThread:athread withObject:nil waitUntilDone:YES];
    }

}

- (void)beginRun {

    @autoreleasepool {
        NSLog(@"current thread = %@", [NSThread currentThread]);
        
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        
        if (!self.emptyPort) {
            self.emptyPort = [NSMachPort port];
            
        }
        
        [runloop addPort:self.emptyPort forMode:NSDefaultRunLoopMode];
        
        CFRunLoopRun();
        
        
        /*
         不可取:
         //[runloop run];
         //[runloop runMode:NSRunloopCommonModes beforeDate:[NSDate distantFuture]];
         */
    }
    
}



- (void)stopTheThread {

    CFRunLoopStop(CFRunLoopGetCurrent());
    
    NSThread *athread = [NSThread currentThread];
    
    [athread cancel];

}



#pragma mark ------------- runloop 启动与退出测试

- (void)runloopTest {
    
    //点击按钮后关闭 runloop
    UIButton *stopButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    [stopButton setTitle:@"Stop Timer" forState:UIControlStateNormal];
    [stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:stopButton];
    
    [stopButton addTarget:self action:@selector(stopButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.keepRuning = YES;
    
    self.athread = [[NSThread alloc] initWithTarget:self selector:@selector(singleThread) object:nil];
    
    [self.athread start];
    
    [self performSelector:@selector(printSomething) onThread:self.athread withObject:nil waitUntilDone:YES];
    
}


- (void)singleThread {

    @autoreleasepool {
        //
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        if (!self.emptyPort) {
            self.emptyPort = [NSMachPort port];
            
        }
        [runloop addPort:self.emptyPort forMode:NSDefaultRunLoopMode];
        
        CFRunLoopRun();
        
    }

}


- (void)printSomething {
    
    NSLog(@"current thread = %@", [NSThread currentThread]);
    [self performSelector:@selector(printSomething) withObject:nil afterDelay:1];
}



#pragma mark------------------------- 点击按钮退出
- (void)stopButtonClicked:(id)sender {
    
    [self performSelector:@selector(stopRunloop) onThread:self.athread withObject:nil waitUntilDone:YES];
}

- (void)stopRunloop {
    //self.keepRuning = NO;
    CFRunLoopStop(CFRunLoopGetCurrent());
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
