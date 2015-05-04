//
//  DebugLog.m
//  PM25
//
//  Created by lyf on 15/4/18.
//  Copyright (c) 2015年 liuyufeng. All rights reserved.
//

#import "DebugLog.h"
#import "UncaughtExceptionHandler.h"
#import "CinLoggerManager.h"
#import "SandBoxPath.h"

@implementation DebugLog


+ (void)setDebug:(LogLel)selected;
{
    switch (selected)
    {
        case WriteDebugLogToFile:
        {
            InstallUncaughtExceptionHandler();
#define LOG(fmt, ...) do {NSString* file = [[NSString alloc] initWithFormat:@"%s", __FILE__]; NSLog((@"%@(%d)%s " fmt), [file lastPathComponent], __LINE__, ##__VA_ARGS__,__func__);} while(0)
            //写日志
            //写日志到文件
            CinLoggerManager * logShare = [CinLoggerManager shareCinLoggerManager];
            [logShare writeLogToSandBoxFile];
            
            break;
        }
        case LocalDebugLog:
        {
#define LOG(fmt, ...) do {NSString* file = [[NSString alloc] initWithFormat:@"%s", __FILE__]; NSLog((@"%@(%d)%s " fmt), [file lastPathComponent], __LINE__, ##__VA_ARGS__,__func__);} while(0)
            break;
        }
        case OnlyWriteErrorLogToFile:
        {
            InstallUncaughtExceptionHandler();
#define LOG(fmt, ...) do {NSString* file = [[NSString alloc] initWithFormat:@"%s", __FILE__]; NSLog((@"%@(%d)%s " fmt), [file lastPathComponent], __LINE__, ##__VA_ARGS__,__func__);} while(0)
            break;
        }
        case ReleaseNoLog:
        {
#define NSLog(format,...)
#define LOG(...)
            break;
        }
        default:
        {
            
            break;
        }
    }
    
    
}

@end




