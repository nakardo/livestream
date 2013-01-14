//
//  LSStreamAPI.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSAPI.h"

@protocol LSStreamAPIDelegate <NSObject>

- (void)api:(id)sender loadedStreamURL:(NSString *)streamURL;
- (void)api:(id)sender failedToLoadStreamURLWithError:(NSError *)anError;

@end

@interface LSStreamAPI : LSAPI

+ (LSStreamAPI *)instanceWithDelegate:(id<LSStreamAPIDelegate>)aDelegate;
- (void)requestStreamURL:(NSString *)channelShortName;

@end
