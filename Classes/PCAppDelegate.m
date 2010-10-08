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
	// setup main view controller   
	UIViewController *defaultView = [[UIViewController alloc] init];
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 50)] autorelease];
	label.backgroundColor = [UIColor blackColor];
	label.textColor = [UIColor orangeColor];
	label.text = @"Success!";
	[defaultView.view addSubview:label];
	
	// setup pin view
	GCPINViewController *pinView = [[GCPINViewController alloc] initWithNibName:@"PINViewDefault" bundle:nil];
	pinView.delegate = self;
	pinView.messageText = @"Enter Your PIN";
	pinView.title = @"PIN Code";
	pinView.errorText = @"Invalid";
	
	// setup window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setRootViewController:defaultView];
	[window makeKeyAndVisible];
	
	// show pin view
	[pinView presentViewFromViewController:defaultView animated:NO];
	
	// return
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
