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

- (IBAction)setPIN {
    GCPINViewController *PIN = [[GCPINViewController alloc]
                                initWithNibName:@"PINViewDefault"
                                bundle:nil
                                mode:GCPINViewControllerModeCreate];
    PIN.messageText = @"Create Passcode";
    PIN.errorText = @"The passcodes do not match";
    PIN.verifyBlock = ^(NSString *code) {
        NSLog(@"setting code: %@", code);
        return YES;
    };
    [PIN presentFromViewController:self animated:YES];
    [PIN release];
}

- (IBAction)checkPIN {
    GCPINViewController *PIN = [[GCPINViewController alloc]
                                initWithNibName:@"PINViewDefault"
                                bundle:nil
                                mode:GCPINViewControllerModeVerify];
    PIN.messageText = @"Check Passcode";
    PIN.errorText = @"Incorrect passcode";
    PIN.verifyBlock = ^(NSString *code) {
        NSLog(@"checking code: %@", code);
        return [code isEqualToString:@"0187"];
    };
    [PIN presentFromViewController:self animated:YES];
    [PIN release];
}

@end
