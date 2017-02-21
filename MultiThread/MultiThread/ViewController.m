//
//  ViewController.m
//  MultiThread
//
//  Created by ZhongMeng on 17/2/21.
//  Copyright © 2017年 RuiZhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    //***GCD
    //**队列  任务
    
    
    
    
    
    //**创建队列
    
    
    
    //串行队列
    dispatch_queue_t queue1 = dispatch_queue_create("", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);
    
    //并行队列
    dispatch_queue_t queue3 = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT);
    
    //全局并行队列
    dispatch_queue_t queue4 = dispatch_get_global_queue(0, 0);
    
    
    
    
    
    
    //**创建任务
    //同步任务： 会阻塞当前线程
    //异步任务： 不会阻塞当前线程
    //dispatch_sync(0, ^{
        //
    //    NSLog(@"%@", [NSThread currentThread]);
    //});
    
    
    
    
//**示例一
    
    //以下代码在主线程调用，结果是什么？
    /*NSLog("之前 - %@", NSThread.currentThread());
    
    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
        NSLog("sync - %@", NSThread.currentThread());
        
    })
    
    NSLog("之后 - %@", NSThread.currentThread())*/
    
    
    /*
     答案：
     只会打印第一句：之前 - <NSThread: 0x7fb3a9e16470>{number = 1, name = main} ，然后主线程就卡死了
     解释：
     同步任务会阻塞当前线程，然后把 Block 中的任务放到指定的队列中执行，只有等到 Block 中的任务完成后才会让当前线程继续往下运行。
     那么这里的步骤就是：打印完第一句后，dispatch_sync 立即阻塞当前的主线程，然后把 Block 中的任务放到 main_queue 中，可是 main_queue 中的任务会被取出来放到主线程中执行，但主线程这个时候已经被阻塞了，所以 Block 中的任务就不能完成，它不完成，dispatch_sync 就会一直阻塞主线程，这就是死锁现象。导致主线程一直卡死。
     */
    
    
    
    
    
    
//**示例二
    
    //以下代码会产生什么结果？
    /*
     let queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL)
     
     NSLog("之前 - %@", NSThread.currentThread())
     
     dispatch_async(queue, { () -> Void in
     
     NSLog("sync之前 - %@", NSThread.currentThread())
     
     dispatch_sync(queue, { () -> Void in
     
     NSLog("sync - %@", NSThread.currentThread())
     
     })
     
     NSLog("sync之后 - %@", NSThread.currentThread())
     
     })
     
     NSLog("之后 - %@", NSThread.currentThread())
     */
    
    
    //答案
    //sync - %@ 和 sync之后 - %@ 没有被打印出来！
    
    //分析：
    //我们按执行顺序一步步来哦：
    
    //1.使用 DISPATCH_QUEUE_SERIAL 这个参数，创建了一个 串行队列。
    //2.打印出 之前 - %@ 这句。
    //3.dispatch_async 异步执行，所以当前线程不会被阻塞，于是有了两条线程，一条当前线程继续往下打印出 之后 - %@这句, 另一台执行 Block 中的内容打印 sync之前 - %@ 这句。因为这两条是并行的，所以打印的先后顺序无所谓。
    //4.注意，高潮来了。现在的情况和上一个例子一样了。dispatch_sync同步执行，于是它所在的线程会被阻塞，一直等到 sync 里的任务执行完才会继续往下。于是 sync 就高兴的把自己 Block 中的任务放到 queue 中，可谁想 queue 是一个串行队列，一次执行一个任务，所以 sync 的 Block 必须等到前一个任务执行完毕，可万万没想到的是 queue 正在执行的任务就是被 sync 阻塞了的那个。于是又发生了死锁。所以 sync 所在的线程被卡死了。剩下的两句代码自然不会打印。
    
    
    
    
    
//**队列组
    //队列组可以将很多队列添加到一个组里，这样做的好处是，当这个组里所有的任务都执行完了，队列组会通过一个方法通知我们。
    
    //1.创建队列组
    dispatch_queue_t group1 = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue11 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    
    
    //3.多次使用队列组的方法执行任务, 只有异步方法
    //3.1.执行3次循环
    dispatch_group_async(group1, queue11, ^{
        for (NSInteger i = 0; i < 3; i++) {
            NSLog(@"group-01 - %@", [NSThread currentThread]);
        }
    });
    
    //3.2.主队列执行8次循环
    dispatch_group_async(group1, dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 8; i++) {
            NSLog(@"group-02 - %@", [NSThread currentThread]);
        }
    });
    
    //3.3.执行5次循环
    dispatch_group_async(group1, queue11, ^{
        for (NSInteger i = 0; i < 5; i++) {
            NSLog(@"group-03 - %@", [NSThread currentThread]);
        }
    });
    
    //4.都完成后会自动通知
    dispatch_group_notify(group1, dispatch_get_main_queue(), ^{
        NSLog(@"完成 - %@", [NSThread currentThread]);
    });
    
    
    
    
    
    
    
    
    
    
//****NSOperation和NSOperationQueue
    
    //NSOperation 是苹果公司对 GCD 的封装，完全面向对象，所以使用起来更好理解。 大家可以看到 NSOperation 和 NSOperationQueue 分别对应 GCD 的 任务 和 队列 。
    
    
    //1.将要执行的任务封装到一个 NSOperation 对象中。
    //2.将此任务添加到一个 NSOperationQueue 对象中。
    
    
    
//**添加任务
    //NSOperation 只是一个抽象类，所以不能封装任务。但它有 2 个子类用于封装任务。分别是：NSInvocationOperation 和 NSBlockOperation 。
    
    //1.创建NSInvocationOperation对象
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    //2.开始执行
    [operation1 start];
    
    //1.创建NSBlockOperation对象
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    //2.开始任务
    [operation2 start];
    
    
    
    
    
    
    //NSBlockOperation 还有一个方法：addExecutionBlock: ，通过这个方法可以给 Operation 添加多个执行 Block。这样 Operation 中的任务 会并发执行，它会 在主线程和其它的多个线程 执行这些任务
    
    //1.创建NSBlockOperation对象
    NSBlockOperation *operation11 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    //添加多个Block
    for (NSInteger i = 0; i < 5; i++) {
        [operation11 addExecutionBlock:^{
            NSLog(@"第%ld次：%@", i, [NSThread currentThread]);
        }];
    }
    
    //2.开始任务
    [operation11 start];
    
    
    
    
    
    
//**创建队列
    
    //我们可以调用一个 NSOperation 对象的 start() 方法来启动这个任务，但是这样做他们默认是 同步执行 的。就算是 addExecutionBlock 方法，也会在 当前线程和其他线程 中执行，也就是说还是会占用当前线程。这是就要用到队列 NSOperationQueue 了。而且，按类型来说的话一共有两种类型：主队列、其他队列。只要添加到队列，会自动调用任务的 start() 方法
    
    //主队列
    
    //NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    //其他队列
    
    //1.创建一个其他队列
    NSOperationQueue *queue111 = [[NSOperationQueue alloc] init];
    
    //2.创建NSBlockOperation对象
    NSBlockOperation *operation111 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    //3.添加多个Block
    for (NSInteger i = 0; i < 5; i++) {
        [operation111 addExecutionBlock:^{
            NSLog(@"第%ld次：%@", i, [NSThread currentThread]);
        }];
    }
    
    //4.队列添加任务
    [queue111 addOperation:operation111];

    
    
    //大家将 NSOperationQueue 与 GCD的队列 相比较就会发现，这里没有串行队列，那如果我想要10个任务在其他线程串行的执行怎么办？
    //NSOperationQueue 有一个参数 maxConcurrentOperationCount 最大并发数，用来设置最多可以让多少个任务同时执行。当你把它设置为 1 的时候，他不就是串行了嘛！
    
    //NSOperationQueue 还有一个添加任务的方法，- (void)addOperationWithBlock:(void (^)(void))block; ，这是不是和 GCD 差不多？这样就可以添加一个任务到队列中了，十分方便。
    
    
    
    //NSOperation 有一个非常实用的功能，那就是添加依赖。比如有 3 个任务：A: 从服务器上下载一张图片，B：给这张图片加个水印，C：把图片返回给服务器。这时就可以用到依赖了:
    
    
    //1.任务一：下载图片
    NSBlockOperation *operation1111 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    //2.任务二：打水印
    NSBlockOperation *operation2222 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"打水印   - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    //3.任务三：上传图片
    NSBlockOperation *operation3333 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"上传图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    //4.设置依赖
    [operation2222 addDependency:operation1111];      //任务二依赖任务一
    [operation3333 addDependency:operation2222];      //任务三依赖任务二
    
    //5.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation3333, operation2222, operation1111] waitUntilFinished:NO];
    
    //注意：不能添加相互依赖，会死锁，比如 A依赖B，B依赖A。
    
    //可以使用 removeDependency 来解除依赖关系。
    
    //可以在不同的队列之间依赖，反正就是这个依赖是添加到任务身上的，和队列没关系。
    
    
    
    
    
    
    
    
    
    
    
    
    
////****线程同步
    //所谓线程同步就是为了防止多个线程抢夺同一个资源造成的数据安全问题，所采取的一种措施。
    
    //**互斥锁
    //给需要同步的代码块加一个互斥锁，就可以保证每次只有一个线程访问此代码块。
    @synchronized(self) {
        //需要执行的代码块
    }
    
    
    //**同步执行
    
    //GCD
    //需要一个全局变量queue，要让所有线程的这个操作都加到一个queue中
    /*
    dispatch_sync(queue, ^{
        NSInteger ticket = lastTicket;
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"%ld - %@",ticket, [NSThread currentThread]);
        ticket -= 1;
        lastTicket = ticket;
    });
     */
    
    
    //NSOperation & NSOperationQueue
    //重点：1. 全局的 NSOperationQueue, 所有的操作添加到同一个queue中
    //       2. 设置 queue 的 maxConcurrentOperationCount 为 1
    //       3. 如果后续操作需要Block中的结果，就需要调用每个操作的waitUntilFinished，阻塞当前线程，一直等到当前操作完成，才允许执行后面的。waitUntilFinished 要在添加到队列之后！
    /*
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSInteger ticket = lastTicket;
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%ld - %@",ticket, [NSThread currentThread]);
        ticket -= 1;
        lastTicket = ticket;
    }];
    
    [queue addOperation:operation];
    
    [operation waitUntilFinished];
     
     */
    
    //后续要做的事
    
    
    
    
    //**延迟执行
    //1
    // 3秒后自动调用self的run:方法，并且传递参数：@"abc"
    [self performSelector:@selector(run:) withObject:@"abc" afterDelay:3];
    //2
    // 创建队列
    dispatch_queue_t queuea = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 设置延时，单位秒
    double delay = 3;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), queuea, ^{
        // 3秒后需要执行的任务
    });
    //3
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(run:) userInfo:@"abc" repeats:NO];
    
    
    
    
    
    
    
    //**从其他线程回到主线程的方法
    
    //1. NSThread
    
    [self performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:NO];
    
    //2. GCD
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    
    //3. NSOperationQueue
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
    }];
    
}




























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
