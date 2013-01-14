//
//  ChannelsViewController.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "ChannelsViewController.h"
#import "ChannelCell.h"
#import "Channel.h"
#import "LSUtils.h"
#import "PlaybackViewController.h"

@interface ChannelsViewController ()

@property (nonatomic, strong) LSChannelAPI *client;
@property (nonatomic, strong) NSMutableArray * channels;

@end

@implementation ChannelsViewController

- (void)dealloc {
    self.client = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.channels = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.client = [LSChannelAPI instanceWithDelegate:self];
    [self.client requestChannels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.channels removeAllObjects];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayChannel"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        PlaybackViewController *controller = segue.destinationViewController;
        controller.channel = [self.channels objectAtIndex:indexPath.row];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChannelCell";
    ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Channel *aChannel = [self.channels objectAtIndex:indexPath.row];
    cell.fullNameLabel.text = aChannel.fullName;
    cell.shortNameLabel.text = [NSString stringWithFormat:@"on %@", aChannel.shortName];
    
    [LSUtils loadThumbnail:cell.thumbImageView withShortName:aChannel.shortName];

    return cell;
}

- (void)api:(id)sender didLoadChannels:(NSArray *)theChannels {
    [self.channels addObjectsFromArray:theChannels];
    [self.tableView reloadData];
}

- (void)api:(id)sender failedToLoadChannelsWithError:(NSError *)anError {
    NSLog(@"[CLIENT API ERROR] %@", anError.description);
}

@end
