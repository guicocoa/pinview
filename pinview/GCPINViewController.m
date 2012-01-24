//
//  GCPINViewController.m
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright 2010 GUI Cocoa, LLC. All rights reserved.
//

#import "GCPINViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define kGCPINViewControllerDelay 0.3

@interface GCPINViewController ()

// array of passcode entry labels
@property (copy, nonatomic) NSArray *labels;

// readwrite override for mode
@property (nonatomic, readwrite, assign) GCPINViewControllerMode mode;

// extra storage used when creating a passcode
@property (copy, nonatomic) NSString *text;

// make the passcode entry labels match the input text
- (void)updatePasscodeDisplay;

// reset user input after a set delay
- (void)resetInput;

// signal that the passcode is incorrect
- (void)wrong;

// dismiss the view after a set delay
- (void)dismiss;

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
@synthesize confirmText = __confirmText;
@synthesize errorText = __errorText;
@synthesize labels = __labels;
@synthesize mode = __mode;
@synthesize text = __text;
@synthesize verifyBlock = __verifyBlock;

#pragma mark - object methods
- (id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle mode:(GCPINViewControllerMode)mode {
    NSAssert(mode == GCPINViewControllerModeCreate ||
             mode == GCPINViewControllerModeVerify,
             @"Invalid passcode mode");
	if (self = [super initWithNibName:nib bundle:bundle]) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(textDidChange:)
         name:UITextFieldTextDidChangeNotification
         object:nil];
        self.mode = mode;
        __dismiss = NO;
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
    self.confirmText = nil;
    self.errorText = nil;
    self.labels = nil;
    self.text = nil;
    self.verifyBlock = nil;
	
    // super
    [super dealloc];
    
}
- (void)presentFromViewController:(UIViewController *)controller animated:(BOOL)animated {
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
	[controller presentModalViewController:navController animated:animated];
	[navController release];
}
- (void)updatePasscodeDisplay {
    NSUInteger length = [self.inputField.text length];
    for (NSUInteger i = 0; i < 4; i++) {
        UILabel *label = [self.labels objectAtIndex:i];
        label.text = (i < length) ? @"●" : @"";
    }
}
- (void)resetInput {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, kGCPINViewControllerDelay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        self.inputField.text = @"";
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}
- (void)wrong {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    self.errorLabel.hidden = NO;
    self.text = nil;
    [self resetInput];
}
- (void)dismiss {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    __dismiss = YES;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, kGCPINViewControllerDelay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self dismissModalViewControllerAnimated:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
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
    self.errorLabel.hidden = YES;
	[self updatePasscodeDisplay];
    
	// setup input field
    self.inputField.hidden = YES;
    self.inputField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputField.delegate = self;
    self.inputField.secureTextEntry = YES;
    self.inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
    self.text = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationIsLandscape(orientation);
    }
    else {
        return (orientation == UIInterfaceOrientationPortrait);
    }
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
        NSAssert(self.verifyBlock, @"No passcode verify block is set");
        [self updatePasscodeDisplay];
        if ([self.inputField.text length] == 4) {
            if (self.mode == GCPINViewControllerModeCreate) {
                if (self.text == nil) {
                    self.text = self.inputField.text;
                    
                    // Display confirm text if it's been set
                    if ( self.confirmText != nil ) {
                        self.messageLabel.text = self.confirmText;
                    }
                    
                    [self resetInput];
                }
                else {
                    if ([self.text isEqualToString:self.inputField.text] &&
                        self.verifyBlock(self.inputField.text)) {
                        [self dismiss];
                    }
                    else {                        
                        // Reinstate original message text
                        self.messageLabel.text = self.messageText;
                        
                        [self wrong];
                    }
                }
            }
            else if (self.mode == GCPINViewControllerModeVerify) {
                if (self.verifyBlock(self.inputField.text)) {
                    [self dismiss];
                }
                else {
                    [self wrong];
                }
            }
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text length] == 4 && [string length] > 0) {
        return NO;
    }
    else {
        self.errorLabel.hidden = YES;
        return YES;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return __dismiss;
}

@end
