//
//  UncaughtExceptionHandler.h
/*
 开发iOS应用，解决Crash问题始终是一个难题。Crash分为两种，一种是由EXC_BAD_ACCESS引起的，
 原因是访问了不属于本进程的内存地址，有可能是访问已被释放的内存；另一种是未被捕获的Objective-C
 异常（NSException），导致程序向自身发送了SIGABRT信号而崩溃。其实对于未捕获的Objective-C
 异常，我们是有办法将它记录下来的，如果日志记录得当，能够解决绝大部分崩溃的问题。这里对于UI线程
 与后台线程分别说明。
 */
//  Created by liu yufeng on 13-1-12.
//  Copyright (c) 2013年 liu yufeng. All rights reserved.


#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject
{
    BOOL dismissed;
}


void HandleException(NSException *exception);
void SignalHandler(int signal);

void InstallUncaughtExceptionHandler(void);


@end










