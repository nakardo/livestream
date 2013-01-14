//
//  AppDelegate.h
//  livestream-osx
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import "NodeSocket.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NodeSocketDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet QTMovieView *movieView;
@property (nonatomic, strong) QTMovie *movie;
@property (nonatomic, strong) IBOutlet NSMenu *statusMenu;

- (IBAction)didPressRegisterMenuItem:(id)sender;
- (IBAction)didPressQuitMenuItem:(id)sender;

@end
