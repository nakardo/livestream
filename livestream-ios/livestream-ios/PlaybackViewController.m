//
//  PlaybackViewController.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "PlaybackViewController.h"

@interface PlaybackViewController () {
    BOOL isSocketOpen;
    BOOL isStreamAvailable;
}

@property (nonatomic, strong) LSStreamAPI *client;
@property (nonatomic, strong) ActionSocket *socket;

@end

static const int kPlayPauseRowIndex = 0;
static const int kStopRowIndex = 1;
static const int kCloseRowIndex = 2;

@implementation PlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isStreamAvailable = YES;
    
    self.client = [LSStreamAPI instanceWithDelegate:self];
    [self.client requestStreamURL:self.channel.shortName];
    
    self.socket = [ActionSocket instanceWithDelegate:self];
    [self.socket open];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.channel isStreamURLLoaded] && isSocketOpen) {
        SocketAction action = SocketActionUndefined;
        if (kPlayPauseRowIndex == indexPath.row) {
            action = SocketActionPlayPause;
        } else if (kStopRowIndex == indexPath.row) {
            action = SocketActionStop;
        } else if (kCloseRowIndex == indexPath.row) {
            action = SocketActionClose;
        }
        [self.socket sendAction:action forChannel:self.channel];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.channel.fullName;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (!isStreamAvailable) {
        return @"Stream is not available for this channel";
    } else if (![self.channel isStreamURLLoaded]) {
        return @"Please wait until the stream url is loaded";
    }
    
    return self.channel.streamURL;
}

- (void)api:(id)sender loadedStreamURL:(NSString *)streamURL {
    if (streamURL != nil) {
        [self.channel setStreamURL:streamURL];
    } else {
        isStreamAvailable = NO;
    }
    
    [self.tableView reloadData];
}

- (void)api:(id)sender failedToLoadStreamURLWithError:(NSError *)anError {
    NSLog(@"Failed to load stream url");
}

- (void)socketDidOpen:(SRWebSocket *)aSocket {
    isSocketOpen = YES;
}

- (void)socketDidSendAction:(NSString *)aMessage {
    NSLog(@"Action sent: %@", aMessage);
}

- (void)socketDidFailToSendAction:(NSError *)anError {
    NSLog(@"Failed to send action: %@", anError.description);
}

@end
