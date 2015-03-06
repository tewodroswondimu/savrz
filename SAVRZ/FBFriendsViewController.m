//
//  FBFriendsViewController.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/5/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "FBFriendsViewController.h"

@interface FBFriendsViewController() <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *friendsArray;
@property NSMutableArray *selectedFriends;

@end

@implementation FBFriendsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsArray = [NSMutableArray new];
    self.selectedFriends = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Send request to Facebook for all my friends and loads into the friendsArray
    FBRequest *request = [FBRequest requestWithGraphPath:@"me/taggable_friends" parameters:nil HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSLog(@"%@", friendObjects[1]);


            for (NSDictionary<FBGraphUser>*friend in friendObjects) {
                [self.friendsArray addObject:friend];
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark -
#pragma mark TABLE VIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell"];
    FBGraphObject *friend = self.friendsArray[indexPath.row];
    cell.textLabel.text = friend[@"name"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [self.selectedFriends addObject:self.friendsArray[indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    [self.selectedFriends removeObject:self.friendsArray[indexPath.row]];
}

#pragma mark - 
#pragma mark UNWIND

- (NSMutableArray *)returnSelectedFriends
{
    return self.selectedFriends;
}


@end
