//
//  SocketServer.h
//  Socket004
//
//  Created by zhangchao on 16/4/20.
//  Copyright © 2016年 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ConnectBlock)(BOOL success);

@interface SocketServer : NSObject
@property (nonatomic,copy) ConnectBlock block;
/**
 *  判断当前所用的IP地址和端口是否可链接
 *
 *  @param ip      服务器IP地址
 *  @param port    端口号
 *  @param timeOut 超时时间
 *  @param block   用来返回是否可链接(YES/NO)
 */
- (void)connect:(NSString *)ip port:(unsigned int)port timeOut:(int)timeOut block:(ConnectBlock)block;
/**
 *  用来上传数据
 *
 *  @param data 要上传的数据
 */
- (void)writeData:(NSData *)data;
@end
