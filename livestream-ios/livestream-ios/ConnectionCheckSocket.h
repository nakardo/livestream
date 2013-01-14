//
//  ConnectionCheckSocket.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSocket.h"

@protocol ConnectionCheckSocketDelegate <NSObject>

- (void)socket:(SRWebSocket *)aSocket didReceivePong:(BOOL)pong withMessage:(NSString *)aMessage;

@end

@interface ConnectionCheckSocket : BaseSocket <SRWebSocketDelegate>

+ (ConnectionCheckSocket *)instanceWithDelegate:(id<ConnectionCheckSocketDelegate>)aDelegate;
- (void)ping;

@end
