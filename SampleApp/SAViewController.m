//
//  SAViewController.m
//  SampleApp
//
//  Created by Caleb Davenport on 12/29/11.
//  Copyright (c) 2011 GUI Cocoa, LLC. All rights reserved.
//

#import "SAViewController.h"

#import "GCPINViewController.h"

@implementation SAViewController

@synthesize code;

- (void)viewDidLoad {
    // Set default code
    self.code = @"0187";
}

- (IBAction)setPIN {
    GCPINViewController *PIN = [[GCPINViewController alloc]
                                initWithNibName:nil
                                bundle:nil
                                mode:GCPINViewControllerModeCreate];
    PIN.messageText = @"Enter a passcode";
    PIN.errorText = @"The passcodes do not match";
    PIN.title = @"Set Passcode";
    PIN.verifyBlock = ^(NSString *newCode) {
        NSLog(@"setting code: %@", newCode);
        self.code = newCode;
        return YES;
    };
    [PIN presentFromViewController:self animated:YES];
    [PIN release];
}

- (IBAction)checkPIN {
    GCPINViewController *PIN = [[GCPINViewController alloc]
                                initWithNibName:nil
                                bundle:nil
                                mode:GCPINViewControllerModeVerify];
    PIN.messageText = @"Enter your passcode";
    PIN.errorText = @"Incorrect passcode";
    PIN.title = @"Enter Passcode";
    PIN.verifyBlock = ^(NSString *enteredCode) {
        NSLog(@"checking code: %@", enteredCode);
        return [enteredCode isEqualToString:self.code];
    };
    [PIN presentFromViewController:self animated:YES];
    [PIN release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else {
        return (orientation == UIInterfaceOrientationPortrait);
    }
}

@end
