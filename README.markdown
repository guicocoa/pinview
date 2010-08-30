ADD TO YOUR PROJECT:
====
- open the PINView Xcode project
- drag the pinview group into your project

USE THIS CODE:
====
- create the pin view object using the initWithNIBName:bundle: of UIViewController
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