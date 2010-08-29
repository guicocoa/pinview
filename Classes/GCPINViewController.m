    //
//  GCPINViewController.m
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright 2010 GUI Cocoa, LLC. All rights reserved.
//

#import "GCPINViewController.h"

@interface GCPINViewController (private)
- (void)setPINText:(NSString *)string;
@end

@implementation GCPINViewController (private)
- (void)setPINText:(NSString *)string {
	for (NSInteger i = 0; i < [string length]; i++) {
		UITextField *currentField = [pinFields objectAtIndex:i];
		if (self.secureTextEntry) {
			[currentField setText:@"●"];
		}
		else {
			NSRange subrange = NSMakeRange(i, 1);
			NSString *substring = [string substringWithRange:subrange];
			[currentField setText:substring];
		}
	}
	for (NSInteger i = [string length]; i < 4; i++) {
		UITextField *currentField = [pinFields objectAtIndex:i];
		[currentField setText:@""];
	}
}
@end

@implementation GCPINViewController

@synthesize titleText;
@synthesize promptText;
@synthesize secureTextEntry;
@synthesize errorText;
@synthesize delegate;

- (void)viewDidUnload {
	[super viewDidUnload];
	
	[pinFields release];
	pinFields = nil;
	
	self.titleText = nil;
	self.promptText = nil;
	self.errorText = nil;
}
- (void)dealloc {
	[pinFields release];
	pinFields = nil;
	
	self.titleText = nil;
	self.promptText = nil;
	self.errorText = nil;
	
    [super dealloc];
}
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.secureTextEntry = YES;
	
	pinFields = [[NSArray alloc] initWithObjects:
				 fieldOneLabel, fieldTwoLabel,
				 fieldThreeLabel, fieldFourLabel, nil];
	
	[self setPINText:@""];
	
	[inputField setDelegate:self];
	[inputField setKeyboardType:UIKeyboardTypeNumberPad];
	[inputField setHidden:YES];
	[inputField becomeFirstResponder];
	
	[self setTitle:[self titleText]];
	[promptLabel setText:[self promptText]];
	[errorLabel setText:[self errorText]];
	[errorLabel setHidden:YES];
}
- (void)presentViewFromViewController:(UIViewController *)controller animated:(BOOL)animated {
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
	[controller presentModalViewController:navController animated:animated];
	[navController release];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([string length] && [[textField text] length] == 4) {
		return NO;
	}
	
	[errorLabel setHidden:YES];
	NSString *futureText = [[textField text] stringByReplacingCharactersInRange:range withString:string];
	[self setPINText:futureText];
	
	if ([futureText length] == 4 && delegate != nil) {
		BOOL valid = [delegate isPINCodeValid:futureText];
		[errorLabel setHidden:valid];
		if (valid) {
			[self dismissModalViewControllerAnimated:YES];
		}
	}
	
	return YES;
}

@end
