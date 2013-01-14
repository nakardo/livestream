//
//  PlaybackViewController.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Channel.h"
#import "LSStreamAPI.h"
#import "ActionSocket.h"

@interface PlaybackViewController : UITableViewController <LSStreamAPIDelegate, ActionSocketDelegate>

@property (nonatomic, weak) Channel *channel;

@end
