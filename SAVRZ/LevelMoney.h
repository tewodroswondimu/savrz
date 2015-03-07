//
//  LevelAPIRequest.h
//  SAVRZ
//
//  Created by Tewodros Wondimu on 3/7/15.
//  Copyright (c) 2015 Tewodros Wondimu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelMoney : NSObject

+ (void)retrieveAccountDetailsWithUID:(NSString *)uid andToken:(NSString *)token withCompletionBlock:(void(^)(NSDictionary *accountDetails))complete;

+ (void)retrieveLoginDetailsWithEmail:(NSString *)email andPassword:(NSString *)password withCompletionBlock:(void(^)(NSDictionary *accountDetails))complete;

@end
