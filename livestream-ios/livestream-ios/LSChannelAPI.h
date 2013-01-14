//
//  LSChannelAPI.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSAPI.h"

@protocol LSChannelAPIDelegate <NSObject>

- (void)api:(id)sender didLoadChannels:(NSArray *)theChannels;
- (void)api:(id)sender failedToLoadChannelsWithError:(NSError *)anError;

@end

@interface LSChannelAPI : LSAPI

+ (LSChannelAPI *)instanceWithDelegate:(id<LSChannelAPIDelegate>)aDelegate;
- (void)requestChannels;

@end
