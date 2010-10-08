//
//  GCPINViewController.m
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright 2010 GUI Cocoa, LLC. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "GCPINViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface GCPINViewController (private)
- (void)setErrorLabelHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)updatePINDisplay;
@end

@implementation GCPINViewController (private)
- (void)setErrorLabelHidden:(BOOL)hidden animated:(BOOL)animated {
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	
	errorLabel.alpha = (hidden) ? 0.0 : 1.0;
	
	if (animated) {
		[UIView commitAnimations];
	}
}
- (void)updatePINDisplay {
	for (NSInteger i = 0; i < [PINText length]; i++) {
	  UILabel *label = [pinFields objectAtIndex:i];
		if (self.secureTextEntry) {
			[label setText:@"●"];
		}
		else {
			NSRange subrange = NSMakeRange(i, 1);
			NSString *substring = [PINText substringWithRange:subrange];
			[label setText:substring];
		}
	}
	for (NSInteger i = [PINText length]; i < 4; i++) {
		UILabel *label = [pinFields objectAtIndex:i];
		[label setText:@""];
	}
}
@end

@implementation GCPINViewController

@synthesize messageText, errorText;
@synthesize secureTextEntry;
@synthesize delegate, userInfo;

#pragma mark -
#pragma mark initialize
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.messageText = @"";
		self.errorText = @"";
		PINText = [@"" retain];
		self.title = @"";
		self.delegate = nil;
		self.secureTextEntry = YES;
	}
	return self;
}

#pragma mark -
#pragma mark memory management
- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UITextFieldTextDidChangeNotification
												  object:inputField];
	
	[super viewDidUnload];
	
	[pinFields release];
	pinFields = nil;
	
	fieldOneLabel = nil;
	fieldTwoLabel = nil;
	fieldThreeLabel = nil;
	fieldFourLabel = nil;
	messageLabel = nil;
	errorLabel = nil;
	inputField = nil;
}
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UITextFieldTextDidChangeNotification
												  object:inputField];
	
	[pinFields release];
	pinFields = nil;
	
	[PINText release];
	PINText = nil;
	
	self.errorText = nil;
	self.messageText = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark view lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	// text notifs
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidChange:)
												 name:UITextFieldTextDidChangeNotification
											   object:inputField];
	 
	// setup input field
	[inputField setDelegate:self];
	[inputField setKeyboardType:UIKeyboardTypeNumberPad];
	[inputField setHidden:YES];
	[inputField becomeFirstResponder];
	
	// setup pinfields list
	pinFields = [[NSArray alloc] initWithObjects:
				 fieldOneLabel, fieldTwoLabel,
				 fieldThreeLabel, fieldFourLabel, nil];
	
	// set initial pin text
	[self updatePINDisplay];
	
	// set default label states
	[messageLabel setText:messageText];
	[errorLabel setText:errorText];
	[self setErrorLabelHidden:YES animated:NO];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark -
#pragma mark show view controller
- (void)presentViewFromViewController:(UIViewController *)controller animated:(BOOL)animated {
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
	[controller presentModalViewController:navController animated:animated];
	[navController release];
}

#pragma mark -
#pragma mark text methods
- (void)textDidChange:(NSNotification *)notif {
	UITextField *field = [notif object];
	if (field == inputField) {
		NSString *newText = field.text;
		
		if ([newText length] == 4) {
			NSString *toValidate = [field.text copy];
			BOOL valid = [delegate pinView:self validateCode:toValidate];
			[toValidate release];
			if (!valid) {
				AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
				[self setErrorLabelHidden:NO animated:YES];
				inputField.text = @"";
			}
		}
		else {
			[PINText release];
			PINText = [newText copy];
		}
		
		[self updatePINDisplay];
	}
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([PINText length] == 4 && [string length] > 0) {
		return NO;
	}
	else {
		[self setErrorLabelHidden:YES animated:YES];
		return YES;
	}
}

#pragma mark -
#pragma mark cutsom accessors
- (void)setMessageText:(NSString *)text {
	[messageText release];
	messageText = [text copy];
	if (messageLabel != nil) {
		messageLabel.text = messageText;
	}
}
- (void)setErrorText:(NSString *)text {
	[errorText release];
	errorText = [text copy];
	if (errorLabel != nil) {
		errorLabel.text = errorText;
	}
}

@end
