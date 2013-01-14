//
//  ActionSocket.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSocket.h"
#import "Channel.h"

typedef enum {
    SocketActionUndefined,
    SocketActionPlayPause,
    SocketActionStop,
    SocketActionClose
} SocketAction;

@protocol ActionSocketDelegate <NSObject>

- (void)socketDidOpen:(SRWebSocket *)aSocket;
- (void)socketDidSendAction:(NSString *)aMessage;
- (void)socketDidFailToSendAction:(NSError *)anError;

@end

@interface ActionSocket : BaseSocket <SRWebSocketDelegate>

+ (ActionSocket *)instanceWithDelegate:(id<ActionSocketDelegate>)aDelegate;
- (void)open;
- (void)sendAction:(SocketAction)anAction forChannel:(Channel *)aChannel;

@end
