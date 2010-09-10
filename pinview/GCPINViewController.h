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

@interface GCPINViewController : UIViewController <UITextFieldDelegate> {
@private
	IBOutlet UILabel *fieldOneLabel;
	IBOutlet UILabel *fieldTwoLabel;
	IBOutlet UILabel *fieldThreeLabel;
	IBOutlet UILabel *fieldFourLabel;
	
	IBOutlet UILabel *messageLabel;
	IBOutlet UILabel *errorLabel;
	IBOutlet UITextField *inputField;
	
	NSArray *pinFields;
	NSString *messageText;
	NSString *errorText;
	NSString *PINText;
	
	BOOL secureTextEntry;
	
	id<GCPINViewControllerDelegate> delegate;
	
	id userInfo;
}

@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, copy) NSString *errorText;
@property (nonatomic, copy) NSString *PINText;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) id<GCPINViewControllerDelegate> delegate;
@property (nonatomic, retain) id userInfo;

- (void)presentViewFromViewController:(UIViewController *)controller animated:(BOOL)animated;

@end
