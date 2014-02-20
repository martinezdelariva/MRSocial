//
//  MRBaseProvider.m
//  MRSocial
//
//  Created by Jose Luis Martinez de la Riva on 18/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import "MRSocialAbstract.h"

NSString *const MRSocialErrorDomain = @"MRSocialErrorDomain";
NSString *const MRSocialErrorGranted = @"1";
NSString *const MRSocialErrorBadResponse = @"2";

@interface MRSocialAbstract ()
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSURL *baseUrl;
@end

@implementation MRSocialAbstract

#pragma mark - Designated initializer

- (instancetype)initWithACAccountStore:(ACAccountStore *)accountStore baseURL:(NSURL *)baseUrl
{
    self = [super init];
    if (self) {
        _baseUrl = baseUrl;
        _accountStore = accountStore;
        
        [self addObserver:self forKeyPath:@"account" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self] && [keyPath isEqualToString:@"account"]) {
        [self.storage storeACAccountIdentifier:_account.identifier forKey:[self storageKey]];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"account"];
}

#pragma mark - Abstract Template Methods

- (NSString *)serviceType
{
    NSAssert(false, @"Method %@ must be implemented in class %@", NSStringFromSelector(_cmd), NSStringFromClass(self.class));
    return nil;
}

- (NSString *)accountTypeIdentifier
{
    NSAssert(false, @"Method %@ must be implemented in class %@", NSStringFromSelector(_cmd), NSStringFromClass(self.class));
    return nil;
}

- (NSDictionary *)options
{
    NSAssert(false, @"Method %@ must be implemented in class %@", NSStringFromSelector(_cmd), NSStringFromClass(self.class));
    return nil;
}

#pragma mark - ACAccountStore methods

- (void)requestAccessWithCompletion:(ACAccount *(^)(NSArray *accounts, NSError *error))completion;
{
    __weak __typeof(self) weakSelf = self;
    [self.accountStore
        requestAccessToAccountsWithType:[self accountType]
                                options:[self options]
                             completion:^(BOOL granted, NSError *error) {
                                 if (error) {
                                     completion(nil, error);
                                     return;
                                 }
                                 
                                 NSArray *accounts = [self.accountStore accountsWithAccountType:[weakSelf accountType]];
                                 if (granted && accounts) {
                                     self.account = completion(accounts, nil);
                                 } else {
                                     completion(nil, [weakSelf errorGranted]);
                                 }
                             }];
}

- (void)requestWithMethod:(SLRequestMethod)requestMethod
                     path:(NSString *)path
               parameters:(NSDictionary*)parameters
               completion:(void (^)(NSDictionary *response, NSError *error))completion
{
    if (![self userHasAccess]) {
        completion(nil, [self errorGranted]);
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    SLRequest *request = [SLRequest requestForServiceType:[self serviceType]
                                            requestMethod:requestMethod
                                                      URL:[self.baseUrl URLByAppendingPathComponent:path]
                                               parameters:parameters];
    [request setAccount:self.account];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        if (urlResponse.statusCode < 200 || urlResponse.statusCode >= 300) {
            if (urlResponse.statusCode == 400) {
                completion(nil, [weakSelf errorGranted]);
            } else {
                completion(nil, [weakSelf errorBadResponse]);
            }
            return;
        }
        
        NSError *jsonError;
        NSDictionary *responseDict = [weakSelf JSONDataToDictionary:responseData error:&jsonError];
        if (jsonError) {
            completion(nil, jsonError);
        } else {
            completion(responseDict, nil);
        }
    }];
}

- (void)saveAccount:(ACAccount *)account withCompletionHandler:(ACAccountStoreSaveCompletionHandler)completionHandler
{
    [self.accountStore saveAccount:account withCompletionHandler:completionHandler];
}

- (void)renewCredentialsForAccount:(ACAccount *)account completion:(ACAccountStoreCredentialRenewalHandler)completionHandler
{
    [self.accountStore renewCredentialsForAccount:account completion:completionHandler];
}

- (void)removeAccount:(ACAccount *)account withCompletionHandler:(ACAccountStoreRemoveCompletionHandler)completionHandler
{
    [self.accountStore removeAccount:account withCompletionHandler:completionHandler];
}

- (BOOL)userHasAccess
{
    return [SLComposeViewController isAvailableForServiceType:[self serviceType]];
}

#pragma mark

- (ACAccountType *)accountType
{
    return [self.accountStore accountTypeWithAccountTypeIdentifier:[self accountTypeIdentifier]];
}

- (NSError *)errorGranted
{
    NSString *description =
        [NSString stringWithFormat:NSLocalizedString(@"Access to %@ was not granted", @""), [self serviceType]];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : description};
    
    return [NSError errorWithDomain:MRSocialErrorDomain
                               code:[MRSocialErrorGranted integerValue]
                           userInfo:userInfo];
}

- (NSError *)errorBadResponse
{
    NSString *description = [NSString stringWithFormat:NSLocalizedString(@"Bad response from %@", @""), [self serviceType]];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : description};
    
    return [NSError errorWithDomain:MRSocialErrorDomain
                               code:[MRSocialErrorBadResponse integerValue]
                           userInfo:userInfo];
}

- (NSDictionary *)JSONDataToDictionary:(NSData *)JSONdata error:(NSError **)error
{
    return [NSJSONSerialization JSONObjectWithData:JSONdata
                                           options:NSJSONReadingAllowFragments
                                             error:error];
}

- (NSString *)storageKey
{
    return NSStringFromClass(self.class);
}

#pragma mark - Getters / Setters

- (ACAccount *)account
{
    if (!_account) {
        NSString *identifier = [self.storage retrieveACAccountIdentifierForKey:[self storageKey]];
        _account = [self.accountStore accountWithIdentifier:identifier];
    }
    return _account;
}

- (void)setBaseUrl:(NSURL *)baseUrl
{
    if ([[baseUrl path] length] > 0 && ![[baseUrl absoluteString] hasSuffix:@"/"]) {
        baseUrl = [baseUrl URLByAppendingPathComponent:@"/"];
    }
    _baseUrl = baseUrl;
}

@end
