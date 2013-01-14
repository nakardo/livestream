//
//  Channel.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "Channel.h"

@interface Channel ()

@property (nonatomic, copy, readwrite) NSString *fullName;
@property (nonatomic, copy, readwrite) NSString *shortName;

@end

@implementation Channel

+ (Channel *)channelWithName:(NSString *)aName andShortName:(NSString *)aShortName {
    return [[self alloc] initWithName:aName andShortName:aShortName];
}

- (Channel *)initWithName:(NSString *)aName andShortName:(NSString *)aShortName {
    if ((self = [super init])) {
        self.fullName = aName;
        self.shortName = aShortName;
        self.streamURL = nil;
    }
    
    return self;
}

- (BOOL)isStreamURLLoaded {
    return self.streamURL != nil;
}

@end
