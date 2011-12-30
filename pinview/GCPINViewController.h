//
//  GCPINViewController.h
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright 2010 GUI Cocoa, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCPINViewController;
@protocol GCPINViewControllerDelegate <NSObject>
@required
- (BOOL)pinView:(GCPINViewController *)pinView validateCode:(NSString *)code;
@end

typedef enum {
    GCPINViewControllerModeCreate = 0,
    GCPINViewControllerModeVerify
} GCPINViewControllerMode;

@interface GCPINViewController : UIViewController <UITextFieldDelegate>

// nib properties
@property (nonatomic, retain) IBOutlet UILabel *fieldOneLabel;
@property (nonatomic, retain) IBOutlet UILabel *fieldTwoLabel;
@property (nonatomic, retain) IBOutlet UILabel *fieldThreeLabel;
@property (nonatomic, retain) IBOutlet UILabel *fieldFourLabel;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;
@property (nonatomic, retain) IBOutlet UITextField *inputField;

// view controller properties
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, copy) NSString *errorText;
@property (nonatomic, assign) id<GCPINViewControllerDelegate> delegate;
@property (nonatomic, retain) id userInfo;
@property (nonatomic, readonly, assign) GCPINViewControllerMode mode;

// object methods
- (id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle mode:(GCPINViewControllerMode)mode;
- (void)presentPasscodeViewFromViewController:(UIViewController *)controller;
- (void)dismissPasscodeView;

@end
