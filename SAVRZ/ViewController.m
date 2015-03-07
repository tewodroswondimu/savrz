//
//  ViewController.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/5/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSString *location;
@property NSString *gender;
@property NSString *birthday;
@property NSString *username;
@property NSString *relationshipStatus;
@property UIImage *userProfileImage;

@property NSArray *poolsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self checkLoggedIn];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadPools];
}

#pragma mark -
#pragma mark TABLE VIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.poolsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoolsCell"];
    PFObject *pool = self.poolsArray[indexPath.row];
    cell.textLabel.text = pool[@"PoolName"];
    cell.detailTextLabel.text = pool[@"Period"];
    return cell;
}

- (void)checkLoggedIn
{
    // If the user isn't logged in display the login view controller
    if (![PFUser currentUser])
    {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    [PFUser logOut];
    
    [self checkLoggedIn];
}

- (void)loadPools
{
    PFQuery *poolsQuery = [PFQuery queryWithClassName:@"Pools"];
    PFUser *user = [PFUser currentUser];
    if (user) {
        [poolsQuery whereKey:@"CreatedBy" equalTo:user];
    }
    [poolsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.poolsArray = objects;
        [self.tableView reloadData];
    }];
}

- (void)loadData {

    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([PFUser currentUser]) {
        [self updateProfileData];
    }

    // Load all the pools that belong to this user
    if (!self.poolsArray.count) {
        [self loadPools];
    }

    if([PFFacebookUtils session]) {
        // Send request to Facebook
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            // handle response
            if (!error) {
                // Parse the data received
                NSDictionary *userData = (NSDictionary *)result;

                NSString *facebookID = userData[@"id"];


                NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];

                if (facebookID) {
                    userProfile[@"facebookId"] = facebookID;
                }

                NSString *name = userData[@"name"];
                if (name) {
                    userProfile[@"name"] = name;
                }

                NSString *location = userData[@"location"][@"name"];
                if (location) {
                    userProfile[@"location"] = location;
                }

                NSString *gender = userData[@"gender"];
                if (gender) {
                    userProfile[@"gender"] = gender;
                }

                NSString *birthday = userData[@"birthday"];
                if (birthday) {
                    userProfile[@"birthday"] = birthday;
                }

                NSString *relationshipStatus = userData[@"relationship_status"];
                if (relationshipStatus) {
                    userProfile[@"relationship"] = relationshipStatus;
                }

                userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];

                [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
                [[PFUser currentUser] saveInBackground];

                [self updateProfileData];

            } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                        isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                NSLog(@"The facebook session was invalidated");
            } else {
                NSLog(@"Some other error: %@", error);
            }
        }];
    }
}

// Set received values if they are not nil and reload the table
- (void)updateProfileData {
    NSString *location = [PFUser currentUser][@"profile"][@"location"];
    if (location) {
        self.location = location;
    }

    NSString *gender = [PFUser currentUser][@"profile"][@"gender"];
    if (gender) {
        self.gender = gender;
    }

    NSString *birthday = [PFUser currentUser][@"profile"][@"birthday"];
    if (birthday) {
        self.birthday = birthday;
    }

    NSString *relationshipStatus = [PFUser currentUser][@"profile"][@"relationship"];
    if (relationshipStatus) {
        self.relationshipStatus = relationshipStatus;
    }

    // Set the name in the header view label
    NSString *name = [PFUser currentUser][@"profile"][@"name"];
    if (name) {
        self.username = name;
    }

    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       self.userProfileImage = [UIImage imageWithData:data];
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
    NSLog(@"%@ is a %@ born on %@ with a relationship status of %@", self.username, self.gender, self.birthday, self.relationshipStatus);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
