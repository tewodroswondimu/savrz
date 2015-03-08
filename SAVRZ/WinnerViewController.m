//
//  WinnerViewController.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/8/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "WinnerViewController.h"

@implementation WinnerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.user[@"profile"][@"name"];
}

@end
