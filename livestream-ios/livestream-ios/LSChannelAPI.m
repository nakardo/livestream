//
//  LSChannelAPI.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "LSChannelAPI.h"
#import <AFKissXMLRequestOperation.h>
#import "Channel.h"

static NSString * const kLSChannelAPIBaseURL = @"http://channelguide.api.livestream.com/programguide";

@interface LSChannelAPI ()

@property (nonatomic, weak) id<LSChannelAPIDelegate> delegate;

@end

@implementation LSChannelAPI

+ (LSChannelAPI *)instanceWithDelegate:(id<LSChannelAPIDelegate>)aDelegate {
    return [[self alloc] initWithDelegate:aDelegate];
}

+ (NSURL *)createRequestURL {
    NSMutableString *url = [NSMutableString stringWithString:kLSChannelAPIBaseURL];
    
    [url appendFormat:@"?method=getChannels"];
    [url appendFormat:@"&affiliateId=%@", kLSAPIAffiliateId];
    [url appendFormat:@"&applicationKey=%@", kLSAPIApplicationId];
    [url appendFormat:@"&channelType=LIVE"];

    return [NSURL URLWithString:url];
}

+ (NSArray *)parseResponse:(DDXMLDocument *)XMLDocument {
    NSMutableArray *theChannels = [NSMutableArray array];
    
    NSError *error;
    NSArray *channelNodes = [XMLDocument nodesForXPath:@"//channel" error:&error];
    for (DDXMLElement *aChannelNode in channelNodes) {
        NSString *shortName = [[aChannelNode attributeForName:@"shortName"] stringValue];
        NSString *fullName = [[aChannelNode attributeForName:@"fullName"] stringValue];
        
        Channel *aChannel = [Channel channelWithName:fullName andShortName:shortName];
        [theChannels addObject:aChannel];
    }
    
    return theChannels;
}

- (LSChannelAPI *)initWithDelegate:(id<LSChannelAPIDelegate>)aDelegate {
    if ((self = [super init])) {
        self.delegate = aDelegate;
    }
    
    return self;
}

- (void)requestChannels {
    NSURLRequest *request = [NSURLRequest requestWithURL:[LSChannelAPI createRequestURL]];
    AFKissXMLRequestOperation *op = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request
        success: ^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
            if (self.delegate) {
                NSArray *channels = [LSChannelAPI parseResponse:XMLDocument];
                [self.delegate api:self didLoadChannels:channels];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
            if (self.delegate) {
                [self.delegate api:self failedToLoadChannelsWithError:error];
            }
        }
    ];
    
    [op start];
}

@end
