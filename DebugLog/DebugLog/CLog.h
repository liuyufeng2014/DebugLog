/***************************************************
    文件名称：CLog.h
    作   者：刘玉锋
    备   注：日志头文件
    创建时间：2012-11-29
    修改历史：
    版权声明：Copyright 2011 . All rights reserved.
 ***************************************************/

/*
 该部分宏定义的功能是取消程序当中所有NSLog写的注释
 */

//#ifdef DEBUG
//#define CLog(format,...) NSLog(format,##__VA_ARGS__)
//#define NSLog(format,...) 
//#else
//#define NSLog(format,...)
//#endif

/*
<<<<<<< HEAD
<<<<<<< HEAD
 hello
 该部分宏定义的功能配合写日志函数可以创建日志。
=======
 创建日志
 创建日志
=======
 
>>>>>>> origin/Developer
 创建日志
 该部分宏定义的功能配合写日志函数可以创建日志。--------
>>>>>>> Developer
 */

//#ifndef DEBUG
//#define NSLog(format,...)
#define LOG(fmt, ...) do {NSString* file = [[NSString alloc] initWithFormat:@"%s", __FILE__]; NSLog((@"%@(%d)%s " fmt), [file lastPathComponent], __LINE__, ##__VA_ARGS__,__func__);} while(0)

//
//
//#define LOG_METHOD  NSLog(@"%s", __func__)
//#define LOG_CMETHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
//#define COUNT(p)    NSLog(@"%s(%d): count = %d\n", __func__, __LINE__, [p retainCount]);
//
#define LOG_TRACE(x) do{ printf x; putchar('\n'); fflush(stdout);} while (0)
//
//
//#else
//#define NSLog(format,...)
//#define LOG(...)
//#define LOG_METHOD
//#define LOG_CMETHOD
//#define COUNT(p)
//#define LOG_TRACE(x)
//
//#endif


