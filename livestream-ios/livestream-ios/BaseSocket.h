//
//  BaseSocket.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@interface BaseSocket : NSObject

@property (nonatomic, strong) SRWebSocket *socket;

+ (NSURL *)serverURL;
+ (NSString *)secret;

@end
