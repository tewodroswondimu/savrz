//
//  LevelAPIRequest.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/7/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "LevelMoney.h"

#define accept @"application/json"
#define httpMethod @"POST"
#define contentType @"application/json"
#define apitoken @"HackathonApiToken"

@implementation LevelMoney

+ (void)retrieveAccountDetailsWithUID:(NSString *)uid andToken:(NSString *)token withCompletionBlock:(void(^)(NSDictionary *accountDetails))complete
{
    // URL for finding the accounts
    NSString *urlString = @"https://api.levelmoney.com/api/v2/hackathon/get-accounts";
    NSURL *url = [NSURL URLWithString:urlString];

    // Setup a URL Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:httpMethod];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:accept forHTTPHeaderField:@"Accept"];

    NSDictionary *args = @{
                           @"uid": [NSNumber numberWithInt:[uid intValue]],
                           @"token": token,
                           @"api-token": apitoken
                           };
    NSDictionary *dictionary = @{@"args":args };
    NSData *finalJSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    [request setHTTPBody:finalJSONData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSASCIIStringEncoding error:&error];
            if (!error) {
                NSArray *accountsArray = response[@"accounts"];
                NSDictionary *accountDetails = accountsArray[1];
                complete(accountDetails);
            }
            else
            {
                NSLog(@"Error retrieving results from Level Money");
            }
        }
    }];
}

+ (void)retrieveLoginDetailsWithEmail:(NSString *)email andPassword:(NSString *)password withCompletionBlock:(void(^)(NSDictionary *accountDetails))complete
{
    // URL for login
    NSString *urlString = @"https://api.levelmoney.com/api/v2/hackathon/login";
    NSURL *url = [NSURL URLWithString:urlString];

    // Setup a URL Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:httpMethod];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:accept forHTTPHeaderField:@"Accept"];

    NSDictionary *dictionary = @{
                                 @"email":email,
                                 @"password":password
                                };
    NSData *finalJSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    [request setHTTPBody:finalJSONData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSASCIIStringEncoding error:&error];
            if (!error) {
                complete(response);
            }
            else
            {
                NSLog(@"Error retrieving results from Level Money");
            }
        }
    }];
}

@end
