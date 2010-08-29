//
//  PINCodeAppDelegate.h
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright GUI Cocoa, LLC. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCPINViewController.h"

@interface PCAppDelegate : NSObject <UIApplicationDelegate, GCPINViewControllerDelegate> {
    UIWindow *window;
}

@end

