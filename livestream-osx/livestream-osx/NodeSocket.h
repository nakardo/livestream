//
//  NodeSocket.h
//  livestream-osx
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

typedef enum {
    SocketActionUndefined,
    SocketActionPlayPause,
    SocketActionStop,
    SocketActionClose
} SocketAction;

@protocol NodeSocketDelegate <NSObject>

- (void)socketDidOpen:(SRWebSocket *)aSocket;
- (void)socket:(SRWebSocket *)aSocket didRegister:(BOOL)isRegistered withMessage:(NSString *)aMessage;
- (void)socket:(SRWebSocket *)aSocket didReceiveAction:(SocketAction)anAction withStreamURL:(NSString *)anURL;

@end

extern NSString * const kClientSecret;

@interface NodeSocket : NSObject <SRWebSocketDelegate>

+ (NodeSocket *)instanceWithDelegate:(id<NodeSocketDelegate>)aDelegate;
- (void)open;
- (void)doRegister;

@end
