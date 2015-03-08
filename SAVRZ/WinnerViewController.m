//
//  WinnerViewController.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/8/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "WinnerViewController.h"

@interface WinnerViewController()

@property (weak, nonatomic) IBOutlet UIImageView *winnerImageView;
@property (weak, nonatomic) IBOutlet UILabel *winnerName;

@end

@implementation WinnerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Display the image of the user
    NSString *imageURLString = self.user[@"profile"][@"pictureURL"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.winnerImageView.layer.cornerRadius = 10;
    self.winnerImageView.clipsToBounds = YES;
    self.winnerImageView.image = image;
    self.title = self.user[@"profile"][@"name"];
    self.winnerName.text = self.user[@"profile"][@"name"];
}

@end
