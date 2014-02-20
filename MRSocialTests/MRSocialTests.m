//
//  MRSocialTests.m
//  MRSocialTests
//
//  Created by Jose Luis Martinez de la Riva on 18/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import <XCTest/XCTest.h>

// Classes
#import "MRTwitter.h"

// Library
#import <OCMock/OCMock.h>

@interface MRSocialTests : XCTestCase
@property(strong, nonatomic) MRTwitter *social;
@property(strong, nonatomic) id mockAccountStore;
@property(strong, nonatomic) id mockStorage;
@property (assign, nonatomic) BOOL done;
@end

@implementation MRSocialTests

- (void)setUp
{
    [super setUp];
    
    self.mockAccountStore = [OCMockObject mockForClass:[ACAccountStore class]];
    [[self.mockAccountStore stub] accountWithIdentifier:nil];
    
    self.mockStorage = [OCMockObject mockForProtocol:@protocol(MRSocialStorageProtocol)];
    
    self.social = [[MRTwitter alloc] initWithACAccountStore:self.mockAccountStore baseURL:nil];
    [self.social setStorage:self.mockStorage];
}

- (void)tearDown
{
    self.social = nil;
    [super tearDown];
}

- (void)testACAccountShouldBeStoreWhenNewACAccountIsSet
{
    id mockAccount = [OCMockObject niceMockForClass:[ACAccount class]];
    [[self.mockStorage expect] storeACAccountIdentifier:[OCMArg any] forKey:[OCMArg any]];
    
    [self.social setAccount:mockAccount];
    
    [self.mockStorage verify];
}

- (void)testRequestMethodWhenUserHasNoAccessShouldNotLaunchSLRequest
{
    id partialMockSocial = [OCMockObject partialMockForObject:self.social];
    [[[partialMockSocial stub] andReturnValue:@NO] userHasAccess];
    [[[partialMockSocial stub] andReturn:SLServiceTypeTwitter] serviceType];
    
    id mockSLRequest = [OCMockObject mockForClass:[SLRequest class]];
    [[[mockSLRequest stub] andThrow:[NSException new]] performRequestWithHandler:nil];
    
    [partialMockSocial requestWithMethod:SLRequestMethodGET
                                    path:@"foo"
                              parameters:@{@"foo": @"bar"}
                              completion:^(NSDictionary *response, NSError *error) {}];
}

- (void)testStoreIdentifierShouldUsedClassAsKey
{
    [[self.mockStorage expect] retrieveACAccountIdentifierForKey:NSStringFromClass(self.social.class)];
    
    [self.social account];
    
    [self.mockStorage verify];
}

- (void)testRetrieveIdentifierShouldUsedClassAsKey
{
    id mockAccount = [OCMockObject niceMockForClass:[ACAccount class]];
    [[self.mockStorage expect] storeACAccountIdentifier:[OCMArg any] forKey:NSStringFromClass(self.social.class)];
    
    [self.social setAccount:mockAccount];
    
    [self.mockStorage verify];
}

@end
