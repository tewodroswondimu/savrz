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

@end

@implementation FBFriendsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsArray = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Send request to Facebook for all my friends
    FBRequest *request = [FBRequest requestWithGraphPath:@"me/taggable_friends" parameters:nil HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSLog(@"%@", friendObjects[1]);


            for (NSDictionary<FBGraphUser>*friend in friendObjects) {
//                NSLog(@"I have a friend named %@ with id %@", friend.name, friend.objectID);
                [self.friendsArray addObject:friend];
            }
            [self.tableView reloadData];
        }
    }];

//    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        if (!error) {
//            // result will contain an array with your user's friends in the "data" key
//            NSArray *friendObjects = [result objectForKey:@"data"];
//            NSLog(@"%@", friendObjects);
//        }
//    }];
}

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

@end
