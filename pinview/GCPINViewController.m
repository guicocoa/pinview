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

@synthesize messageText, errorText;
@synthesize secureTextEntry;
@synthesize delegate;

#pragma mark -
#pragma mark initialize
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.messageText = nil;
		self.errorText = nil;
		self.title = nil;
		self.delegate = nil;
		self.secureTextEntry = YES;
	}
	return self;
}

#pragma mark -
#pragma mark view lifecycle
- (void)viewDidUnload {
	[super viewDidUnload];
	
	[pinFields release];
	pinFields = nil;
}
- (void)dealloc {
	[pinFields release];
	pinFields = nil;
	
	self.errorText = nil;
	self.messageText = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark view lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	pinFields = [[NSArray alloc] initWithObjects:
				 fieldOneLabel, fieldTwoLabel,
				 fieldThreeLabel, fieldFourLabel, nil];
	
	[self setPINText:@""];
	
	[inputField setDelegate:self];
	[inputField setKeyboardType:UIKeyboardTypeNumberPad];
	[inputField setHidden:YES];
	[inputField becomeFirstResponder];
	
	[messageLabel setText:messageText];
	[errorLabel setText:errorText];
	[errorLabel setHidden:YES];
}

#pragma mark -
#pragma mark show view controller
- (void)presentViewFromViewController:(UIViewController *)controller animated:(BOOL)animated {
	if (self.delegate == nil) {
		[[NSException exceptionWithName:NSInternalInconsistencyException
								 reason:@"You failed to provide a delegate before attempting to show the PIN code view"
							   userInfo:nil] raise];
	}
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
	[controller presentModalViewController:navController animated:animated];
	[navController release];
}

#pragma mark -
#pragma mark UITextFieldDelegate
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
		else {
			[self setPINText:@""];
		}
	}
	
	return YES;
}

#pragma mark -
#pragma mark cutsom accessors
- (void)setMessageText:(NSString *)text {
	if (messageLabel != nil) {
		messageLabel.text = text;
	}
	[messageText release];
	messageText = [text copy];
}
- (void)setErrorText:(NSString *)text {
	if (errorLabel != nil) {
		errorLabel.text = text;
	}
	[errorText release];
	errorText = [text copy];
}

@end
