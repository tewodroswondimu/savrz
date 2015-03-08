//
//  CreatePoolViewController.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/5/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "CreatePoolViewController.h"
#import "FBFriendsViewController.h"
#import "FriendsCollectionViewCell.h"
#import "Nexmo.h"

@interface CreatePoolViewController() <UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *poolNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountOfMoneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UIButton *addYourFriendsButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property UIPickerView *pickerView;
@property NSArray *duration;
@property NSArray *selectedFriendsArray;
@property NSMutableArray *selectedUsersArray;

@end

@implementation CreatePoolViewController

- (void)viewDidLoad
{
    self.selectedFriendsArray = [NSArray new];
    self.selectedUsersArray = [NSMutableArray new];

    self.duration = @[@"Daily", @"Weekly", @"Monthly", @"Yearly"];
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.periodTextField.inputView = self.pickerView;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.duration.count;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.periodTextField.text = self.duration[row];
    [self.periodTextField resignFirstResponder];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.duration[row];
}


// Retreieves the added friends list from the modal view that appears
- (IBAction)unwindFromAddFriends:(UIStoryboardSegue *)segue
{
    FBFriendsViewController *fbfvc = segue.sourceViewController;
    self.selectedFriendsArray = [fbfvc returnSelectedFriends];

    // Find the user info for the facebook account
    for (NSDictionary<FBGraphUser> *friend in self.selectedFriendsArray) {
        PFQuery *query = [PFUser query];
        NSLog(@"%@ %@", friend[@"id"], friend[@"name"]);
        [query whereKey:@"facebookID" equalTo:[NSString stringWithFormat:@"%@", friend[@"id"]]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count) {
                for (PFUser *facebookUser in objects) {
                    [self.selectedUsersArray addObject:facebookUser];
                }
            }
        }];
    }

    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
}

- (IBAction)onCreateButtonTapped:(UIBarButtonItem *)sender
{
    // Create a new pool object
    PFObject *poolObject = [PFObject objectWithClassName:@"Pools"];
    poolObject[@"PoolName"] = self.poolNameTextField.text;
    poolObject[@"CreatedBy"] = [PFUser currentUser];
    poolObject[@"Amount"] = [NSNumber numberWithFloat:[self.amountOfMoneyTextField.text floatValue]];
    poolObject[@"Period"] = self.periodTextField.text;

    // Add the creator as an owner
    [self.selectedUsersArray addObject:[PFUser currentUser]];

    // Saves all the owners of the pool
    PFRelation *relation = [poolObject relationForKey:@"Owners"];
    for (PFUser *owner in self.selectedUsersArray) {
        [relation addObject:owner];
        [Nexmo sendSMSToUserWithPhoneNumber:owner[@"phone"] andMessage:@"Someone added you to a pool" ithCompletionBlock:^(NSArray *messagesArray) {
            NSLog(@"%@", messagesArray);
        }];
    }

    poolObject[@"Winners"] = [self randomizeMutableArray:self.selectedUsersArray];
    [poolObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (NSArray *)randomizeMutableArray:(NSMutableArray *)mutableArray
{
    NSUInteger count = mutableArray.count;
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return [NSArray arrayWithArray:mutableArray];
}

#pragma mark -
#pragma mark COLLECTION VIEW

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsCell" forIndexPath:indexPath];
    FBGraphObject *friend = self.selectedFriendsArray[indexPath.row];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *imageURLString = friend[@"picture"][@"data"][@"url"];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.clipsToBounds = YES;
        cell.imageView.image = [UIImage imageWithData:imageData];
    });
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedFriendsArray.count;
}

@end
