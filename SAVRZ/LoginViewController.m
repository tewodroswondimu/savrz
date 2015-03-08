//
//  LoginViewController.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/5/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    self.facebookLoginButton.layer.cornerRadius = 10;
    self.facebookLoginButton.clipsToBounds = YES;
}

- (IBAction)onLoginWithFacebookButtonPressed:(UIButton *)sender {
    NSArray *permissionsArray = @[@"user_about_me", @"user_friends"];

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
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // Store the current user's Facebook ID on the user
                        [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                                 forKey:@"facebookID"];
                        [[PFUser currentUser] saveInBackground];
                    }
                }];
            } else {
                NSLog(@"User with facebook logged in!");

            }
        }

        [self dismissViewControllerAnimated:YES completion:^{

        }];
    }];
}

@end
