//
//  AppDelegate.m
//  livestream-osx
//
//  Created by Diego Acosta on 1/13/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSStatusItem * statusItem;
@property (nonatomic, strong) NodeSocket *socket;

@end

static int const kMainMenuStatusItemTag = 100;
static int const kMainMenuRegisterItemTag = 101;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.socket = [NodeSocket instanceWithDelegate:self];
    [self.socket open];
}

- (void)awakeFromNib {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setTitle:@"Livestream"];
    [self.statusItem setHighlightMode:YES];
}

- (void)performMovieAction:(SocketAction)anAction withStreamURL:(NSString *)url {
    if (anAction == SocketActionPlayPause) {
        // if (self.movie.rate == 0) {
            NSError *error = nil;
            NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSURL URLWithString:url], QTMovieURLAttribute,
                                   [NSNumber numberWithBool:YES], QTMovieOpenForPlaybackAttribute ,
                                   [NSNumber numberWithBool:YES], QTMovieOpenAsyncRequiredAttribute,
                                   [NSNumber numberWithBool:YES], QTMovieOpenAsyncOKAttribute,
                                   nil];
            self.movie = [[QTMovie alloc] initWithAttributes:attrs error:&error];
            [self.movie autoplay];
        
            if ([self.window isZoomed] == NO)[self.window zoom:nil];
            [self.window makeKeyAndOrderFront:nil];
        // }
    } else if (anAction == SocketActionStop) {
        [self.movie stop];
    } else if (anAction == SocketActionClose) {
        [self.movie stop]; self.movie = nil;
        [self.window orderOut:nil];
    }
}

- (IBAction)didPressRegisterMenuItem:(id)sender {
    [self.socket doRegister];
}

- (IBAction)didPressQuitMenuItem:(id)sender {
    [NSApp terminate:self];
}

- (void)socketDidOpen:(SRWebSocket *)aSocket {
    NSMenuItem *registerMenu = [self.statusMenu itemWithTag:kMainMenuRegisterItemTag];
    registerMenu.title = @"Register";
    [registerMenu setEnabled:YES];
}

- (void)socket:(SRWebSocket *)aSocket didRegister:(BOOL)isRegistered withMessage:(NSString *)aMessage {
    if (isRegistered) {
        NSMenuItem *statusMenu = [self.statusMenu itemWithTag:kMainMenuStatusItemTag];
        statusMenu.title = [NSString stringWithFormat:@"Status: Registered (%@)", kClientSecret];
    }
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Server Message"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:aMessage];
    [alert runModal];
}

- (void)socket:(SRWebSocket *)aSocket didReceiveAction:(SocketAction)anAction withStreamURL:(NSString *)anURL {
    [self performMovieAction:anAction withStreamURL:anURL];
    NSLog(@"Received action with URL: %@", anURL);
}

@end
