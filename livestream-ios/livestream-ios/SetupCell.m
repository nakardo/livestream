//
//  SetupCell.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "SetupCell.h"

@implementation SetupCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.valueField resignFirstResponder];
    [self.delegate textField:textField didChangeValue:textField.text];
    return YES;
}

@end
