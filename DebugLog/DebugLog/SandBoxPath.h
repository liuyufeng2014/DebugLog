/***************************************************
    文件名称：SandBoxPath.h
    作   者：刘玉锋
    备   注：获取沙盒路径头文件
    创建时间：2012-11-29
    修改历史：
    版权声明：Copyright 2011 . All rights reserved.
 ***************************************************/

#import <Foundation/Foundation.h>

@interface SandBoxPath : NSObject



/*******************************************
    函数名称：SandBoxDocumentPath
    函数功能：获取Document的路径
    传入参数：N/A
    返回 值：Document的路径
 ********************************************/
+ (NSString*)SandBoxDocumentPath;

@end
