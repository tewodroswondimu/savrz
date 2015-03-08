//
//  PoolDetailViewController.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/7/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "PoolDetailViewController.h"
#import "WinnerViewController.h"
#import "Nexmo.h"

@interface PoolDetailViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *winnersArray;
@property NSTimer *winnerTimer;
@property int count;

@end

@implementation PoolDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.winnersArray = [NSMutableArray new];
    self.count = 0;
    self.winnerTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(winnerTimer:) userInfo:nil repeats:YES];

    self.title = self.pool[@"PoolName"];
}

- (void)stopWinnerTimer
{
    [self.winnerTimer invalidate];
    self.winnerTimer = nil;
}

// Shows the winners using a timer
- (void)winnerTimer:(NSTimer *)timer
{
    NSArray *poolWinners = self.pool[@"Winners"];

    PFUser *user = poolWinners[self.count];
    [user fetch];
    [self.winnersArray addObject:user];
    self.count += 1;

    // Send the user a message notifying them that they have won
//    [Nexmo sendSMSToUserWithPhoneNumber:user[@"phone"] andMessage:@"You just won the pool" ithCompletionBlock:^(NSArray *messagesArray) {
//        NSLog(@"%@", messagesArray);
//    }];

    if (self.count == poolWinners.count) {
        [self stopWinnerTimer];
    }
    [self.tableView reloadData];
}

#pragma mark TABLE VIEW

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Winners";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.winnersArray.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WinnerViewController *wvc = segue.destinationViewController;
    wvc.user = self.winnersArray[self.tableView.indexPathForSelectedRow.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WinnersCell"];
    PFUser *user = self.winnersArray[indexPath.row];

//    if (indexPath.length == self.winnersArray.count) {
//        // Buy button
//        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
//        [buyButton setFrame:CGRectMake(0, 0, 50, 35)];
//        cell.accessoryView = buyButton;
//    } else
//    {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (user) {
            cell.textLabel.text = user[@"profile"][@"name"];
            NSString *imageURLString = user[@"profile"][@"pictureURL"];
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.clipsToBounds = YES;
            cell.imageView.image = [UIImage imageWithData:imageData];
        }
    });
    return cell;
}

@end
