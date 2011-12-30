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
    GCPINViewController *PIN = [[GCPINViewController alloc] initWithNibName:@"PINViewDefault" bundle:nil];
    [PIN presentViewFromViewController:self animated:YES];
    [PIN release];
}

@end
