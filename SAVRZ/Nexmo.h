//
//  Nexmo.h
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/7/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Nexmo : NSObject

+ (void)sendSMSToUserWithPhoneNumber:(NSString *)phoneNumber andMessage:(NSString *)message ithCompletionBlock:(void(^)(NSArray *messagesArray))complete;

@end
