//
//  LoginViewController.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/5/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (IBAction)onLoginWithFacebookButtonPressed:(UIButton *)sender {
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {

        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
        }

        [self dismissViewControllerAnimated:YES completion:^{

        }];
    }];
}

@end
