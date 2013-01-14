//
//  BaseSocket.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "BaseSocket.h"
#import "AppDelegate.h"

@implementation BaseSocket

+ (NSURL *)serverURL {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [NSURL URLWithString:delegate.serverURL];
}

+ (NSString *)secret {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.secret;
}

@end
