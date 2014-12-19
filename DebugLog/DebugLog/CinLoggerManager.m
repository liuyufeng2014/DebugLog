/***************************************************
    文件名称：CinLoggerManager.m
    作   者：刘玉锋
    备   注：日志线程实现文件
    创建时间：2013-1-12
    修改历史：
    版权声明：Copyright 2013 . All rights reserved.
 ***************************************************/
#import "CinLoggerManager.h"
#import "SandBoxPath.h"

//定义单例
static CinLoggerManager *sharedGizmoManager = nil;

@implementation CinLoggerManager

@synthesize logMainThread;
@synthesize _signal;
@synthesize _queue;
@synthesize currentCinLogFileName;
@synthesize currentCinLogFileFullPath;

/*******************************************
    函数名称：shareCinLoggerManager
    函数功能：生成单例的方法
    传入参数：N/A
    返回 值： N/A
 ********************************************/
+ (CinLoggerManager*)shareCinLoggerManager
{
    @synchronized(self)
    {
        if (sharedGizmoManager == nil)
        {
            //[[self alloc] init]; // assignment not done here
            sharedGizmoManager = [[CinLoggerManager alloc]init];
        }
    }
    return sharedGizmoManager;
}

/*******************************************
    函数名称：(void)initLogMainThread
    函数功能：初始化线程，锁，数组
    传入参数：N/A
    返回 值： N/A
 ********************************************/
- (void)initLogMainThread
{
   
    if (nil == self.logMainThread)
    {
        _signal = [[NSCondition alloc]init];
        _queue = [[NSMutableArray alloc]init];
        
        //开始创建日志文件
        [self writeLogToSandBoxFile];
        
        logMainThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadProc) object:nil];
        [logMainThread setName:@"logMainThread"];
        [logMainThread start];
    }
}

/*******************************************
    函数名称：writeCinLog
    函数功能：记录日志信息的函数
    传入参数：日志级别，Debug、Info、Warn、Error
    日志内容，格式化字符串
    返回 值： N/A
 ********************************************/
void writeCinLog(const char* function,        // 记录日志所在的函数名称
                 CinLogLevel level,            // 日志级别，Debug、Info、Warn、Error
                 NSString* format,            // 日志内容，格式化字符串
                 ... )                        // 格式化字符串的参数
{
    CinLoggerManager* manager = [CinLoggerManager shareCinLoggerManager]; // CinLoggerManager是单件的日志管理器
    
    [manager initLogMainThread];
    
    // if ( manager.mLogLevel > level || ! format ) // 先检查当前程序设置的日志输出级别。如果这条日志不需要输出，就不用做字符串格式化
    //   return;
    
    va_list args;
    va_start( args, format );
    NSString* str = [ [ NSString alloc ] initWithFormat: format arguments: args ];
    va_end( args );
    NSThread* currentThread = [ NSThread currentThread ];
    NSString* threadName = [ currentThread name ];
    NSString* functionName = [ NSString stringWithUTF8String: function ];
    if ( ! threadName )
        threadName = @"";
    if ( ! functionName )
        functionName = @"";
    if ( ! str )
        str = @"";
    
    // NSDictionary中加入所有需要记录到日志中的信息
    NSDictionary* entry = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                           @"LogEntry", @"Type",
                           str, @"Message",                                                // 日志内容
                           [ NSDate date ], @"Date",                                    // 日志生成时间
                           //[ NSNumber numberWithUnsignedInteger: level ], @"Level",        // 本条日志级别
                           [NSNumber numberWithInt:level],@"Level",
                           
                           threadName, @"ThreadName",                                    // 本条日志所在的线程名称
                           functionName, @"FunctionName",                                // 本条日志所在的函数名称
                           nil ];
    //[str release];
    [manager appendLogEntry:entry];
    //[entry release];
    
}

/*******************************************
    函数名称：allocWithZone:(NSZone *)zone
    函数功能：单例重写allocWithZone方法
    传入参数：N/A
    返回 值： N/A
 ********************************************/
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedGizmoManager == nil)
        {
            sharedGizmoManager = [super allocWithZone:zone];
            
            return sharedGizmoManager;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

/*******************************************
    函数名称：copyWithZone:(NSZone*)zone
    函数功能：单例重写copyWithZone方法
    传入参数：N/A
    返回 值： 当前对象
 ********************************************/
- (id)copyWithZone:(NSZone*)zone
{
    return self;
}





/*******************************************
    函数名称：threadProc
    函数功能：日志根线程函数
    传入参数：N/A
    返回 值： N/A
 ********************************************/
- (void)threadProc
{
    do
    {
       // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        for (int i = 0; i < 20; i++)
        {
            [_signal lock];
            while (0 == [_queue count])
            {
                [_signal wait];
            }
            
            NSArray* items = [NSArray arrayWithArray:_queue];
            
            if ([items count] > 0)
            {
                [self logToDisplay:items];
            }
            
            [_queue removeAllObjects];
            [_signal unlock];
        }
        //[pool release];
    }while(YES);
}

/*******************************************
    函数名称：logToDisplay:(NSArray*)anArray
    函数功能：输出到文件或者控制台
    传入参数：anArray包含日志信息
    返回 值： N/A
 ********************************************/
- (void)logToDisplay:(NSArray*)anArray
{
    for (NSDictionary* logDictionary in anArray)
    {
          NSLog(@"Date=%@,LogLevel-%@-,%@,---message:%@--",[logDictionary objectForKey:@"Date"],\
                [logDictionary objectForKey:@"Level"],[logDictionary objectForKey:@"FunctionName"],\
                [logDictionary objectForKey:@"Message"]);
    }
}

/*******************************************
    函数名称：appendLogEntry:(NSDictionary*)entry
    函数功能：收集日志信息
    传入参数：entry字典封装了日志信息
    返回 值： N/A
 ********************************************/
- (void)appendLogEntry:(NSDictionary*)entry
{
    [_signal lock];
    [_queue addObject:entry];
    [_signal signal];
    [_signal unlock];
}


/*******************************************
    函数名称：writeLogToSandBoxFile
    函数功能：写日志函数
    传入参数：N/A
    返回 值： N/A
 ********************************************/
- (void)writeLogToSandBoxFile
{
    
    NSString *documentsDirectory = [SandBoxPath SandBoxDocumentPath];
    
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    
    self.currentCinLogFileName = fileName;
    
    //当前创建的日志的名字
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    self.currentCinLogFileFullPath = logFilePath;
    
    //定义一个数组，存放files文件名
    NSMutableArray *files = [NSMutableArray arrayWithCapacity:8];
    //定义文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    //定义字典迭代器，迭代document文件夹中的文件
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:documentsDirectory];
    //定义document中文件的文件名
    NSString *filename;
    //删除系统自动生成的.DS_Store文件
    NSString *systemFile = @".DS_Store";
    NSString *systemFilePath = [documentsDirectory stringByAppendingPathComponent:systemFile];
    NSLog(@"%@",systemFilePath);
    if (systemFile) {
        //从数组中删除
        [files removeObject:0];
        //从沙盒路径中删除
        [manager removeItemAtPath:systemFilePath error:nil];
    }
    
    //当本程序运行时，該程序就会自动创建一个日志
    int count = 1;
    while (filename=[direnum nextObject])
    {
        if ([self boolLogFile:fileName])
        {
            count++;
            [files addObject:filename];
            NSLog(@"======%@",filename);
            
        }
    }
    
    //快速便利files文件中的文件名
    for (filename in files)
    {
        NSLog(@"file is %@",filename);
    }
    
    NSLog(@"count = %d",count);
    
    if (count > 7)
    {
        NSLog(@"delete the oldest!");
        //获取第一个日志文件的名字
        NSString *firstFileName = [files objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:firstFileName];
        NSLog(@"fullPath = %@",fullPath);
        //移出第一个日志文件
        BOOL isDelete = [manager removeItemAtPath:fullPath error:nil];
        
        if (isDelete != YES)
        {
            NSLog(@"Unable to delete file");
        }
        else
        {
            NSLog(@"delete the %@ successfully",firstFileName);
        }
    }
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

/*******************************************
    函数名称：boolLogFile
    函数功能：判断是否是支持的日志文件格式
    传入参数：N/A
    返回 值： N/A
 ********************************************/
-(BOOL)boolLogFile:(NSString *)file
{
    //监测日志格式的时候会无法验证.DS_Store
	NSString *pathExtension=[file pathExtension];
    if([pathExtension compare:@"log"
                      options:NSCaseInsensitiveSearch|NSNumericSearch]
       ==NSOrderedSame)
	{
        return YES;
	}
	
	return NO;
}

void handleRootException( NSException* exception )
{
//    NSString* name = [ exception name ];
//    NSString* reason = [ exception reason ];
//    NSArray* symbols = [ exception callStackSymbols ]; // 异常发生时的调用栈
//    NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ]; // 将调用栈拼成输出日志的字符串
//    for ( NSString* item in symbols )
//    {
//        [ strSymbols appendString: item ];
//        [ strSymbols appendString: @"\r\n" ];
//    }
//    
//    // 写日志，级别为ERROR
//    writeCinLog( __FUNCTION__, CinLogLevelError, @"[ Uncaught Exception ]\r\nName: %@, Reason: %@\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]", name, reason, strSymbols );
//    [strSymbols release];
    
    // 这儿必须Hold住当前线程，等待日志线程将日志成功输出，当前线程再继续运行
    //和日志线程同步。
//    blockingFlushLogs( __FUNCTION__);
//    
//    // 写一个文件，记录此时此刻发生了异常。这个挺有用的哦
//    NSDictionary* dict = [ NSDictionary dictionaryWithObjectsAndKeys:
//                          currentCinLogFileName(), @"LogFile",                // 当前日志文件名称
//                          currentCinLogFileFullPath(), @"LogFileFullPath",    // 当前日志文件全路径
//                          [ NSDate date ], @"TimeStamp",                        // 异常发生的时刻
//                          nil ];
//    NSString* path = [ NSString stringWithFormat: @"%@/Documents/", NSHomeDirectory() ];
//    NSString* lastExceptionLog = [ NSString stringWithFormat: @"%@LastExceptionLog.txt", path ];
//    [ dict writeToFile: lastExceptionLog atomically: YES ];
    
}

- (void)threadProc:(NSString*)threadName
{
//    NSThread* current = [NSThread currentThread];
//    [current setName: threadName];
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//    
//    // 一个没有实际作用的NSTimer，确保NSRunLoop不退出。不知道有没有更好的办法啊
//    NSTimer *_dummyTimer = [[NSTimer timerWithTimeInterval: 10.0
//                                             target: self
//                                           selector: @selector(dummyTimerProc:)
//                                           userInfo: nil
//                                            repeats: YES]retain];
//    
//    NSRunLoop *r = [NSRunLoop currentRunLoop];
//    [r addTimer: _dummyTimer forMode: NSDefaultRunLoopMode];
//    @try
//    {
//        // 启动后台线程的NSRunLoop
//        [r run];
//    }
//    @catch (NSException *exception)
//    {
//        //[self handleRootException: exception];
//        // 一旦在线程根上捕捉到未知异常，记录异常后本线程退出
//    }
//    @finally {
//        [ _dummyTimer invalidate ];
//        [ _dummyTimer release ];
//        [ pool release ];
//    }
}


@end




























