//
//  EventSocket.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "ActionSocket.h"

@interface ActionSocket ()

@property (nonatomic, weak) id<ActionSocketDelegate> delegate;

@end

@implementation ActionSocket

+ (NSString *)stringForAction:(SocketAction)action {
    switch (action) {
        case SocketActionPlayPause:
            return @"play_pause"; break;
        case SocketActionStop:
            return @"stop"; break;
        case SocketActionClose:
            return @"close"; break;
        default:
            break;
    }
    
    return nil;
}

+ (ActionSocket *)instanceWithDelegate:(id<ActionSocketDelegate>)aDelegate {
    return [[ActionSocket alloc] initWithDelegate:aDelegate];
}

- (ActionSocket *)initWithDelegate:(id<ActionSocketDelegate>)aDelegate {
    if ((self = [super init])) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[BaseSocket serverURL]];
        self.socket = [[SRWebSocket alloc] initWithURLRequest:request];
        self.socket.delegate = self;
        self.delegate = aDelegate;
        
        NSLog(@"[SRWebSocket] URL: %@", [BaseSocket serverURL]);
    }
    
    return self;
}

- (void)open {
    [self.socket open];
}

- (void)sendAction:(SocketAction)anAction forChannel:(Channel *)aChannel {
    NSString *message = nil;
    message = [NSString stringWithFormat:@"{\"event\":\"action\", \"data\":{\"secret\":\"%@\", \"action\":\"%@\", \"url\":\"%@\"}}",
                    [BaseSocket secret], [ActionSocket stringForAction:anAction], aChannel.streamURL];
    [self.socket send:message];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    [self.delegate socketDidOpen:webSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self.delegate socketDidFailToSendAction:error];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    [self.delegate socketDidSendAction:message];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code
           reason:(NSString *)reason
         wasClean:(BOOL)wasClean {
    NSLog(@"[SRWebSocket] closed: %@", reason);
}

@end
