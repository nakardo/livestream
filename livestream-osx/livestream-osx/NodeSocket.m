//
//  NodeSocket.m
//  livestream-osx
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "NodeSocket.h"

@interface NodeSocket ()

@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, weak) id<NodeSocketDelegate> delegate;

@end

static NSString * const kServerURL = @"ws://localhost:8080";
NSString * const kClientSecret = @"mogambo";

@implementation NodeSocket

+ (SocketAction)actionForResponseData:(NSDictionary *)data {
    NSString *action = [data objectForKey:@"action"];
    if ([@"play_pause" isEqualToString:action]) {
        return SocketActionPlayPause;
    } else if ([@"stop" isEqualToString:action]) {
        return SocketActionStop;
    } else if ([@"close" isEqualToString:action]) {
        return SocketActionClose;
    }
    
    return SocketActionUndefined;
}

+ (NodeSocket *)instanceWithDelegate:(id<NodeSocketDelegate>)aDelegate {
    return [[NodeSocket alloc] initWithDelegate:aDelegate];
}

- (void)dealloc {
    [self.socket closeWithCode:1000 reason:nil]; self.socket = nil;
}

- (NodeSocket *)initWithDelegate:(id<NodeSocketDelegate>)aDelegate {
    if ((self = [super init])) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kServerURL]];
        self.socket = [[SRWebSocket alloc] initWithURLRequest:request];
        self.socket.delegate = self;
        self.delegate = aDelegate;
        
        NSLog(@"[SRWebSocket] URL: %@", kServerURL);
    }
    
    return self;
}

- (void)open {
    [self.socket open];
}

- (void)doRegister {
    NSString *message = [NSString stringWithFormat:@"{\"event\":\"register\", \"data\":{\"secret\":\"%@\"}}",
                            kClientSecret];
    [self.socket send:message];
    
    NSLog(@"[SRWebSocket] message: %@", message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    [self.delegate socketDidOpen:webSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self.delegate socket:webSocket didRegister:NO withMessage:[error description]];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    BOOL isSuccessful = NO;
    NSData *responseData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    if (!error) {
        NSDictionary *dataDict = [response objectForKey:@"data"];
        
        NSString *event = [response objectForKey:@"event"];
        if ([@"register" isEqualToString:event]) {
            NSNumber *status = [dataDict objectForKey:@"status"];
            if ([status intValue] > -1) {
                isSuccessful = YES;
            }
            
            [self.delegate socket:webSocket didRegister:isSuccessful withMessage:message];
        } else if ([@"action" isEqualToString:event]) {
            SocketAction action = [NodeSocket actionForResponseData:dataDict];
            NSString *streamURL = [dataDict objectForKey:@"url"];
            [self.delegate socket:webSocket didReceiveAction:action withStreamURL:streamURL];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code
           reason:(NSString *)reason
         wasClean:(BOOL)wasClean {
    NSLog(@"[SRWebSocket] closed: %@", reason);
}

@end
