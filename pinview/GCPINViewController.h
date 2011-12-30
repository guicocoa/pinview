//
//  GCPINViewController.h
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright 2010 GUI Cocoa, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    /*
     
     Create a new passcode. This allows the user to enter a new passcode then
     imediately verify it.
     
     */
    GCPINViewControllerModeCreate = 0,
    
    /*
     
     Verify a passcode. This allows the user to input a passcode then have it
     checked by the caller.
     
     */
    GCPINViewControllerModeVerify
    
} GCPINViewControllerMode;

typedef BOOL (^GCPasscodeVerifyBlock) (NSString *code);

/*
 
 This class defines a common passcode control that can be dropped into an app.
 It behaves exactly like the passcode screens that can be seen by going to
 Settings > General > Passcode Lock.
 
 */
@interface GCPINViewController : UIViewController <UITextFieldDelegate>

/*
 
 Set the text to display text above the input area.
 
 */
@property (nonatomic, copy) NSString *messageText;

/*
 
 Set the text to display below the input area when the passcode fails
 verification.
 
 */
@property (nonatomic, copy) NSString *errorText;

/*
 
 Called when a passcode has passed internal verification and needs to be
 approved for use by the application. When creating a new passcode, this is not
 called until the user has input the same passcode twice. Return YES to signal
 that the passcode meets required standards (when creating a new passcode) or
 that it is correct (when verifying an existing passcode) and NO to signal that
 the user needs to try again. You are free to present alerts in this block
 offering more information to the user.
 
 */
@property (nonatomic, copy) GCPasscodeVerifyBlock verifyBlock;

/*
 
 Refer to `GCPINViewControllerMode`. This can only be set through the
 designated initializer.
 
 */
@property (nonatomic, readonly, assign) GCPINViewControllerMode mode;

/*
 
 Create a new passcode view controller providing the nib name, bundle, and
 desired mode. This is the designated initializer.
 
 */
- (id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle mode:(GCPINViewControllerMode)mode;

/*
 
 Present the receiver from the given view controller. This is a convenience
 method and wraps the receiver in a navigation controller before showing
 modally.
 
 */
- (void)presentFromViewController:(UIViewController *)controller animated:(BOOL)animated;

// nib properties
@property (nonatomic, retain) IBOutlet UILabel *fieldOneLabel;
@property (nonatomic, retain) IBOutlet UILabel *fieldTwoLabel;
@property (nonatomic, retain) IBOutlet UILabel *fieldThreeLabel;
@property (nonatomic, retain) IBOutlet UILabel *fieldFourLabel;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;
@property (nonatomic, retain) IBOutlet UITextField *inputField;

@end
