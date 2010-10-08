//
//  PINCodeAppDelegate.m
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright GUI Cocoa, LLC. 2010. All rights reserved.
//

#import "PCAppDelegate.h"

#import "GCPINViewController.h"

@implementation PCAppDelegate

#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	UIViewController *defaultView = [[UIViewController alloc] init];
	GCPINViewController *pinView = [[GCPINViewController alloc] initWithNibName:@"PINViewDefault" bundle:nil];
	[pinView setDelegate:self];
	[pinView setMessageText:@"Enter Your PIN"];
	[pinView setTitle:@"PIN Code"];
	[pinView setErrorText:@"Awww You Suck"];
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setRootViewController:defaultView];
    [window makeKeyAndVisible];
	
	[pinView presentViewFromViewController:defaultView animated:NO];
	
	return YES;
}

#pragma mark -
#pragma mark GCPINViewControllerDelegate
- (BOOL)pinView:(GCPINViewController *)pinView validateCode:(NSString *)code {
	BOOL correct = [code isEqualToString:@"1234"];
	if (correct) {
		[pinView dismissModalViewControllerAnimated:YES];
	}
	return correct;
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc {
    [window release];
	window = nil;
	
    [super dealloc];
}

@end
