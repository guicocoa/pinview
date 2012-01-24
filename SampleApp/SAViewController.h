//
//  SAViewController.h
//  SampleApp
//
//  Created by Caleb Davenport on 12/29/11.
//  Copyright (c) 2011 GUI Cocoa, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAViewController : UIViewController {
    NSString *code;
}

@property (atomic, copy) NSString *code;

- (IBAction)setPIN;
- (IBAction)checkPIN;

@end
