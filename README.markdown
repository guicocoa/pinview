ABOUT:
====

This project gives you a drop-in PIN code entry screen that looks like the entry screen seen in Settings.app.

Features:
----
- native iOS look and feel
- mask pin entry with bullet characters or optionally show the actual input
- provide your own theme by providing a custom NIB file
- provide custom text to be displayed on the PIN entry view
- delegate methods allow you to verify the user-provided PIN code

ADD TO YOUR PROJECT:
====

- open the PINView Xcode project
- drag the pinview group into your project (make sure copy files is selected)

USE THIS CODE:
====

- create the pin view object using the initWithNibName:bundle: of UIViewController
- set the delegate on the view controller (YOU MUST DO THIS)
- implement the isPINCodeValid: delegate method to allow validation of the provided code
- set options like the view title or error text
- display from a view controller using the presentViewFromViewController:animated: convenience method

EXAMPLE:
====

Delegate Method
----

    - (BOOL)isPINCodeValid:(NSString *)PIN {
      return [PIN isEqualToString:@"1234"];
    }

Create View
----

    GCPINViewController *pinView = [[GCPINViewController alloc] initWithNibName:@"PINViewDefault" bundle:nil];
    [pinView setDelegate:self];
    [pinView setPromptText:@"Enter Your PIN"];
    [pinView setTitleText:@"PIN Code"];
    [pinView setErrorText:@"Awww You Suck"];

THEMES:
====

I haven't tested this, but you should be able to create a custom NIB file containing the appropriate elements changing the background or keyboard style (dark vs. default)

Just change the NIB name you pass in the initWithNibName:bundle call