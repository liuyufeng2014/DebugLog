/***************************************************
    文件名称：CinLoggerManager.h
    作   者：刘玉锋
    备   注：日志线程头文件
    创建时间：2013-1-12
    修改历史：
    版权声明：Copyright 2013 . All rights reserved.
 ***************************************************/
#import <Foundation/Foundation.h>

//定义日志信息宏
#define CinLogLevelInfo    0
#define CinLogLevelDebug   1
#define CinLogLevelWarning 2
#define CinLogLevelError   3

#define FeLogDebug(format,...)         writeCinLog(__FUNCTION__,CinLogLevelDebug,format,##__VA_ARGS__)
#define FeLogInfo(format,...)          writeCinLog(__FUNCTION__,CinLogLevelInfo,format,##__VA_ARGS__)
#define FeLogWarn(format,...)          writeCinLog(__FUNCTION__,CinLogLevelWarning,format,##__VA_ARGS__)
#define FeLogError(format,...)         writeCinLog(__FUNCTION__,CinLogLevelError,format,##__VA_ARGS__)

//日志信息结构体
typedef enum Level
{
    LogLevelInfo,
    LogLevelDebug,
    LogLevelWarning,
    LogLevelError
}CinLogLevel;



@interface CinLoggerManager : NSObject
{
    //日志线程
    NSThread* logMainThread;
    //线程锁
    NSCondition* _signal;
    //存储日志信息对象的数组
    NSMutableArray* _queue;
    //当前日志文件的文件名
    NSString* currentCinLogFileName;
    //当前日志文件的全路径
    NSString* currentCinLogFileFullPath;
}

@property(nonatomic,retain) NSMutableArray* _queue;
@property(nonatomic,retain) NSThread* logMainThread;
@property(nonatomic,retain) NSCondition* _signal;
@property(nonatomic,retain) NSString* currentCinLogFileName;
@property(nonatomic,retain) NSString* currentCinLogFileFullPath;

/*******************************************
    函数名称：(void)initLogMainThread
    函数功能：初始化线程，锁，数组
    传入参数：N/A
    返回 值： N/A
 ********************************************/
- (void)initLogMainThread;

/*******************************************
    函数名称：appendLogEntry:(NSDictionary*)entry
    函数功能：收集日志信息
    传入参数：entry字典封装了日志信息
    返回 值： N/A
 ********************************************/
- (void)appendLogEntry:(NSDictionary*)entry;

/*******************************************
    函数名称：logToDisplay:(NSArray*)anArray
    函数功能：输出到文件或者控制台
    传入参数：anArray包含日志信息
    返回 值： N/A
 ********************************************/
- (void)logToDisplay:(NSArray*)anArray;

/*******************************************
    函数名称：writeCinLog
    函数功能：记录日志信息的函数
    传入参数：日志级别，Debug、Info、Warn、Error
            日志内容，格式化字符串
    返回 值： N/A
 ********************************************/
void writeCinLog(const char* function,        
                 CinLogLevel level,           
                 NSString* format,           
                 ... );                      

/*******************************************
    函数名称：shareCinLoggerManager
    函数功能：生成单例的方法
    传入参数：N/A
    返回 值： N/A
 ********************************************/
+ (CinLoggerManager*)shareCinLoggerManager;

/*******************************************
    函数名称：allocWithZone:(NSZone *)zone
    函数功能：单例重写allocWithZone方法
    传入参数：N/A
    返回 值： N/A
 ********************************************/
+ (id)allocWithZone:(NSZone *)zone;

/*******************************************
    函数名称：copyWithZone:(NSZone*)zone
    函数功能：单例重写copyWithZone方法
    传入参数：N/A
    返回 值： 当前对象
 ********************************************/
- (id)copyWithZone:(NSZone*)zone;


/*******************************************
    函数名称：threadProc
    函数功能：日志根线程函数
    传入参数：N/A
    返回 值： N/A
 ********************************************/
- (void)threadProc;

/*******************************************
    函数名称：writeLogToSandBoxFile
    函数功能：写日志函数
    传入参数：N/A
    返回 值： N/A
 ********************************************/
- (void)writeLogToSandBoxFile;

/*******************************************
    函数名称：boolLogFile
    函数功能：判断是否是支持的日志文件格式
    传入参数：N/A
    返回 值： N/A
 ********************************************/
-(BOOL)boolLogFile:(NSString *)file;

@end




