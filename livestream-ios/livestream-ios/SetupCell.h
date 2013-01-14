//
//  SetupCell.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetupCellDelegate <NSObject>

- (void)textField:(UITextField *)textField didChangeValue:(NSString *)aValue;

@end

@interface SetupCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UITextField *valueField;
@property (nonatomic, weak) id<SetupCellDelegate> delegate;

@end
