//
//  GCPINViewController.m
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright 2010 GUI Cocoa, LLC. All rights reserved.
//

#import "GCPINViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface GCPINViewController ()
@property (copy, nonatomic) NSArray *labels;
@property (copy, nonatomic) NSString *PINText;
- (void)updatePINDisplay;
- (void)setErrorLabelHidden:(BOOL)hidden animated:(BOOL)animated;
@end

@implementation GCPINViewController

@synthesize fieldOneLabel = __fieldOneLabel;
@synthesize fieldTwoLabel = __fieldTwoLabel;
@synthesize fieldThreeLabel = __fieldThreeLabel;
@synthesize fieldFourLabel = __fieldFourLabel;
@synthesize messageLabel = __messageLabel;
@synthesize errorLabel = __errorLabel;
@synthesize inputField = __inputField;
@synthesize messageText = __messageText;
@synthesize errorText = __errorText;
@synthesize labels = __labels;
@synthesize PINText = __PINText;

@synthesize delegate, userInfo;

#pragma mark - object methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(textDidChange:)
         name:UITextFieldTextDidChangeNotification
         object:nil];
	}
	return self;
}
- (void)dealloc {
    
    // clear notifs
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UITextFieldTextDidChangeNotification
     object:nil];
    
    // clear properties
    self.fieldOneLabel = nil;
    self.fieldTwoLabel = nil;
    self.fieldThreeLabel = nil;
    self.fieldFourLabel = nil;
    self.messageLabel = nil;
    self.errorLabel = nil;
    self.inputField = nil;
    self.messageText = nil;
    self.errorText = nil;
    self.labels = nil;
    self.PINText = nil;
	
    // super
    [super dealloc];
    
}
- (void)presentViewFromViewController:(UIViewController *)controller animated:(BOOL)animated {
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
	[controller presentModalViewController:navController animated:animated];
	[navController release];
}
- (void)updatePINDisplay {
    NSUInteger length = [self.PINText length];
    for (NSUInteger i = 0; i < 4; i++) {
        UILabel *label = [self.labels objectAtIndex:i];
        label.text = (i < length) ? @"●" : @"";
    }
}
- (void)setErrorLabelHidden:(BOOL)hidden animated:(BOOL)animated {
	if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
	self.errorLabel.hidden = hidden;
	if (animated) { [UIView commitAnimations]; }
}

#pragma mark - view lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
    
    // setup labels list
    self.labels = [NSArray arrayWithObjects:
                   self.fieldOneLabel,
                   self.fieldTwoLabel,
                   self.fieldThreeLabel,
                   self.fieldFourLabel,
                   nil];
    
    // setup labels
    self.messageLabel.text = self.messageText;
    self.errorLabel.text = self.errorText;
    [self setErrorLabelHidden:YES animated:NO];
	[self updatePINDisplay];
    
	// setup input field
    self.inputField.hidden = YES;
    self.inputField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputField.delegate = self;
    [self.inputField becomeFirstResponder];
	
}
- (void)viewDidUnload {
	[super viewDidUnload];
	self.fieldOneLabel = nil;
    self.fieldTwoLabel = nil;
    self.fieldThreeLabel = nil;
    self.fieldFourLabel = nil;
    self.messageLabel = nil;
    self.errorLabel = nil;
    self.inputField = nil;
    self.labels = nil;
    self.PINText = nil;
}

#pragma mark - overridden property accessors
- (void)setMessageText:(NSString *)text {
    [__messageText release];
    __messageText = [text copy];
    self.messageLabel.text = __messageText;
}
- (void)setErrorText:(NSString *)text {
	[__errorText release];
    __errorText = [text copy];
    self.errorLabel.text = __errorText;
}

#pragma mark - text field methods
- (void)textDidChange:(NSNotification *)notif {
    if ([notif object] == self.inputField) {
        self.PINText = self.inputField.text;
        [self updatePINDisplay];
        if ([self.PINText length] == 4) {
			BOOL valid = [delegate pinView:self validateCode:self.PINText];
            if (valid) {
                
            }
            else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
				[self setErrorLabelHidden:NO animated:YES];
                double delay = 0.3;
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^(void){
                    self.inputField.text = @"";
                });
            }
		}
        
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text length] == 4 && [string length] > 0) {
        return NO;
    }
    else {
        [self setErrorLabelHidden:YES animated:YES];
        return YES;
    }
}

@end
