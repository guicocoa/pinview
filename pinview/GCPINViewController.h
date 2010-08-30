//
//  GCPINViewController.h
//  PINCode
//
//  Created by Caleb Davenport on 8/28/10.
//  Copyright 2010 GUI Cocoa, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCPINViewControllerDelegate <NSObject>
@required
- (BOOL)isPINCodeValid:(NSString *)PIN;
@end

@interface GCPINViewController : UIViewController <UITextFieldDelegate> {
@private
	IBOutlet UILabel *fieldOneLabel;
	IBOutlet UILabel *fieldTwoLabel;
	IBOutlet UILabel *fieldThreeLabel;
	IBOutlet UILabel *fieldFourLabel;
	IBOutlet UILabel *promptLabel;
	IBOutlet UILabel *errorLabel;
	IBOutlet UITextField *inputField;
	NSArray *pinFields;
	NSString *titleText;
	NSString *promptText;
	NSString *errorText;
	BOOL secureTextEntry;
	id<GCPINViewControllerDelegate> delegate;
}

// title as displayed in the navigation bar
@property (nonatomic, copy) NSString *titleText;
// grey subtext above the pin code fields
@property (nonatomic, copy) NSString *promptText;
// red subtext below the pin code fields
// hidden until you return NO in the isPINCodeValid: method
@property (nonatomic, copy) NSString *errorText;
// allows you to mask the input with bullet characters
// defaults to YES
@property (nonatomic, assign) BOOL secureTextEntry;
// delegate
@property (nonatomic, assign) id<GCPINViewControllerDelegate> delegate;

// this creates a navigation controller to encapsulate the pin view and presents it as a modal view
- (void)presentViewFromViewController:(UIViewController *)controller animated:(BOOL)animated;

@end
