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
	[pinView setPINText:@""];
	[pinView setMessageText:@"Enter your PIN"];
	[pinView setErrorText:@"Invalid"];
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setRootViewController:defaultView];
  [window makeKeyAndVisible];
	
  UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 50)] autorelease];
  label.backgroundColor = [UIColor blackColor];
  label.textColor = [UIColor orangeColor];
  label.text = @"Success!";
  [[defaultView view] addSubview:label];
  
	[pinView presentViewFromViewController:defaultView animated:NO];
	
	return YES;
}

#pragma mark -
#pragma mark GCPINViewControllerDelegate
- (BOOL) pinView:(GCPINViewController *)pinView validateCode:(NSString *)PIN {
  BOOL valid = [PIN isEqualToString:@"1234"];
  if (valid)
    [pinView dismissModalViewControllerAnimated:YES];
  return valid;
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc {
    [window release];
	window = nil;
	
    [super dealloc];
}

@end
