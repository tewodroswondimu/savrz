//
//  Nexmo.m
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/7/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import "Nexmo.h"

#define apiKey @"3578ec45"
#define apiSecret @"17c2bd05"

@implementation Nexmo

+ (void)sendSMSToUserWithPhoneNumber:(NSString *)phoneNumber andMessage:(NSString *)message ithCompletionBlock:(void(^)(NSArray *messagesArray))complete
{
    // URL for finding the accounts
    NSString *modifiedMessage = [message stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *urlString = [NSString stringWithFormat:@"https://rest.nexmo.com/sms/json?api_key=%@&api_secret=%@&from=12529178653&to=%@&text=%@", apiKey, apiSecret, phoneNumber, modifiedMessage];
    NSURL *url = [NSURL URLWithString:urlString];

    // Setup a URL Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSASCIIStringEncoding error:&error];
            if (!error) {
                NSArray *messagesArray = response[@"messages"];
                complete(messagesArray);
            }
            else
            {
                NSLog(@"Error retrieving results from Level Money");
            }
        }
    }];
}

@end
