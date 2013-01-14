//
//  ConnectionCheckSocket.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "ConnectionCheckSocket.h"

@interface ConnectionCheckSocket ()

@property (nonatomic, weak) id<ConnectionCheckSocketDelegate> delegate;

@end

@implementation ConnectionCheckSocket

+ (ConnectionCheckSocket *)instanceWithDelegate:(id<ConnectionCheckSocketDelegate>)aDelegate {
    return [[ConnectionCheckSocket alloc] initWithDelegate:aDelegate];
}

- (ConnectionCheckSocket *)initWithDelegate:(id<ConnectionCheckSocketDelegate>)aDelegate {
    if ((self = [super init])) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[BaseSocket serverURL]];
        self.socket = [[SRWebSocket alloc] initWithURLRequest:request];
        self.socket.delegate = self;
        self.delegate = aDelegate;
        
        NSLog(@"[SRWebSocket] URL: %@", [BaseSocket serverURL]);
    }
    
    return self;
}

- (void)ping {
    // send message as soon as it connects, we're not exchanging much data with server here.
    [self.socket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSString *message = [NSString stringWithFormat:@"{\"event\":\"ping\", \"data\":{\"secret\":\"%@\"}}",
                            [ConnectionCheckSocket secret]];
    [webSocket send:message];
    
    NSLog(@"[SRWebSocket] message: %@", message);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self.delegate socket:webSocket didReceivePong:NO withMessage:[error description]];
    [webSocket closeWithCode:1000 reason:nil];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    [self.delegate socket:webSocket didReceivePong:YES withMessage:message];
    [webSocket closeWithCode:1000 reason:nil];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code
           reason:(NSString *)reason
         wasClean:(BOOL)wasClean {
    NSLog(@"[SRWebSocket] closed: %@", reason);
}

@end
