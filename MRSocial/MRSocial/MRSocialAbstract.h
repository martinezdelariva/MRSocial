//
//  MRBaseProvider.h
//  MRSocial
//
//  Created by Jose Luis Martinez de la Riva on 18/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "MRSocialStorageProtocol.h"

@interface MRSocialAbstract : NSObject

@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) id<MRSocialStorageProtocol> storage;

- (instancetype)initWithACAccountStore:(ACAccountStore *)accountStore baseURL:(NSURL *)baseUrl;

- (BOOL)userHasAccess;

- (void)requestAccessWithCompletion:(ACAccount *(^)(NSArray *accounts, NSError *error))completion;

- (void)requestWithMethod:(SLRequestMethod)requestMethod
                     path:(NSString *)path
               parameters:(NSDictionary*)parameters
               completion:(void (^)(NSDictionary *response, NSError *error))completion;

// Direct methods to ACAccountStore
- (void)saveAccount:(ACAccount *)account withCompletionHandler:(ACAccountStoreSaveCompletionHandler)completionHandler;
- (void)renewCredentialsForAccount:(ACAccount *)account completion:(ACAccountStoreCredentialRenewalHandler)completionHandler;
- (void)removeAccount:(ACAccount *)account withCompletionHandler:(ACAccountStoreRemoveCompletionHandler)completionHandler;
@end
