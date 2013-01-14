//
//  LSStreamAPI.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "LSStreamAPI.h"
#import <AFKissXMLRequestOperation.h>
#import "AFHTTPRequestOperation.h"

@interface LSStreamAPI ()

@property (nonatomic, weak) id<LSStreamAPIDelegate> delegate;

@end

@implementation LSStreamAPI

+ (NSString *)playlistURLFromResponse:(DDXMLDocument *)XMLDocument {
    NSString *playlistURL = @"";
    
    NSError *error;
    NSArray *streamNodes = [XMLDocument nodesForXPath:@"//ls:httpUrl" error:&error];
    if ([streamNodes count] > 0) {
        DDXMLElement *aStreamNode = [streamNodes lastObject];
        playlistURL = [aStreamNode stringValue];
    }
    
    return playlistURL;
}

+ (NSString *)streamURLFromResponse:(NSString *)response {
    NSArray *comp = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *url in comp) {
        if ([url hasPrefix:@"http://"]) {
            return url;
        }
    }
    
    return nil;
}

+ (NSURL *)createRequestURLWithChannel:(NSString *)channelShortName {
    NSString *escapedName = [channelShortName stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    NSString *url = [NSString stringWithFormat:@"http://x%@x.api.channel.livestream.com/2.0/getstream", escapedName];
    return [NSURL URLWithString:url];
}

+ (LSStreamAPI *)instanceWithDelegate:(id<LSStreamAPIDelegate>)aDelegate {
    return [[self alloc] initWithDelegate:aDelegate];
}

- (LSStreamAPI *)initWithDelegate:(id<LSStreamAPIDelegate>)aDelegate {
    if ((self = [super init])) {
        self.delegate = aDelegate;
    }
    
    return self;
}

- (void)requestStreamURL:(NSString *)channelShortName {
    NSURLRequest *request = [NSURLRequest requestWithURL:[LSStreamAPI createRequestURLWithChannel:channelShortName]];
    AFKissXMLRequestOperation *op = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request
        success: ^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
            NSString *playlistURL = [LSStreamAPI playlistURLFromResponse:XMLDocument];
            [self requestPlaylist:playlistURL];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
            if (self.delegate) {
                [self.delegate api:self failedToLoadStreamURLWithError:error];
            }
        }
    ];
    
    [op start];
}

- (void)requestPlaylist:(NSString *)playlistURL {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:playlistURL]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([operation.response statusCode] == 200) {
            NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *streamURL = [LSStreamAPI streamURLFromResponse:response];
            [self.delegate api:self loadedStreamURL:streamURL];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        if (self.delegate) {
            [self.delegate api:self failedToLoadStreamURLWithError:error];
        }
    }];
    
    [op start];
}

@end
