//
//  main.m
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright GUI Cocoa, LLC. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"PCAppDelegate");
    [pool release];
    return retVal;
}
