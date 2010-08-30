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

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *promptText;
@property (nonatomic, copy) NSString *errorText;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) id<GCPINViewControllerDelegate> delegate;

- (void)presentViewFromViewController:(UIViewController *)controller animated:(BOOL)animated;

@end
