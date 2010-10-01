    //
//  GCPINViewController.m
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright 2010 GUI Cocoa, LLC. All rights reserved.
//

#import "GCPINViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface GCPINViewController (private)
- (void)updatePINLabels:(NSString *)string;
@end

@implementation GCPINViewController (private)
- (void)updatePINLabels:(NSString *)string {
  [UIView beginAnimations:nil context:nil];
	[errorLabel setAlpha:0.0];
  [UIView commitAnimations];

	for (NSInteger i = 0; i < [string length]; i++) {
		UILabel *label = [pinFields objectAtIndex:i];
		if (self.secureTextEntry) {
			[label setText:@"●"];
		}
		else {
			NSRange subrange = NSMakeRange(i, 1);
			NSString *substring = [string substringWithRange:subrange];
			[label setText:substring];
		}
	}
	for (NSInteger i = [string length]; i < 4; i++) {
		UILabel *label = [pinFields objectAtIndex:i];
		[label setText:@""];
	}
}
@end

@implementation GCPINViewController

@synthesize messageText, errorText, PINText;
@synthesize secureTextEntry;
@synthesize delegate, userInfo;

#pragma mark -
#pragma mark initialize
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.messageText = @"";
		self.errorText = @"";
		self.PINText = @"";
		self.title = @"";
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
	self.PINText = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark view lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	pinFields = [[NSArray alloc] initWithObjects:
				 fieldOneLabel, fieldTwoLabel,
				 fieldThreeLabel, fieldFourLabel, nil];
	
	[self setPINText:PINText];
	
	[inputField setDelegate:self];
	[inputField setKeyboardType:UIKeyboardTypeNumberPad];
	[inputField setHidden:YES];
	[inputField becomeFirstResponder];
	
	[messageLabel setText:messageText];
	[errorLabel setText:errorText];
	[errorLabel setHidden:NO];
  [errorLabel setAlpha:0.0];
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
	if ([PINText length] == 4) {
		return NO;
	}
	
	if ([string length]) {
		NSString *temp = [NSString stringWithFormat:@"%@%@", PINText, string];
		[PINText release];
		PINText = [temp copy];
	}
	else {
		if ([PINText length] == 0) {
			return YES;
		}
		
		NSString *temp = [PINText substringWithRange:
						  NSMakeRange(0, [PINText length] - 1)];
		[PINText release];
		PINText = [temp copy];
	}
	
	[self updatePINLabels:PINText];

	if ([PINText length] == 4) {
		if (![delegate pinView:self validateCode:PINText]) {
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
      [self setPINText:@""];
      [UIView beginAnimations:nil context:nil];
      [errorLabel setAlpha:1.0];
      [UIView commitAnimations];
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

#pragma mark -
#pragma mark set pin text
- (void)setPINText:(NSString *)string {
	if ([string length] > 4) {
		return;
	}
	
	[PINText release];
	PINText = [string copy];
	[inputField setText:PINText];
	[self updatePINLabels:PINText];
}

@end
