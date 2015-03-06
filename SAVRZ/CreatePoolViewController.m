//
//  CreatePoolViewController.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/5/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "CreatePoolViewController.h"
#import "FBFriendsViewController.h"

@interface CreatePoolViewController() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *poolNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountOfMoneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UIButton *addYourFriendsButton;

@property UIPickerView *pickerView;
@property NSArray *duration;

@end

@implementation CreatePoolViewController

- (void)viewDidLoad
{

    self.duration = @[@"Daily", @"Monthly", @"Yearly"];
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
    NSMutableArray *friendsArray = [fbfvc returnSelectedFriends];
    NSLog(@"%@", friendsArray);
}

@end
