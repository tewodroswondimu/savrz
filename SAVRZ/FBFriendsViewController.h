//
//  FBFriendsViewController.h
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/5/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface FBFriendsViewController : UITableViewController

/**
 *  returns an array of the selected frineds
 *
 *  @return NSArray of selected friends
 */
- (NSArray *)returnSelectedFriends;

@end
