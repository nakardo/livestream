//
//  SetupViewController.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupCell.h"
#import "ConnectionCheckSocket.h"

@interface SetupViewController : UITableViewController <SetupCellDelegate, ConnectionCheckSocketDelegate>

@end
