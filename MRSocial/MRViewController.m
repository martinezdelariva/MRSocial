//
//  MRViewController.m
//  MRSocial
//
//  Created by Jose Luis Martinez de la Riva on 18/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

NSString *const FACEBOOK_APP_ID = @"";

#import "MRViewController.h"

// Classes
#import "MRTwitter.h"
#import "MRFacebook.h"
#import "MRStorageUserDefaults.h"

@interface MRViewController ()
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) MRTwitter *twitter;
@property (strong, nonatomic) MRFacebook *facebook;
@end

@implementation MRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - IBActions

- (IBAction)twitterRequestAccessTapped:(id)sender
{
    [self.twitter requestAccessWithCompletion:^ACAccount *(NSArray *accounts, NSError *error) {
        NSLog(@"accounts: %@", accounts);
        NSLog(@"error: %@", error);
        
        return [accounts lastObject];
    }];

}

- (IBAction)twitterTimelineTapped:(id)sender
{
    [self.twitter requestWithMethod:SLRequestMethodGET
                               path:@"statuses/home_timeline.json"
                         parameters:@{@"count" : @"2"}
                         completion:^void (NSDictionary *response, NSError *error) {
                             NSLog(@"response: %@", response);
                             NSLog(@"error: %@", error);
                         }];
}
- (IBAction)facebookAccessTapped:(id)sender
{
    [self.facebook requestAccessWithCompletion:^ACAccount *(NSArray *accounts, NSError *error) {
        NSLog(@"accounts: %@", accounts);
        NSLog(@"accounts: %@", [[accounts lastObject] valueForKeyPath:@"properties"]);
        NSLog(@"error: %@", error);

        return [accounts lastObject];
    }];
}

- (IBAction)facebookMefriendsAccessTapped:(id)sender
{
    [self.facebook requestWithMethod:SLRequestMethodGET
                                path:@"me"
                          parameters:@{@"fields" :
                                        @"bio,birthday,cover,email,first_name,gender,languages,last_name,"
                                        @"link,location,picture,relationship_status"
                                     }
                          completion:^void (NSDictionary *response, NSError *error) {
                             NSLog(@"response: %@", response);
                             NSLog(@"error: %@", error);
                         }];
}

#pragma marl -

- (MRTwitter *)twitter
{
    if (!_twitter) {
        _twitter = [[MRTwitter alloc] initWithACAccountStore:self.accountStore
                                                     baseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/"]];
        _twitter.storage = [[MRStorageUserDefaults alloc] init];
    }
    
    return _twitter;
}

- (MRFacebook *)facebook
{
    if (!_facebook) {
        _facebook = [[MRFacebook alloc] initWithACAccountStore:self.accountStore
                                                       baseURL:[NSURL URLWithString:@"https://graph.facebook.com/"]];
        _facebook.configuration = @{
            ACFacebookAppIdKey          : FACEBOOK_APP_ID,
            ACFacebookPermissionsKey    : @[@"email", @"read_stream", @"user_relationships"],
            ACFacebookAudienceKey       : ACFacebookAudienceEveryone
        };
        _facebook.storage = [[MRStorageUserDefaults alloc] init];
    }
    
    return _facebook;
}

- (ACAccountStore *)accountStore
{
    if (!_accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    
    return _accountStore;
}

@end
