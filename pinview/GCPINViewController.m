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
@property (copy, nonatomic) NSString *text;
@property (nonatomic, readwrite, assign) GCPINViewControllerMode mode;
- (void)updatePINDisplay;
- (void)reset;
- (void)wrong;
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
@synthesize mode = __mode;
@synthesize text = __text;

@synthesize delegate, userInfo;

#pragma mark - object methods
- (id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle mode:(GCPINViewControllerMode)mode {
	if (self = [super initWithNibName:nib bundle:bundle]) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(textDidChange:)
         name:UITextFieldTextDidChangeNotification
         object:nil];
        self.mode = mode;
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
    self.text = nil;
	
    // super
    [super dealloc];
    
}
- (void)presentPasscodeViewFromViewController:(UIViewController *)controller {
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
	[controller presentModalViewController:navController animated:YES];
	[navController release];
}
- (void)updatePINDisplay {
    NSUInteger length = [self.inputField.text length];
    for (NSUInteger i = 0; i < 4; i++) {
        UILabel *label = [self.labels objectAtIndex:i];
        label.text = (i < length) ? @"●" : @"";
    }
}
- (void)reset {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    double delay = 0.3;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        self.inputField.text = @"";
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}
- (void)wrong {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    self.errorLabel.hidden = NO;
    [self reset];
}
- (void)dismissPasscodeView {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    double delay = 0.3;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
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
    self.text = nil;
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
        NSAssert(self.delegate, @"No passcode delegate is set");
        [self updatePINDisplay];
        if ([self.inputField.text length] == 4) {
            if (self.mode == GCPINViewControllerModeCreate) {
                if (self.text == nil) {
                    self.text = self.inputField.text;
                    [self reset];
                }
                else {
                    if ([self.text isEqualToString:self.inputField.text] &&
                        [self.delegate pinView:self validateCode:self.text]) {
                        [self dismissPasscodeView];
                    }
                    else {
                        [self wrong];
                        self.text = nil;
                    }
                }
            }
            else {
                if ([delegate pinView:self validateCode:self.inputField.text]) {
                    [self dismissPasscodeView];
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

@end
