//
//  SetupViewController.m
//  livestream-ios
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "SetupViewController.h"
#import "AppDelegate.h"


static int const kSetupSection = 0;
static int const kSetupSectionServerURLRow = 0;
static int const kSetupSectionHashRow = 1;

@interface SetupViewController ()

@property (nonatomic, strong) ConnectionCheckSocket *socket;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (kSetupSection == section) {
        return 2;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = nil;
    
    UITableViewCell *cell = nil;
    if (kSetupSection == indexPath.section) {
        cellIdentifier = @"SetupCell";
        SetupCell *setupCell = (SetupCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        setupCell.delegate = self;
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (kSetupSectionServerURLRow == indexPath.row) {
            setupCell.textLabel.text = @"Server URL";
            setupCell.valueField.text = delegate.serverURL;
        } else {
            setupCell.textLabel.text = @"Client Secret";
            setupCell.valueField.text = delegate.secret;
        }
        
        cell = setupCell;
    } else {
        cellIdentifier = @"BasicCell";
        if (!(cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier])) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
            
            cell.textLabel.text = @"PING";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    return cell;
}

- (void)checkConnection {
    self.socket = [ConnectionCheckSocket instanceWithDelegate:self];
    [self.socket ping];
}

- (void)socket:(SRWebSocket *)aSocket didReceivePong:(BOOL)pong withMessage:(NSString *)aMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Response"
                                                    message:aMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kSetupSection == indexPath.section) {
        SetupCell *cell = (SetupCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.valueField becomeFirstResponder];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self checkConnection];
    }
}

- (void)textField:(UITextField *)textField didChangeValue:(NSString *)aValue {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIView *cell = [textField superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)cell];
    if (kSetupSectionServerURLRow == indexPath.row) {
        delegate.serverURL = aValue;
    } else {
        delegate.secret = aValue;
    }
}

@end
