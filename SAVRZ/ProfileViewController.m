//
//  ProfileViewController.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/7/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "ProfileViewController.h"
#import "LevelMoney.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *uidTextField;
@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.uidTextField.text = @"1110570166";
//    self.tokenTextField.text = @"63C08C4AA6E3CB1A4B13C9C5299365C0";
//    self.uidTextField.text = @"1110570164";
//    self.tokenTextField.text = @"119947F2D985C3788998543A3D3AD90C";
}

- (IBAction)onExitButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (IBAction)onConnectWithAccount:(UIButton *)sender {
    [LevelMoney retrieveAccountDetailsWithUID:self.uidTextField.text andToken:self.tokenTextField.text withCompletionBlock:^(NSDictionary *accountDetails) {

        // Save account details and attached to the current user
        PFObject *accountDetailsObject = [PFObject objectWithClassName:@"AccountDetails"];
        accountDetailsObject[@"accountID"] = accountDetails[@"account-id"];
        accountDetailsObject[@"accountName"] = accountDetails[@"account-name"];
        accountDetailsObject[@"accountType"] = accountDetails[@"account-type"];
        accountDetailsObject[@"active"] = accountDetails[@"active"];
        accountDetailsObject[@"balance"] = accountDetails[@"balance"];
        accountDetailsObject[@"institutionName"] = accountDetails[@"institution-name"];
        accountDetailsObject[@"lastDigits"] = accountDetails[@"last-digits"];
        accountDetailsObject[@"legacyID"] = accountDetails[@"legacy-institution-id"];
        [accountDetailsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                PFUser *user = [PFUser currentUser];
                user[@"AccountDetail"] = accountDetailsObject;
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSLog(@"Account connected");
                }];
            }
        }];
    }];
}

@end
