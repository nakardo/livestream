//
//  ChannelCell.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *thumbImageView;
@property (nonatomic, strong) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *shortNameLabel;

@end
