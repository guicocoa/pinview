//
//  SAAppDelegate.m
//  SampleApp
//
//  Created by Caleb Davenport on 12/29/11.
//  Copyright (c) 2011 GUI Cocoa, LLC. All rights reserved.
//

#import "SAAppDelegate.h"

#import "SAViewController.h"

@implementation SAAppDelegate

@synthesize window = _window;

- (void)dealloc {
    self.window = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    SAViewController *controller = [[[SAViewController alloc]
                                     initWithNibName:@"SAViewController"
                                     bundle:nil]
                                    autorelease];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
