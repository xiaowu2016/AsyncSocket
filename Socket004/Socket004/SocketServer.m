//
//  SocketServer.m
//  Socket004
//
//  Created by zhangchao on 16/4/20.
//  Copyright © 2016年 zhangchao. All rights reserved.
//

#import "SocketServer.h"
#import <AsyncSocket.h>

#define kLOGIN @"login"
#define kERROR @"error"

@interface SocketServer ()
@property (nonatomic,strong) AsyncSocket *socket;
@end

@implementation SocketServer

- (AsyncSocket *)socket
{
    if(!_socket)
    {
        _socket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    return _socket;
}

- (void)connect:(NSString *)ip port:(unsigned int)port timeOut:(int)timeOut block:(ConnectBlock)block
{
    _block = block;
    NSError *err = nil;
    if(![self.socket connectToHost:ip onPort:port error:&err])
    {
        block(NO);
    }
}

- (void)writeData:(NSData *)data
{
    [self.socket writeData:data withTimeout:30 tag:1];
}

#pragma mark AsyncSocketDelegate
//链接成功
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    if(_block)
    {
        _block(YES);
    }
}

//上传数据给服务器
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"写入成功");
    [self.socket readDataToLength:8 withTimeout:30 tag:1];
}

//从服务器读取数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if(tag == 1)
    {
        NSLog(@"读取成功");
        //使用通知来传值
        [[NSNotificationCenter defaultCenter] postNotificationName:kLOGIN object:data];
    }
}

//链接出错
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    if(_block)
    {
        _block(NO);
    }
    [self.socket disconnect];
}


- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"已经断开链接");
}

@end
