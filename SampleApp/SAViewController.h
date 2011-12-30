//
//  SAViewController.h
//  SampleApp
//
//  Created by Caleb Davenport on 12/29/11.
//  Copyright (c) 2011 GUI Cocoa, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCPINViewController.h"

@interface SAViewController : UIViewController <GCPINViewControllerDelegate>

- (IBAction)setPIN;
- (IBAction)checkPIN;

@end
