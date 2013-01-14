//
//  AppDelegate.h
//  livestream-ios
//
//  Created by Diego Acosta on 1/12/13.
//  Copyright (c) 2013 Diego Acosta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString *serverURL;
@property (nonatomic, copy) NSString *secret;

@end
