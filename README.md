# Passcode view

## Notice

I will not maintain this library any longer. Instead, I would suggest you look at [this one](https://github.com/project-imas/app-password) &mdash; also written by me &mdash; that is much more modern, flexible, and easily integrated into apps. It departs a bit from the system passcode view so that it can be highly customized.

## About

This project gives you a passcode control that can be dropped into any iOS app. It behaves exactly like the passcode screens that can be seen by going to Settings > General > Passcode Lock.

## Features

- Native iOS look and feel
- Masks pin entry with bullet characters
- Provide your own theme by using a custom nib file
- Provide custom text to be displayed on the passcode entry view
- Block-based passcode verification

## Installation

- Drag the "pinview" folder to your Xcode project (make sure "copy files", "create groups", and the appropriate target are selected)
- Add the AudioToolbox framework to your target

# Examples

Here are some quick examples. To see them in use, open the "SampleApp" Xcode project.

## Create a new passcode

````objc
GCPINViewController *PIN = [[GCPINViewController alloc]
                            initWithNibName:nil
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
````

## Verify a passcode

````objc
GCPINViewController *PIN = [[GCPINViewController alloc]
                            initWithNibName:nil
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
````
