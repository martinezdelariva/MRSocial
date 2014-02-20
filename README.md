# MRSocial

`MRSocial` is a wrapper around `ACAccountStore` and `Social` framework. 


## API Reference

- Request access to `ACAccounts`.
- Send requests to a social networking service.

Please refer to the header file [`MRSocialAbstract.h`] for a complete overview of the capabilities of the class.

## Installation

Copy files from folder `/MRSocial/MRSocial/*` into your project.

## Usage

**Important**: create only one instance of `ACAccountStore`.

##### Twitter

Initialize Twitter:

```objc
MRTwitter *twitter = [[MRTwitter alloc] initWithACAccountStore:[[ACAccountStore alloc] init]
                                                       baseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/"]];
twitter.storage = [[MRStorageUserDefaults alloc] init]; // If you want to use a storage
```

Request access to Twitter accounts:

```objc
[twitter requestAccessWithCompletion:^ACAccount *(NSArray *accounts, NSError *error) {
	NSLog(@"accounts: %@", accounts);
    NSLog(@"error: %@", error);
        
    return [accounts lastObject]; // Choose ACAccount for future request. iOS could hold > 1 Twitter account
}];
```

Or you can set Twitter ACAccount after request access:

```objc
[twitter setAccount:selectedAccount];
```

Get timeline:

```objc
[twitter requestWithMethod:SLRequestMethodGET
                      path:@"statuses/home_timeline.json"
                parameters:@{@"count" : @"2"}
                completion:^void (NSDictionary *response, NSError *error) {
                    NSLog(@"response: %@", response);
                    NSLog(@"error: %@", error);
                }];
```

##### Facebook

Initialize Facebook:

```objc
MRFaceebook *facebbok = [[MRFaceebook alloc] initWithACAccountStore:[[ACAccountStore alloc] init]
                                                            baseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/"]];
facebook.configuration = @{
   ACFacebookAppIdKey          : @"", // FACEBOOK_APP_ID
   ACFacebookPermissionsKey    : @[@"email", @"read_stream", @"user_relationships"],
   ACFacebookAudienceKey       : ACFacebookAudienceEveryone
};                                                                
```

Request access to Facebook accounts:

```objc
[facebook requestAccessWithCompletion:^ACAccount *(NSArray *accounts, NSError *error) {
    NSLog(@"accounts: %@", accounts);
    NSLog(@"error: %@", error);
        
    return [accounts lastObject]; // Choose ACAccount for future request. iOS could hold only 1 Facebook account
}];
```

Get personal data:

```objc
[facebook requestWithMethod:SLRequestMethodGET
                       path:@"me"
                 parameters:@{@"fields" :
                               @"bio,birthday,cover,email,first_name,gender,languages,last_name,"
                               @"link,location,picture,relationship_status"
                             }
                 completion:^void (NSDictionary *response, NSError *error) {
                     			NSLog(@"response: %@", response);
                     			NSLog(@"error: %@", error);
                 }];
```

##### Sina Weibo

Initialize Sina Weibo:

```objc
MRSinaWeibo *sinaWeibo = [[MRSinaWeibo alloc] initWithACAccountStore:[[ACAccountStore alloc] init]
                                                             baseURL:[NSURL URLWithString:@"https://api.weibo.com/2/"]];                                                               
```

Request access to Sina Weibo accounts:

```objc
[sinaWeibo requestAccessWithCompletion:^ACAccount *(NSArray *accounts, NSError *error) {
    NSLog(@"accounts: %@", accounts);
    NSLog(@"error: %@", error);
        
    return [accounts lastObject];
}];        
```

## Protocols

##### MRSocialStorageProtocol

`MRSocialAbstract` has a `id<MRACAccountIdentifierStorageProtocol> storage` property that store/retrieve the ACAccount's identifer.
With this identifier, `ACAcountStore` can return the `ACAccount` object which is needed to perform social requests. 
Using the storage, it isn't needed to ask for access to `ACAcountStore` each time that an `ACAccount` is required.

As an example, class `MRStorageUserDefaults` that implement protocol `MRACAccountIdentifierStorageProtocol` is provided.

## Documents

- Twitter API docs: [link](https://dev.twitter.com/docs/api/1.1).
- Facebook permissions `ACFacebookPermissionsKey`: [link](https://developers.facebook.com/docs/facebook-login/permissions/).
- Facebbok graph API: [link](https://developers.facebook.com/docs/graph-api/reference). 
- Sina Weibo API: [link](http://open.weibo.com/wiki/API).

## FAQ

1. ¿How to create a FACEBOOK_APP_ID?
	- Go to [https://developers.facebook.com/](https://developers.facebook.com/).
	- Once logged click on the **apps** in top navigation bar.
	- Click on *create new app*.
	- Add iOS platform.
	- Set the **same** bundle ID that you have in XCode.
	
2. Sina Weibo not appearing in iOS Settings

	From the documentation:
	
	*Important: For Sina Weibo integration, users must have the Chinese keyboard enabled. Users can enable this keyboard in Settings > General > Keyboard. If a 	Chinese keyboard is not enabled, users wont be prompted to sign in to their Sina Weibo account.*


## Requirements

- iOS >= 7.0
- ARC


## License

// TODO
