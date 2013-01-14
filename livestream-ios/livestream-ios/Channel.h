//
//  Channel.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property (nonatomic, copy, readonly) NSString *fullName;
@property (nonatomic, copy, readonly) NSString *shortName;
@property (nonatomic, copy) NSString *streamURL;

+ (Channel *)channelWithName:(NSString *)aName andShortName:(NSString *)aShortName;
- (BOOL)isStreamURLLoaded;

@end
