//
//  SAViewController.m
//  SampleApp
//
//  Created by Caleb Davenport on 12/29/11.
//  Copyright (c) 2011 GUI Cocoa, LLC. All rights reserved.
//

#import "SAViewController.h"

@implementation SAViewController

- (IBAction)setPIN {
    GCPINViewController *PIN = [[GCPINViewController alloc]
                                initWithNibName:@"PINViewDefault"
                                bundle:nil
                                mode:GCPINViewControllerModeCreate];
    PIN.delegate = self;
    PIN.messageText = @"Create Passcode";
    PIN.errorText = @"The passcodes do not match";
    [PIN presentPasscodeViewFromViewController:self];
    [PIN release];
}

- (IBAction)checkPIN {
    GCPINViewController *PIN = [[GCPINViewController alloc]
                                initWithNibName:@"PINViewDefault"
                                bundle:nil
                                mode:GCPINViewControllerModeVerify];
    PIN.delegate = self;
    PIN.messageText = @"Check Passcode";
    PIN.errorText = @"Incorrect passcode";
    [PIN presentPasscodeViewFromViewController:self];
    [PIN release];
}

- (BOOL)pinView:(GCPINViewController *)pinView validateCode:(NSString *)code {
    if (pinView.mode == GCPINViewControllerModeCreate) {
        NSLog(@"setting code: %@", code);
        return YES;
    }
    else if (pinView.mode == GCPINViewControllerModeVerify) {
        NSLog(@"checking code: %@", code);
        return [code isEqualToString:@"0187"];
    }
    else {
        return NO;
    }
}

@end
