//
//  LSUtils.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "LSUtils.h"
#import <UIImageView+AFNetworking.h>

@implementation LSUtils

+ (void)loadThumbnail:(UIImageView *)anImageView withShortName:(NSString *)aShortName {
    NSString *url = [NSString stringWithFormat:@"http://thumbnail.api.livestream.com/thumbnail?name=%@", aShortName];
    [anImageView setImageWithURL:[NSURL URLWithString:url]];
}

@end
