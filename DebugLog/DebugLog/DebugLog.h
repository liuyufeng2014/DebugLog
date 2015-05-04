//
//  DebugLog.h
//  PM25
//
//  Created by lyf on 15/4/18.
//  Copyright (c) 2015年 liuyufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

//日志信息结构体
typedef enum selected
{
    WriteDebugLogToFile,          //写日志文件，本地看不到日志
    LocalDebugLog,                //本地日志模式
    OnlyWriteErrorLogToFile,      //只写崩溃日志到文件，本地显示日志
    ReleaseNoLog                  //发布模式，不写日志文件
}LogLel;




@interface DebugLog : NSObject


+ (void)setDebug:(LogLel)selected;


@end


